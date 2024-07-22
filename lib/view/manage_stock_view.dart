import 'package:flutter/material.dart';
import 'package:sdm/blocs/goods_management_id_bloc.dart';
import 'package:sdm/blocs/stock_bloc.dart';
import 'package:sdm/blocs/update_stock_bloc.dart';
import 'package:sdm/models/goods_management_id.dart';
import 'package:sdm/models/stock.dart';
import 'package:sdm/models/update_stock.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/custom_stock_card.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class ManageStockView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String organizationId;
  final String organizationNummer;
  final String routeNummer;
  final String visitNummer;
  final bool isTeamMemberUi;

  const ManageStockView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.organizationId,
    required this.organizationNummer,
    required this.routeNummer,
    required this.visitNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<ManageStockView> createState() => _ManageStockViewState();
}

class _ManageStockViewState extends State<ManageStockView> {
  late StockBloc _stockBloc;
  late UpdateStockBloc _updateStockBloc;
  late GoodMangementIdBloc _goodMangementIdBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Product>? _filteredProducts;
  List<Product>? _allProducts;
  late String goodsManagementId;
  late double newStock;
  late String newLastUpdatedDate;
  late String newLastUpdatedUser;
  bool _isLoading = false;
  bool _isLoading1 = false;
  final Map<String, TextEditingController> _stockControllers = {};
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      _isLoading1 = true;
    });
    _stockBloc = StockBloc();
    _stockBloc.getProductStock(widget.userNummer, widget.organizationNummer);
    _searchController.addListener(_onSearchChanged);
    _updateStockBloc = UpdateStockBloc();
    _goodMangementIdBloc = GoodMangementIdBloc();
    _goodMangementIdBloc.getGoodsManagementId(widget.organizationNummer);
  }

  @override
  void dispose() {
    _stockBloc.dispose();
    _searchController.dispose();
    _updateStockBloc.dispose();
    _goodMangementIdBloc.dispose();
    _stockControllers.values.forEach((controller) => controller.dispose());
    _searchFocusNode.dispose();
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

  void _updateStockCallback(Product product, double newStock, String newLastUpdatedDate, String newLastUpdatedUser) {
    setState(() {
      product.ycurstoc = newStock;
      product.ylastud = newLastUpdatedDate;
      product.ylastub = newLastUpdatedUser;
    });
  }

  void _handleStockFieldTap(TextEditingController controller) {
    _searchFocusNode.unfocus();
    controller.addListener(() {
      _searchFocusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Manage Stock',
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
                    child: textField.TextField(
                        controller: _searchController,
                        obscureText: false,
                        inputType: 'none',
                        isRequired: true,
                        myFocusNode: _searchFocusNode,
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
                                return Scrollbar(
                                  thickness: 5,
                                  interactive: true,
                                  //thumbVisibility: true,
                                  trackVisibility: true,
                                  child: ListView.builder(
                                    itemCount: _filteredProducts!.length,
                                    itemBuilder: (context, index) {
                                      final products = _filteredProducts![index];
                                      final productCode = products.yprodnummer.toString();
                                      final productName = products.yproddesc.toString();
                                      final availableStock = products.ycurstoc.toString();
                                      final lastUpdatedDate = products.ylastud.toString();
                                      final lastUpdatedUser = products.ylastub.toString();
                                      //final TextEditingController newStockController = TextEditingController();
                                      if (!_stockControllers.containsKey(productCode)) {
                                        _stockControllers[productCode] = TextEditingController();
                                      }
                                      final TextEditingController newStockController = _stockControllers[productCode]!;
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 3, top: 3),
                                        child: GestureDetector(
                                          onTap: () => _handleStockFieldTap(newStockController),
                                          child: CustomStockCard(
                                            productId: productCode,
                                            productName: productName,
                                            availableStock: availableStock,
                                            newStockController: newStockController,
                                            lastUpdatedDate: lastUpdatedDate,
                                            lastUpdatedUser: lastUpdatedUser,
                                            onPressedUpdate: () {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              });
                                              _updateStockBloc
                                                  .updateStock(
                                                goodsManagementId,
                                                getCurrentDate(),
                                                productCode,
                                                newStockController.text.toString(),
                                                widget.username,
                                                widget.visitNummer,
                                              )
                                                  .then((_) {
                                                _updateStockCallback(products, double.parse(newStockController.text),
                                                    getCurrentDate(), widget.username);
                                                newStockController.clear();
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                  updateStockResponse(),
                  organizationIdResponse()
                ],
              ),
            ),
            if (_isLoading || _isLoading1) const Loading(),
          ],
        ),
      ),
    );
  }

  Widget updateStockResponse() {
    return StreamBuilder<Response<UpdateStock>>(
      stream: _updateStockBloc.updateStockStream,
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
              snapshot.data!.data!.table![0].yprod.toString();
              newStock = snapshot.data!.data!.table![0].ycurstoc!;
              newLastUpdatedDate = snapshot.data!.data!.table![0].yentdat.toString();
              newLastUpdatedUser = snapshot.data!.data!.table![0].yuser.toString();

              break;

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
    );
  }

Widget organizationIdResponse() {
  return StreamBuilder<ResponseList<GoodManagementID>>(
    stream: _goodMangementIdBloc.goodManagementIdStream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        switch (snapshot.data!.status!) {
          case Status.LOADING:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoading1 = true;
              });
            });
            break;
          case Status.COMPLETED:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoading1 = false;
              });
            });
            var dataList = snapshot.data!.data!;
            if (dataList.isNotEmpty) {
              var items = dataList[0];
              goodsManagementId = items.id.toString();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showErrorAlertDialog(context, "Goods management record is not created for this organization.");
              });
            }
            break;
          case Status.ERROR:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoading1 = false;
              });
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorAlertDialog(context, snapshot.data!.message.toString());
            });
            break;
        }
      }
      return Container();
    },
  );
}

}
