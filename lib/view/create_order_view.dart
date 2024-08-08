import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdm/blocs/create_so_bloc.dart';
import 'package:sdm/blocs/stock_bloc.dart';
import 'package:sdm/models/create_so.dart';
import 'package:sdm/models/stock.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sdm/widgets/success_alert.dart';
import 'package:sdm/widgets/confirmation_dialog.dart';

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
  bool _isCreateSoErrorShown = false;
  bool _isSuccessMessageShown = false;
  late StockBloc _stockBloc;
  late CreateSoBloc _createSoBloc;
  List<Product>? _allProducts;
  List<Product> _selectedProducts = [];
  List<Product> _availableProducts = [];
  Map<String, String> _productQuantities = {};
  List<FocusNode> _focusNodes = [];
  bool _isProductErrorShown = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _stockBloc = StockBloc();
    _stockBloc.getProductStock(widget.userNummer, widget.organizationNummer);
    _createSoBloc = CreateSoBloc();
  }

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    _stockBloc.dispose();
    _createSoBloc.dispose();
    super.dispose();
  }

  void _updateFocusNodes() {
    _focusNodes.forEach((node) => node.dispose());
    _focusNodes = List.generate(_selectedProducts.length, (index) => FocusNode());
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
                  createSoResponse(),
                  salesOrderDetails("Date", getCurrentDate()),
                  salesOrderDetails("Created By", widget.username),
                  const Divider(),
                  salesOrderDetails("From", widget.ysuporgNamebspr),
                  salesOrderDetails("To", widget.organizationName),
                  const SizedBox(height: 20),
                  _buildProductDropdown(),
                  const SizedBox(height: 20),
                  _buildSelectedProductsTable(),
                  const SizedBox(height: 20),
                  CommonAppButton(
                      buttonText: "Create Order",
                      onPressed: () {
                        setState(() {
                          _isCreateSoErrorShown = false;
                          _isSuccessMessageShown = false;
                        });
                        print("pressed");

                        List<Map<String, String?>> orderedList = _selectedProducts.map((product) {
                          return {'yprod': product.yprodnummer, 'yqty': _productQuantities[product.yprodnummer] ?? ''};
                        }).toList();

                        bool hasEmptyQuantity =
                            orderedList.any((product) => product['yqty'] == '' || product['yqty'] == '0');
                        if (orderedList.isEmpty) {
                          showErrorAlertDialog(context, "Please add product/s to create order");
                        } else if (orderedList.every((product) => product['yqty'] == '') ||
                            orderedList.every((product) => product['yqty'] == '0')) {
                          showErrorAlertDialog(context, "Please enter quantities");
                        } else if (hasEmptyQuantity) {
                          showConfirmationDialog(context, () {
                            _createSoBloc.createSO(
                                widget.loggedUserNummer,
                                getCurrentDate(),
                                widget.ysuporgNummer,
                                widget.organizationNummer,
                                orderedList.where((product) => product['yqty'] != '').toList());
                          }, "This product list has empty quantities. Do you want to proceed?", "Empty Quantities");
                        } else {
                          _createSoBloc.createSO(widget.loggedUserNummer, getCurrentDate(), widget.ysuporgNummer,
                              widget.organizationNummer, orderedList);
                        }
                      })
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
              if (!_isProductErrorShown) {
                _isProductErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }

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
    return MultiSelectBottomSheetField<Product?>(
      initialChildSize: 0.4,
      maxChildSize: 0.95,
      title: const Text("Select Products"),
      buttonText: Text(
        "Select Products",
        style: TextStyle(
          color: CustomColors.cardTextColor,
          fontSize: getFontSize(),
        ),
      ),
      items: _availableProducts
          .map((product) => MultiSelectItem<Product?>(product, "${product.yprodnummer} - ${product.yproddesc}"))
          .toList(),
      searchable: true,
      selectedColor: CustomColors.appBarColor1,
      decoration: BoxDecoration(
        color: CustomColors.textColor,
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          color: CustomColors.tableBackgroundColor2,
          width: 2,
        ),
      ),
      buttonIcon: const Icon(
        Icons.arrow_drop_down,
        color: CustomColors.cardTextColor,
      ),
      onConfirm: (results) {
        setState(() {
          for (var product in results) {
            if (!_selectedProducts.contains(product)) {
              _selectedProducts.add(product as Product);
            }
          }
          _filterAvailableProducts();
        });
      },
      chipDisplay: MultiSelectChipDisplay.none(),
    );
  }

  Widget _buildSelectedProductsTable() {
    String productCount = _selectedProducts.length.toString();

    // Create focus nodes only if needed
    if (_focusNodes.length != _selectedProducts.length) {
      _focusNodes.forEach((node) => node.dispose()); // Dispose old nodes
      _focusNodes = List.generate(_selectedProducts.length, (index) => FocusNode());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$productCount Product/s added to list",
          style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
        ),
        const SizedBox(height: 10),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 70,
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
              rows: _selectedProducts.asMap().entries.map((entry) {
                int index = entry.key;
                Product product = entry.value;
                return DataRow(
                  color: WidgetStateProperty.all(CustomColors.tableBackgroundColor2),
                  cells: [
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                        child: Text(
                          "${product.yprodnummer} - ${product.yproddesc}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                        child: TextFormField(
                          focusNode: _focusNodes[index],
                          initialValue: _productQuantities[product.yprodnummer] ?? '',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _productQuantities[product.yprodnummer.toString()] = value;
                            });
                          },
                          onFieldSubmitted: (value) {
                            if (index < _focusNodes.length - 1) {
                              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                            } else {
                              FocusScope.of(context).unfocus();
                            }
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
                              _productQuantities.remove(product.yprodnummer);
                              _filterAvailableProducts();
                              _updateFocusNodes(); // Update focus nodes list
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget createSoResponse() {
    return StreamBuilder<Response<CreateSO>>(
      stream: _createSoBloc.createSoStream,
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
                if (!_isSuccessMessageShown) {
                  String orderNummer = snapshot.data!.data!.nummer.toString();
                  String orderSearchWord = snapshot.data!.data!.such.toString();
                  showSuccessAlertDialog(context, "Order no: $orderSearchWord($orderNummer) has been created.", () {});
                  setState(() {
                    _isLoading = false;
                    _isSuccessMessageShown = true;
                    _selectedProducts.clear();
                    _productQuantities.clear();
                    _filterAvailableProducts();
                  });
                }
              });

              break;
            case Status.ERROR:
              _isCreateSoErrorShown = true;
              if (!_isCreateSoErrorShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isLoading = false;
                  });
                });
              }
              break;
          }
        }
        return Container();
      },
    );
  }
}
