import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/sales_order_list_bloc.dart';
import 'package:sdm/models/sales_order.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/sales_order_view.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;

class SalesOrderOutListView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final String organizationNummer;
  final bool isTeamMemberUi;

  const SalesOrderOutListView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.organizationNummer,
    required this.isTeamMemberUi,
  });

  @override
  State<SalesOrderOutListView> createState() => _SalesOrderOutListViewState();
}

class _SalesOrderOutListViewState extends State<SalesOrderOutListView> {
  late SalesOrderListBloc _salesOrderListBloc;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateRangeController = TextEditingController();
  List<SalesOrder>? _filteredSalesOrderList;
  List<SalesOrder>? _allSalesOrderList;
  DateTimeRange? _selectedDateRange;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _salesOrderListBloc = SalesOrderListBloc();
    _salesOrderListBloc.getSalesOrderOutList(widget.organizationNummer);
    _searchController.addListener(_onSearchChanged);
    _dateRangeController.addListener(_onDateRangeChanged);
    setState(() {
      _isLoading = true;
    });
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

    final filteredList = _allSalesOrderList!.where((salesOrder) {
      final matchesSearch = salesOrder.nummer!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          salesOrder.such!.toLowerCase().contains(_searchController.text.toLowerCase());

      final matchesDateRange =
          _selectedDateRange == null || (salesOrder.ydat != null && _isWithinDateRange(salesOrder.ydat!));

      return matchesSearch && matchesDateRange;
    }).toList();

    // Sort the filtered list by salesOrderDate in descending order
    filteredList.sort((a, b) {
      final dateA = _dateFormat.parse(a.ydat!);
      final dateB = _dateFormat.parse(b.ydat!);
      return dateB.compareTo(dateA);
    });

    return filteredList;
  }

  bool _isWithinDateRange(String date) {
    try {
      final parsedDate = _dateFormat.parse(date);
      return (parsedDate.isAfter(_selectedDateRange!.start) ||
              parsedDate.isAtSameMomentAs(_selectedDateRange!.start)) &&
          (parsedDate.isBefore(_selectedDateRange!.end) || parsedDate.isAtSameMomentAs(_selectedDateRange!.end));
    } catch (e) {
      print("Error parsing date: $e");
      return false;
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      switchToCalendarEntryModeIcon: const Icon(Icons.calendar_month),
      switchToInputEntryModeIcon: const Icon(Icons.calendar_month),
      initialEntryMode: DatePickerEntryMode.calendar,
      saveText: "OK",
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
      confirmText: 'OK',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.red,
                accentColor: Colors.grey,
                backgroundColor: Colors.grey.shade200,
                cardColor: Colors.grey.shade300,
                brightness: Brightness.light),
          ),
          child: child!,
        );
      },
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
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            text_field.TextField(
                controller: _searchController,
                obscureText: false,
                inputType: 'none',
                isRequired: true,
                fillColor: CustomColors.textFieldFillColor,
                filled: true,
                labelText: "Type to search sales order...",
                onChangedFunction: () {}),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: AbsorbPointer(
                child: text_field.TextField(
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
                          });
                        });
                        _allSalesOrderList = snapshot.data!.data!;
                        _filteredSalesOrderList ??= _filterSalesOrders();
                        final totalOrganizations = _filteredSalesOrderList!.length;

                        if (_filteredSalesOrderList!.isEmpty) {
                          return Center(
                            child: Text(
                              "No out-orders found.",
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
                                    'Total out-orders: $totalOrganizations',
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => SalesOrderView(
                                                      title: "Sales Order",
                                                      userNummer: widget.userNummer,
                                                      organizationNummer: widget.organizationNummer,
                                                      isTeamMemberUi: widget.isTeamMemberUi,
                                                      username: widget.username,
                                                      loggedUserNummer: widget.loggedUserNummer,
                                                      salesOrderNummer: salesOrderNummer,
                                                    )),
                                          );
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
              ),
            )
          ],
        ),
        if (_isLoading) const Loading(),
      ],
    );
  }
}
