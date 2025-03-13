// ignore_for_file: avoid_function_literals_in_foreach_calls

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
import 'package:sdm/widgets/text_field.dart' as text_field;

class ManageStockView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String organizationId;
  final String organizationNummer;
  final String routeNummer;
  final String visitNummer;
  final bool isTeamMemberUi;

  const ManageStockView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.organizationId,
    required this.organizationNummer,
    required this.routeNummer,
    required this.visitNummer,
    required this.isTeamMemberUi,
  });

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
  bool _isStockViewErrorShown = false;
  final Map<String, TextEditingController> _stockControllers = {};
  final FocusNode _searchFocusNode = FocusNode();
  bool _isStockUpdatErrorShown = false;
  bool _isOrganizationIdResponseErrorShown = false;
  bool _isOrganizationIdResponseSuccessShown = false;

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

  Map<String, List<Product>> _groupProductsByCategory(List<Product> products) {
    final Map<String, List<Product>> categorizedProducts = {};
    for (var product in products) {
      final category = product.yproductcategory ?? 'Uncategorized';
      if (!categorizedProducts.containsKey(category)) {
        categorizedProducts[category] = [];
      }
      categorizedProducts[category]!.add(product);
    }
    return categorizedProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Manage Stock',
        onBackButtonPressed: () => Navigator.pop(context),
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
                      myFocusNode: _searchFocusNode,
                      fillColor: CustomColors.textFieldFillColor,
                      filled: true,
                      labelText: "Type to search product...",
                      onChangedFunction: () {},
                    ),
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
                              if (_isLoading) {
                                _isLoading = false;
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {});
                                });
                              }
                              _allProducts = snapshot.data!.data!.table;
                              _filteredProducts ??= _allProducts;

                              if (_filteredProducts!.isEmpty) {
                                return const Center(
                                  child: Text("No products found"),
                                );
                              } else {
                                final categorizedProducts = _groupProductsByCategory(_filteredProducts!);
                                return Scrollbar(
                                  thickness: 5,
                                  child: ListView(
                                    children: _groupProductsByCategory(_filteredProducts!).entries.map((categoryEntry) {
                                      final category = categoryEntry.key;
                                      final categoryProducts = categoryEntry.value;

                                      final Map<String, List<Product>> brands = {};
                                      for (var product in categoryProducts) {
                                        final brand = product.productbrand ?? 'Unknown Brand';
                                        brands.putIfAbsent(brand, () => []).add(product);
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.black,
                                                Colors.black26,
                                              ], // Black gradient for category
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(5),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //     color: Colors.black26,
                                            //     //blurRadius: 5,
                                            //     offset: Offset(2, 2),
                                            //   ),
                                            // ],
                                          ),
                                          child: ExpansionTile(
                                            collapsedIconColor: Colors.white,
                                            iconColor: CustomColors.textColor,
                                            title: Text(
                                              category,
                                              style: TextStyle(
                                                color: CustomColors.textColor,
                                                fontSize: getFontSize(),
                                                //fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            children: brands.entries.map((brandEntry) {
                                              final brand = brandEntry.key;
                                              final brandProducts = brandEntry.value;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    bottom: 5.0), // Indent brand under category
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.grey.shade900,
                                                        Colors.grey.shade700,
                                                      ], // Lighter shade for brand
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: ExpansionTile(
                                                    collapsedIconColor: CustomColors.textColor,
                                                    iconColor: CustomColors.textColor,
                                                    title: Text(
                                                      brand,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: getFontSize(),
                                                        //fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    children: brandProducts.map((product) {
                                                      final productCode = product.yprodnummer.toString();
                                                      final productSearchWord = product.yprodsuch.toString();
                                                      final productName = product.yproddesc.toString();
                                                      final availableStock = product.ycurstoc.toString();
                                                      final lastUpdatedDate = product.ylastud.toString();
                                                      final lastUpdatedUser = product.ylastub.toString();
                                                      final isCompetitorProduct = product.yiscompetitor;

                                                      if (!_stockControllers.containsKey(productCode)) {
                                                        _stockControllers[productCode] = TextEditingController();
                                                      }
                                                      final newStockController = _stockControllers[productCode]!;

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                                                        child: GestureDetector(
                                                          onTap: () => _handleStockFieldTap(newStockController),
                                                          child: CustomStockCard(
                                                            productId: productSearchWord,
                                                            productName: productName,
                                                            availableStock: availableStock,
                                                            newStockController: newStockController,
                                                            lastUpdatedDate: lastUpdatedDate,
                                                            lastUpdatedUser: lastUpdatedUser,
                                                            isCompetitorProduct: isCompetitorProduct,
                                                            onPressedUpdate: () {
                                                              _updateStockBloc
                                                                  .updateStock(
                                                                goodsManagementId,
                                                                getCurrentDate(),
                                                                productCode,
                                                                newStockController.text.toString(),
                                                                widget.visitNummer,
                                                              )
                                                                  .then((_) {
                                                                _updateStockCallback(
                                                                  product,
                                                                  double.parse(newStockController.text),
                                                                  getCurrentDate(),
                                                                  widget.username,
                                                                );
                                                                newStockController.clear();
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                            case Status.ERROR:
                              if (!_isStockViewErrorShown) {
                                _isStockViewErrorShown = true;
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                                });
                              }

                              return Container();
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                  updateStockResponse(),
                  organizationIdResponse(),
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
              if (!_isStockUpdatErrorShown) {
                _isStockUpdatErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
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
                if (!_isOrganizationIdResponseSuccessShown) {
                  _isOrganizationIdResponseSuccessShown = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showErrorAlertDialog(context, "Goods management record is not created for this organization.");
                  });
                }
              }
              break;
            case Status.ERROR:
              if (!_isOrganizationIdResponseErrorShown) {
                _isOrganizationIdResponseErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isLoading1 = false;
                    showErrorAlertDialog(context, snapshot.data!.message.toString());
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
