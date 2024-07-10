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
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class ManageStockView extends StatefulWidget {
  final String userNummer;
  final String organizationId;
  final String organizationNummer;
  final String routeNummer;

  const ManageStockView({
    Key? key,
    required this.userNummer,
    required this.organizationId,
    required this.organizationNummer,
    required this.routeNummer,
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

  @override
  void initState() {
    super.initState();
    _stockBloc = StockBloc();
    _stockBloc.getStockData(widget.userNummer, widget.organizationNummer);
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

  void _updateStock(String productCode, dynamic newStock) async {
    final response = await _updateStockBloc.updateStock(
      goodsManagementId,
      getCurrentDate(),
      productCode,
      newStock,
      widget.userNummer,
      widget.routeNummer,
    );

    if (response.status == Status.COMPLETED) {
      setState(() {
        final productIndex = _allProducts!.indexWhere((product) => product.yprodnummer == productCode);
        if (productIndex != -1) {
          _allProducts![productIndex].ycurstoc = newStock;
          _filteredProducts![productIndex].ycurstoc = newStock;
        }
      });
    } else {
      showErrorAlertDialog(context, response.message.toString());
    }
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
                          print(snapshot.data!.data!.table?[0].yproddesc.toString());
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
                            return ListView.builder(
                              itemCount: _filteredProducts!.length,
                              itemBuilder: (context, index) {
                                final products = _filteredProducts![index];
                                final productCode = products.yprodnummer.toString();
                                final productName = products.yproddesc.toString();
                                final availableStock = products.ycurstoc.toString();
                                final TextEditingController newStockController = TextEditingController();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3, top: 3),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.shade400,
                                          Colors.white,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$productCode - $productName',
                                          style: TextStyle(
                                              color: const Color(0xff3b3b3b),
                                              fontSize: getFontSizeSmall(),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(),
                                        ListTile(
                                          title: Text(
                                            'Stock: $availableStock',
                                            style: TextStyle(fontSize: getFontSize()),
                                          ),
                                          trailing: Container(
                                            alignment: Alignment.centerRight,
                                            width: 150,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: newStockController,
                                                    decoration: const InputDecoration(
                                                      hintText: 'New Stock',
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black38, width: 2),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.red, width: 2),
                                                      ),
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                  ),
                                                ),
                                                IconButton(
                                                  color: CustomColors.buttonColor,
                                                  icon: const Icon(Icons.update),
                                                  onPressed: () {
                                                    _updateStock(
                                                        productCode, newStockController.text.toString());
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.all(0),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
              organizationID()
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
              String productId = snapshot.data!.data!.table![0].yprod.toString();
              dynamic newStock111 = snapshot.data!.data!.table![0].ycurstoc.toString();    
              _stockBloc.getStockData(widget.userNummer, widget.organizationNummer);
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

  Widget organizationID() {
    return StreamBuilder<ResponseList<GoodManagementID>>(
      stream: _goodMangementIdBloc.goodManagementIdStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              print("loading");
              break;
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
