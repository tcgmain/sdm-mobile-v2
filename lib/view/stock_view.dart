import 'package:flutter/material.dart';
import 'package:sdm/blocs/stock_bloc.dart';
import 'package:sdm/models/stock.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StockView extends StatefulWidget {
  final String userNummer;
  final String organizationNummer;
  final String organizationName;
  final bool isTeamMemberUi;

  const StockView({
    super.key,
    required this.userNummer,
    required this.organizationNummer,
    required this.organizationName,
    required this.isTeamMemberUi,
  });

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  late StockBloc _stockBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Product>? _filteredProducts;
  List<Product>? _allProducts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _stockBloc = StockBloc();
    _stockBloc.getProductStock(widget.userNummer, widget.organizationNummer);
    _searchController.addListener(_onSearchChanged);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _stockBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredProducts = _allProducts
          ?.where((products) =>
              products.yproddesc!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              products.yprodnummer!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Stock Information',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: text_field.TextField(
                        controller: _searchController,
                        obscureText: false,
                        inputType: 'none',
                        isRequired: true,
                        fillColor: CustomColors.textFieldFillColor,
                        filled: true,
                        labelText: "Type to search product...",
                        onChangedFunction: () {}),
                  ),
                  Expanded(
                    child: StreamBuilder<Response<Stock>>(
                      stream: _stockBloc.stockStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status!) {
                            case Status.LOADING:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = true;
                                });
                              });

                            case Status.COMPLETED:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                              _allProducts = snapshot.data!.data!.table;
                              _filteredProducts ??= _allProducts;

                              if (_filteredProducts!.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No products found",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                  ),
                                );
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total products of ${widget.organizationName}: ${_allProducts?.length}',
                                      style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              CustomColors.tableBackgroundColor1,
                                              CustomColors.tableBackgroundColor2
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          //border: Border.all(color: Colors.white, width: 1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: SfDataGrid(
                                          rowHeight: 60,
                                          gridLinesVisibility: GridLinesVisibility.both,
                                          headerGridLinesVisibility: GridLinesVisibility.both,
                                          columnWidthMode: ColumnWidthMode.fill,
                                          isScrollbarAlwaysShown: true,
                                          showSortNumbers: true,
                                          allowColumnsResizing: true,
                                          allowSorting: true,
                                          source: ProductDataSource(_filteredProducts!),
                                          columns: <GridColumn>[
                                            GridColumn(
                                                //width: 200,
                                                columnName: 'productName',
                                                label: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      'Product',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: getFontSize()),
                                                    ))),
                                            GridColumn(
                                                width: 90,
                                                columnName: 'availableStock',
                                                label: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    alignment: Alignment.centerRight,
                                                    child: Text('Stock',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: getFontSize())))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            case Status.ERROR:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                                showErrorAlertDialog(context, snapshot.data!.message.toString());
                              });
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }
}

class ProductDataSource extends DataGridSource {
  ProductDataSource(this.products) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = products
        .map<DataGridRow>((product) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'productName', value: "${product.yprodnummer} - ${product.yproddesc}"),
              DataGridCell<double>(columnName: 'availableStock', value: product.ycurstoc),
            ]))
        .toList();
  }

  List<Product> products;
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[0].value.toString(), style: TextStyle(fontSize: getFontSize())),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[1].value.toString(), style: TextStyle(fontSize: getFontSize())),
      ),
    ]);
  }
}
