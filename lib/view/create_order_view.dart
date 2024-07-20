import 'package:flutter/material.dart';
import 'package:sdm/blocs/stock_bloc.dart';
import 'package:sdm/models/stock.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateOrderView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final String organizationNummer;
  final String organizationName;
  final String ysuporgNummer;
  final String ysuporgNamebspr;
  final bool isTeamMemberUi;

  const CreateOrderView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.organizationNummer,
    required this.organizationName,
    required this.ysuporgNummer,
    required this.ysuporgNamebspr,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  bool _isLoading = false;
  late StockBloc _stockBloc;
  List<Product>? _allProducts;
  List<Product> _selectedProducts = [];
  List<Product> _availableProducts = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _stockBloc = StockBloc();
    _stockBloc.getProductStock(widget.userNummer, widget.organizationNummer);
  }

  @override
  void dispose() {
    _stockBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Create Order',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: ListView(
                children: [
                  getProductsResponse(),
                  salesOrderDetails("Date", getCurrentDate()),
                  salesOrderDetails("Created By", widget.username),
                  const Divider(),
                  salesOrderDetails("From", widget.ysuporgNamebspr),
                  salesOrderDetails("To", widget.organizationName),
                  const SizedBox(height: 20),
                  _buildProductDropdown(),
                  const SizedBox(height: 20),
                  _buildSelectedProductsTable(),
                ],
              ),
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  Widget salesOrderDetails(String heading, String description) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            "$heading :",
            style: TextStyle(
              color: CustomColors.textColor,
              fontWeight: FontWeight.bold,
              fontSize: getFontSize(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: CustomColors.textColor,
                fontSize: getFontSize(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getProductsResponse() {
    return StreamBuilder<Response<Stock>>(
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
              break;
            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = false;
                  _allProducts = snapshot.data!.data!.table;
                  _filterAvailableProducts();
                });
              });
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = false;
                });
                showErrorAlertDialog(context, snapshot.data!.message.toString());
              });
              break;
          }
        }
        return Container();
      },
    );
  }

  void _filterAvailableProducts() {
    _availableProducts = _allProducts!.where((product) => !_selectedProducts.contains(product)).toList();
  }

  Widget _buildProductDropdown() {
    return MultiSelectDialogField(
      items:
          _availableProducts.map((product) => MultiSelectItem<Product>(product, product.yproddesc.toString())).toList(),
      title: const Text("Select Products"),
      selectedColor: CustomColors.appBarColor1,
      decoration: BoxDecoration(
        color: CustomColors.textColor,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          color: CustomColors.cardBackgroundColor1,
          width: 2,
        ),
      ),
      buttonIcon: const Icon(
        Icons.arrow_drop_down,
        color: CustomColors.cardTextColor,
      ),
      buttonText: const Text(
        "Select Products",
        style: TextStyle(
          color: CustomColors.cardTextColor,
          fontSize: 16,
        ),
      ),
      onConfirm: (results) {
        setState(() {
          _selectedProducts.addAll(results.cast<Product>());
          _filterAvailableProducts();
        });
      },
      chipDisplay: MultiSelectChipDisplay(
        onTap: (product) {
          setState(() {
            _selectedProducts.remove(product);
            _filterAvailableProducts();
          });
        },
      ),
    );
  }

  Widget _buildSelectedProductsTable() {
    return Container(
      clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [CustomColors.tableBackgroundColor1, CustomColors.tableBackgroundColor2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(CustomColors.tableBackgroundColor1),
          columns: [
            DataColumn(
              label: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                child: Text(
                  'Product Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize()),
                ),
              ),
            ),
            DataColumn(
              label: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                child: Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize()),
                ),
              ),
            ),
            DataColumn(
              label: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.2),
                child: Text(
                  'Remove',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize()),
                ),
              ),
            ),
          ],
          rows: _selectedProducts
              .map(
                (product) => DataRow(
                  color: WidgetStateProperty.all(CustomColors.tableBackgroundColor2),
                  cells: [
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Text(
                          product.yproddesc.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                        ),
                        child: TextFormField(
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            // Handle quantity change
                          },
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedProducts.remove(product);
                              _filterAvailableProducts();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
