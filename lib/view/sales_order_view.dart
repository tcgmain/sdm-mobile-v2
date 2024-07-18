import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sdm/blocs/sales_order_bloc.dart';
import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesOrderView extends StatefulWidget {
  final String title;
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final String organizationNummer;
  final String salesOrderNummer;
  final bool isTeamMemberUi;

  const SalesOrderView({
    Key? key,
    required this.title,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.organizationNummer,
    required this.salesOrderNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<SalesOrderView> createState() => _SalesOrderViewState();
}

class _SalesOrderViewState extends State<SalesOrderView> {
  late SalesOrderBloc _salesOrderBloc;
  bool _isErrorMessageShown = false;
  List<SalesOrder>? _salesOrder;

  @override
  void initState() {
    super.initState();
    _salesOrderBloc = SalesOrderBloc();
    _salesOrderBloc.getSalesOrder(widget.salesOrderNummer);
    _isErrorMessageShown = false;
  }

  @override
  void dispose() {
    _salesOrderBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.title,
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: BackgroundImage(
          isTeamMemberUi: widget.isTeamMemberUi,
          child: StreamBuilder<ResponseList<SalesOrder>>(
            stream: _salesOrderBloc.salesOrderStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status!) {
                  case Status.LOADING:
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  case Status.COMPLETED:
                    _salesOrder = snapshot.data!.data;
                    final salesOrderNummer = widget.salesOrderNummer.toString();
                    final salesOrderSearchWord = _salesOrder![0].such.toString();
                    final salesOrderDate = _salesOrder![0].ydat.toString();
                    final salesOrderCreatedBy = _salesOrder![0].ysdempYpasdefBezeich.toString();
                    final salesOrderOrganizationFrom = _salesOrder![0].ysdorgorfrNamebspr.toString();
                    final salesOrderOrganizationTo = _salesOrder![0].ysdorgNamebspr.toString();

                    return ListView(
                      children: [
                        salesOrderDetails("Nummer", salesOrderNummer),
                        salesOrderDetails("Search Word", salesOrderSearchWord),
                        salesOrderDetails("Date", salesOrderDate),
                        salesOrderDetails("Created By", salesOrderCreatedBy),
                        const Divider(),
                        salesOrderDetails("From", salesOrderOrganizationFrom),
                        salesOrderDetails("To", salesOrderOrganizationTo),
                        
                        //const Divider(),
                        const SizedBox(height: 5),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [CustomColors.tableBackgroundColor1, CustomColors.tableBackgroundColor2],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
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
                            source: ProductDataSource(_salesOrder!),
                            columns: <GridColumn>[
                              GridColumn(
                                columnName: 'product',
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Product',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: getFontSize()),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'quantity',
                                width: 110,
                                label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Quantity',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: getFontSize()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  case Status.ERROR:
                    if (!_isErrorMessageShown) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        showErrorAlertDialog(context, snapshot.data!.message.toString());
                        setState(() {
                          _isErrorMessageShown = true;
                        });
                      });
                    }
                    break;
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              ); // Placeholder for initial loading state
            },
          ),
        ),
      ),
    );
  }

  Widget salesOrderDetails(String heading, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text("$heading :",
              style: TextStyle(color: CustomColors.textColor, fontWeight: FontWeight.bold, fontSize: getFontSize())),
          const SizedBox(
            width: 10,
          ),
          Text(description, style: TextStyle(color: CustomColors.textColor, fontSize: getFontSize()))
        ],
      ),
    );
  }
}

class ProductDataSource extends DataGridSource {
  ProductDataSource(this.products) {
    buildDataGridRows();
  }

  final List<SalesOrder> products;
  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    dataGridRows = products.map<DataGridRow>((salesOrder) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'product',
            value: "${salesOrder.yprodNummer} - ${salesOrder.yprodNamebspr}",
          ),
          DataGridCell<String>(
            columnName: 'quantity',
            value: "${salesOrder.yqty}",
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[0].value.toString(),
            style: TextStyle(fontSize: getFontSize()),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[1].value.toString(),
            style: TextStyle(fontSize: getFontSize()),
          ),
        ),
      ],
    );
  }
}
