import 'package:flutter/material.dart';
import 'package:sdm/blocs/sales_order_list_bloc.dart';
import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class SalesOrderOutListView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final String organizationNummer;
  final bool isTeamMemberUi;

  const SalesOrderOutListView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.organizationNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<SalesOrderOutListView> createState() => _SalesOrderOutListViewState();
}

class _SalesOrderOutListViewState extends State<SalesOrderOutListView> {

   late SalesOrderListBloc _salesOrderListBloc;
  final TextEditingController _searchController = TextEditingController();
  List<SalesOrder>? _filteredSalesOrderList;
  List<SalesOrder>? _allSalesOrderList;
  
  @override
  void initState() {
    super.initState();
    _salesOrderListBloc = SalesOrderListBloc();
    _salesOrderListBloc.getSalesOrderList("OUT", widget.organizationNummer);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _salesOrderListBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSalesOrderList = _allSalesOrderList
          ?.where((salesOrderList) =>
              salesOrderList.nummer!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              salesOrderList.such!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
        return Column(
          children: [
            const SizedBox(height: 10,),
            textField.TextField(
                controller: _searchController,
                obscureText: false,
                inputType: 'none',
                isRequired: true,
                fillColor: CustomColors.textFieldFillColor,
                filled: true,
                labelText: "Type to search sales order (Out)...",
                onChangedFunction: () {}),
            Expanded(
              child: StreamBuilder<ResponseList<SalesOrder>>(
                stream: _salesOrderListBloc.salesOrderListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        return Loading(loadingMessage: snapshot.data!.message.toString());
        
                      case Status.COMPLETED:
                        _allSalesOrderList = snapshot.data!.data!;
                        _filteredSalesOrderList ??= _allSalesOrderList;
                        final totalOrganizations = _filteredSalesOrderList!.length;
        
                        if (_filteredSalesOrderList!.isEmpty) {
                          return Center(
                            child: Text(
                              "No sales orders found.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Total sales orders: $totalOrganizations',
                                    style: TextStyle(fontSize: getFontSizeSmall(), color: CustomColors.textColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _filteredSalesOrderList!.length,
                                  itemBuilder: (context, index) {
                                    final salesOrderList = _filteredSalesOrderList![index];
                                    final salesOrderNummer = salesOrderList.nummer.toString();
                                    final salesOrderSearchWord = salesOrderList.such.toString();
        
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                                      child: ListButton(
                                        displayName: "$salesOrderNummer - $salesOrderSearchWord",
                                        onPressed: () {},
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
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
            )
          ],
        );
  }
}