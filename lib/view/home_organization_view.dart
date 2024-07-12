// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/manage_stock_view.dart';
import 'package:sdm/view/mark_visit_view.dart';
import 'package:sdm/view/sales_order_view.dart';
import 'package:sdm/view/stock_view.dart';
import 'package:sdm/view/sub_organization_view.dart';
import 'package:sdm/view/visit_history_view.dart';

class HomeOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String routeNummer;
  final String organizationId;
  final String organizationNummer;
  final String organizationName;
  final String organizationPhone1;
  final String organizationPhone2;
  final String organizationAddress1;
  final String organizationAddress2;
  final String organizationAddress3;
  final String organizationAddress4;
  final String organizationColour;
  final String organizationLongitude;
  final String organizationLatitude;
  final String organizationDistance;
  final String organizationMail;

  const HomeOrganizationView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.routeNummer,
    required this.organizationId,
    required this.organizationNummer,
    required this.organizationName,
    required this.organizationPhone1,
    required this.organizationPhone2,
    required this.organizationAddress1,
    required this.organizationAddress2,
    required this.organizationAddress3,
    required this.organizationAddress4,
    required this.organizationColour,
    required this.organizationLongitude,
    required this.organizationLatitude,
    required this.organizationDistance,
    required this.organizationMail,
  }) : super(key: key);

  @override
  _HomeOrganizationViewState createState() => _HomeOrganizationViewState();
}

class _HomeOrganizationViewState extends State<HomeOrganizationView> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages = [
    MarkVisitView(
      username: widget.username,
      userNummer: widget.userNummer,
      routeNummer: widget.routeNummer,
      organizationId: widget.organizationId,
      organizationNummer: widget.organizationNummer,
      organizationName: widget.organizationName,
      organizationPhone1: widget.organizationPhone1,
      organizationPhone2: widget.organizationPhone2,
      organizationAddress1: widget.organizationAddress1,
      organizationAddress2: widget.organizationAddress2,
      organizationAddress3: widget.organizationAddress3,
      organizationAddress4: widget.organizationAddress4,
      organizationColour: widget.organizationColour,
      organizationLongitude: widget.organizationLongitude,
      organizationLatitude: widget.organizationLatitude,
      organizationDistance: widget.organizationDistance,
      organizationMail: widget.organizationMail,
    ),
   
    StockView(userNummer: widget.userNummer, 
    organizationNummer: widget.organizationNummer,
    organizationName: widget.organizationName,
    ),
    SubOrganizationView(
        userNummer: widget.userNummer,
        username: widget.username,
        organizationNummer: widget.organizationNummer,
        organizationName: widget.organizationName),
    VisitHistoryView(
      userNummer: widget.userNummer,
      organizationNummer: widget.organizationNummer,
      organizationName: widget.organizationName,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          color: CustomColors.navigationBackgroundColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: getBottomNavigationBarPadding()),
            child: GNav(
              backgroundColor: CustomColors.navigationBackgroundColor,
              color: CustomColors.navigationTextColor,
              activeColor: CustomColors.navigationActiveTextColor,
              tabBackgroundColor: CustomColors.navigationActiveBackgroundColor,
              gap: 20,
              onTabChange: _navigateBottomBar,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.flag,
                  text: 'Mark Visit',
                ),
                // GButton(
                //   icon: Icons.receipt,
                //   text: 'Sales Order',
                // ),
                GButton(
                  icon: Icons.list_alt_rounded,
                  text: 'View Stock',
                ),
                GButton(
                  icon: Icons.corporate_fare,
                  text: 'Sub Region',
                ),
                GButton(
                  icon: Icons.history,
                  text: 'Visit History',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
