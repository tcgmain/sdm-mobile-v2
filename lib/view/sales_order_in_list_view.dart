import 'package:flutter/material.dart';
import 'package:sdm/blocs/sales_order_list_bloc.dart';
import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;
import 'package:intl/intl.dart';

class SalesOrderInListView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final String organizationNummer;
  final bool isTeamMemberUi;

  const SalesOrderInListView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.organizationNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<SalesOrderInListView> createState() => _SalesOrderInListViewState();
}

class _SalesOrderInListViewState extends State<SalesOrderInListView> {
  late SalesOrderListBloc _salesOrderListBloc;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateRangeController = TextEditingController();
  List<SalesOrder>? _filteredSalesOrderList;
  List<SalesOrder>? _allSalesOrderList;
  DateTimeRange? _selectedDateRange;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy'); // Update according to your date format

  @override
  void initState() {
    super.initState();
    _salesOrderListBloc = SalesOrderListBloc();
    _salesOrderListBloc.getSalesOrderList("IN", widget.organizationNummer);
    _searchController.addListener(_onSearchChanged);
    _dateRangeController.addListener(_onDateRangeChanged);
  }

  @override
  void dispose() {
    _salesOrderListBloc.dispose();
    _searchController.dispose();
    _dateRangeController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSalesOrderList = _filterSalesOrders();
    });
  }

  void _onDateRangeChanged() {
    setState(() {
      _filteredSalesOrderList = _filterSalesOrders();
    });
  }

  List<SalesOrder>? _filterSalesOrders() {
    if (_allSalesOrderList == null) return null;

    return _allSalesOrderList!.where((salesOrder) {
      final matchesSearch = salesOrder.nummer!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          salesOrder.such!.toLowerCase().contains(_searchController.text.toLowerCase());

      final matchesDateRange = _selectedDateRange == null ||
          (salesOrder.ydat != null &&
              _isWithinDateRange(salesOrder.ydat!));

      return matchesSearch && matchesDateRange;
    }).toList();
  }

  bool _isWithinDateRange(String date) {
    try {
      final parsedDate = _dateFormat.parse(date);
      return parsedDate.isAfter(_selectedDateRange!.start) && parsedDate.isBefore(_selectedDateRange!.end);
    } catch (e) {
      print("Error parsing date: $e");
      return false;
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _dateRangeController.text =
            "${_dateFormat.format(_selectedDateRange!.start)} - ${_dateFormat.format(_selectedDateRange!.end)}";
        _filteredSalesOrderList = _filterSalesOrders();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        textField.TextField(
          controller: _searchController,
          obscureText: false,
          inputType: 'none',
          isRequired: true,
          fillColor: CustomColors.textFieldFillColor,
          filled: true,
          labelText: "Type to search sales order (In)...",
          onChangedFunction: () {},
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _selectDateRange(context),
          child: AbsorbPointer(
            child: textField.TextField(
              controller: _dateRangeController,
              obscureText: false,
              inputType: 'none',
              isRequired: false,
              fillColor: CustomColors.textFieldFillColor,
              filled: true,
              labelText: "Select Date Range",
              onChangedFunction: () {},
            ),
          ),
        ),
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
                                final salesOrderDate = salesOrderList.ydat.toString();

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3, top: 3),
                                  child: ListButton(
                                    displayName: "$salesOrderNummer - $salesOrderSearchWord",
                                    rightPosition: salesOrderDate,
                                    onPressed: () {
                                      print("press");
                                    },
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
