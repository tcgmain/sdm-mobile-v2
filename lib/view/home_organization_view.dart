// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/mark_visit_view.dart';
import 'package:sdm/view/organization_info_view.dart';
import 'package:sdm/view/sales_order_list_view.dart';
import 'package:sdm/view/stock_view.dart';
import 'package:sdm/view/sub_organization_view.dart';

class HomeOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String routeNummer;
  final String organizationId;
  final String organizationNummer;
  final String organizationName;
  final String organizationPhone1;
  final String organizationPhone2;
  final String organizationWhatsapp;
  final String organizationAddress1;
  final String organizationAddress2;
  final String organizationAddress3;
  final String organizationTown;
  final String organizationColour;
  final String organizationLongitude;
  final String organizationLatitude;
  final String organizationDistance;
  final String organizationMail;
  final bool isTeamMemberUi;
  final String loggedUserNummer;
  final String ysuporgNummer;
  final String ysuporgNamebspr;
  final String designationNummer;
  final String organizationTypeNamebspr;
  final String userOrganizationNummer;

  const HomeOrganizationView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.routeNummer,
    required this.organizationId,
    required this.organizationNummer,
    required this.organizationName,
    required this.organizationPhone1,
    required this.organizationPhone2,
    required this.organizationWhatsapp,
    required this.organizationAddress1,
    required this.organizationAddress2,
    required this.organizationAddress3,
    required this.organizationTown,
    required this.organizationColour,
    required this.organizationLongitude,
    required this.organizationLatitude,
    required this.organizationDistance,
    required this.organizationMail,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
    required this.ysuporgNummer,
    required this.ysuporgNamebspr,
    required this.designationNummer,
    required this.organizationTypeNamebspr,
    required this.userOrganizationNummer,
  });

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
    isDataViewer(widget.designationNummer)
        ? OrganizationInfoView(
            username: widget.username,
            userNummer: widget.userNummer,
            organizationNummer: widget.organizationNummer,
            isTeamMemberUi: widget.isTeamMemberUi,
            loggedUserNummer: widget.loggedUserNummer,
          )
        : MarkVisitView(
            username: widget.username,
            userNummer: widget.userNummer,
            routeNummer: widget.routeNummer,
            organizationId: widget.organizationId,
            organizationNummer: widget.organizationNummer,
            organizationName: widget.organizationName,
            organizationPhone1: widget.organizationPhone1,
            organizationPhone2: widget.organizationPhone2,
            organizationWhatsapp: widget.organizationWhatsapp,
            organizationAddress1: widget.organizationAddress1,
            organizationAddress2: widget.organizationAddress2,
            organizationAddress3: widget.organizationAddress3,
            organizationTown: widget.organizationTown,
            organizationColour: widget.organizationColour,
            organizationLongitude: widget.organizationLongitude,
            organizationLatitude: widget.organizationLatitude,
            organizationDistance: widget.organizationDistance,
            organizationMail: widget.organizationMail,
            isTeamMemberUi: widget.isTeamMemberUi,
            loggedUserNummer: widget.loggedUserNummer,
            ysuporgNummer: widget.ysuporgNummer,
            ysuporgNamebspr: widget.ysuporgNamebspr, 
            organizationTypeNamebspr: widget.organizationTypeNamebspr,
          ),
    StockView(
      userNummer: widget.userNummer,
      organizationNummer: widget.organizationNummer,
      organizationName: widget.organizationName,
      isTeamMemberUi: widget.isTeamMemberUi,
    ),
    SubOrganizationView(
      userNummer: widget.userNummer,
      username: widget.username,
      organizationNummer: widget.organizationNummer,
      organizationName: widget.organizationName,
      isTeamMemberUi: widget.isTeamMemberUi,
      loggedUserNummer: widget.loggedUserNummer,
      ysuporgNummer: widget.ysuporgNummer,
      ysuporgNamebspr: widget.ysuporgNamebspr,
      designationNummer: widget.designationNummer, 
      userOrganizationNummer: widget.userOrganizationNummer,
    ),
    SalesOrderListView(
      userNummer: widget.userNummer,
      username: widget.username,
      loggedUserNummer: widget.loggedUserNummer,
      isTeamMemberUi: widget.isTeamMemberUi,
      organizationNummer: widget.organizationNummer,
      organizationName: widget.organizationName,
      ysuporgNummer: widget.ysuporgNummer,
      ysuporgNamebspr: widget.ysuporgNamebspr,
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
              tabs: [
                isDataViewer(widget.designationNummer) == true ? 
                const GButton(
                  icon: Icons.info,
                  text: 'Organization Info',
                ):
                const GButton(
                  icon: Icons.flag,
                  text: 'Mark Visit',
                ),
                const GButton(
                  icon: Icons.list_alt_rounded,
                  text: 'View Stock',
                ),
                const GButton(
                  icon: Icons.corporate_fare,
                  text: 'Sub Organizations',
                ),
                const GButton(
                  icon: Icons.receipt,
                  text: 'Sales Order',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
