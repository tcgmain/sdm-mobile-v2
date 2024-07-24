import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/visit_bloc.dart';
import 'package:sdm/models/visit.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class AllVisitHistoryView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const AllVisitHistoryView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<AllVisitHistoryView> createState() => _AllVisitHistoryViewState();
}

class _AllVisitHistoryViewState extends State<AllVisitHistoryView> {
  bool _isLoading = false;
  bool _isFiltersVisible = false;
  late VisitBloc _visitBloc;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _dateRangeController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _organizationFocusNode = FocusNode();
  List<Visit>? _filteredVisitList;
  List<Visit>? _allVisitList;
  DateTimeRange? _selectedDateRange;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _visitBloc = VisitBloc();
    _visitBloc.visit("", "");
    _searchController.addListener(_onSearchChanged);
    _organizationController.addListener(_onSearchChanged);
    _dateRangeController.addListener(_onDateRangeChanged);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _organizationController.dispose();
    _dateRangeController.dispose();
    _searchFocusNode.dispose();
    _organizationFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredVisitList = _filterVisits();
    });
  }

  void _onDateRangeChanged() {
    setState(() {
      _filteredVisitList = _filterVisits();
    });
  }

  List<Visit>? _filterVisits() {
    if (_allVisitList == null) return null;

    final filteredList = _allVisitList!.where((visit) {
      final matchesSearch = visit.ysdmempvSuch!.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesOrganization =
          visit.yorgNamebspr!.toLowerCase().contains(_organizationController.text.toLowerCase());
      final matchesDateRange = _selectedDateRange == null || (visit.yvdat != null && _isWithinDateRange(visit.yvdat!));

      return matchesSearch && matchesOrganization && matchesDateRange;
    }).toList();

    // Sort the filtered list by Visit Date in descending order
    filteredList.sort((a, b) {
      final dateA = _parseDate(a.yvdat);
      final dateB = _parseDate(b.yvdat);
      return dateB.compareTo(dateA);
    });

    return filteredList;
  }

  DateTime _parseDate(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime(1900); // return a default date if null or empty
    }
    try {
      return _dateFormat.parse(date);
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime(1900); // return a default date if parsing fails
    }
  }

  bool _isWithinDateRange(String date) {
    try {
      final parsedDate = _parseDate(date);
      return (parsedDate.isAfter(_selectedDateRange!.start) ||
              parsedDate.isAtSameMomentAs(_selectedDateRange!.start)) &&
          (parsedDate.isBefore(_selectedDateRange!.end) || parsedDate.isAtSameMomentAs(_selectedDateRange!.end));
    } catch (e) {
      print("Error checking date range: $e");
      return false;
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      switchToCalendarEntryModeIcon: const Icon(Icons.calendar_month),
      switchToInputEntryModeIcon: const Icon(Icons.calendar_month),
      initialEntryMode: DatePickerEntryMode.calendar,
      saveText: "OK",
      confirmText: 'OK',
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
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
        _filteredVisitList = _filterVisits();
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _organizationController.clear();
      _dateRangeController.clear();
      _selectedDateRange = null;
      _filteredVisitList = _allVisitList;
    });
  }

  void _toggleFilters() {
    setState(() {
      _isFiltersVisible = !_isFiltersVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'All Visit History',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: true,
        customActions: [
          IconButton(
            icon: Icon(_isFiltersVisible ? Icons.filter_list_off : Icons.filter_list),
            onPressed: _toggleFilters,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Column(
                children: [
                  if (_isFiltersVisible) ...[
                    const SizedBox(height: 10),
                    textField.TextField(
                      controller: _searchController,
                      myFocusNode: _searchFocusNode,
                      obscureText: false,
                      inputType: 'none',
                      isRequired: true,
                      fillColor: CustomColors.textFieldFillColor,
                      filled: true,
                      labelText: "Type to search visitors...",
                      onChangedFunction: () {},
                    ),
                    const SizedBox(height: 10),
                    textField.TextField(
                      controller: _organizationController,
                      myFocusNode: _organizationFocusNode,
                      obscureText: false,
                      inputType: 'none',
                      isRequired: true,
                      fillColor: CustomColors.textFieldFillColor,
                      filled: true,
                      labelText: "Type to search organization...",
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
                          labelText: "Select date range",
                          onChangedFunction: () {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CommonAppButton(
                        buttonText: "Reset All Filters",
                        onPressed: () {
                          _resetFilters();
                        }),
                    const SizedBox(height: 10),
                  ],
                  Expanded(
                    child: StreamBuilder<ResponseList<Visit>>(
                      stream: _visitBloc.visitStream,
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

                              _allVisitList = snapshot.data!.data!;
                              _filteredVisitList ??= _filterVisits();
                              final totalVisits = _filteredVisitList!.length;

                              if (snapshot.data!.data!.isNotEmpty) {
                                var visits = _filteredVisitList!;

                                final dateFormat = DateFormat("dd/MM/yyyy");
                                final timeFormat = DateFormat("HH:mm");

                                visits.sort((a, b) {
                                  try {
                                    DateTime dateTimeA = DateTime(
                                      dateFormat.parse(a.yvdat.toString()).year,
                                      dateFormat.parse(a.yvdat.toString()).month,
                                      dateFormat.parse(a.yvdat.toString()).day,
                                      timeFormat.parse(a.yvtim.toString()).hour,
                                      timeFormat.parse(a.yvtim.toString()).minute,
                                    );
                                    DateTime dateTimeB = DateTime(
                                      dateFormat.parse(b.yvdat.toString()).year,
                                      dateFormat.parse(b.yvdat.toString()).month,
                                      dateFormat.parse(b.yvdat.toString()).day,
                                      timeFormat.parse(b.yvtim.toString()).hour,
                                      timeFormat.parse(b.yvtim.toString()).minute,
                                    );
                                    return dateTimeB.compareTo(dateTimeA);
                                  } catch (e) {
                                    return 0;
                                  }
                                });

                                return ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Total visits: $totalVisits',
                                          style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                        ),
                                      ),
                                    ),
                                    ...visits
                                        .map(
                                          (visit) => Container(
                                            margin: const EdgeInsets.only(bottom: 10),
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
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                              title: Text(
                                                visit.yorgNamebspr.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color: Colors.red,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'Visited on: ${visit.yvdat} at ${visit.yvtim}',
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.person,
                                                        color: Colors.red,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'Visitor: ${visit.ysdmempvSuch}',
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    "No visit history found",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
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
                              break;
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) const Loading(), // Display loading indicator if _isLoading is true
          ],
        ),
      ),
    );
  }
}
