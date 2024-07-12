import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class ManageStockView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String organizationId;
  final String organizationNummer;
  final String routeNummer;
  final String visitNummer;

  const ManageStockView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.organizationId,
    required this.organizationNummer,
    required this.routeNummer,
    required this.visitNummer,
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

  @override
  void initState() {
    super.initState();
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
        child: BackgroundImage(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textField.TextField(
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
                          return Loading(loadingMessage: snapshot.data!.message.toString());

                        case Status.COMPLETED:
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
                                  final TextEditingController newStockController = TextEditingController();
                              
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 3, top: 3),
                                    child: CustomStockCard(
                                      productId: productCode,
                                      productName: productName,
                                      availableStock: availableStock,
                                      newStockController: newStockController,
                                      lastUpdatedDate: lastUpdatedDate,
                                      lastUpdatedUser: lastUpdatedUser,
                                      onPressedUpdate: () {
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
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                        case Status.ERROR:
                          WidgetsBinding.instance.addPostFrameCallback((_) {
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
              return Loading(loadingMessage: snapshot.data!.message.toString());

            case Status.COMPLETED:
              String productCode = snapshot.data!.data!.table![0].yprod.toString();
              newStock = snapshot.data!.data!.table![0].ycurstoc!;
              newLastUpdatedDate = snapshot.data!.data!.table![0].yentdat.toString();
              newLastUpdatedUser = snapshot.data!.data!.table![0].yuser.toString();

              break;

            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
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
              return Loading(loadingMessage: snapshot.data!.message.toString());
            case Status.COMPLETED:
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
