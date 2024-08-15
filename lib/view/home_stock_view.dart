import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/camera_view.dart';
import 'package:sdm/view/manage_stock_view.dart';
import 'package:sdm/view/sales_order_list_view.dart';

class HomeStockView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final String organizationId;
  final String organizationNummer;
  final String organizationName;
  final String ysuporgNummer;
  final String ysuporgNamebspr;
  final String routeNummer;
  final String visitNummer;
  final bool isTeamMemberUi;

  const HomeStockView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.organizationId,
    required this.organizationNummer,
    required this.organizationName,
    required this.ysuporgNummer,
    required this.ysuporgNamebspr,
    required this.routeNummer,
    required this.visitNummer,
    required this.isTeamMemberUi,
  });

  @override
  State<HomeStockView> createState() => _HomeStockViewState();
}

class _HomeStockViewState extends State<HomeStockView> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages = [
    ManageStockView(
      userNummer: widget.userNummer,
      username: widget.username,
      organizationId: widget.organizationId,
      organizationNummer: widget.organizationNummer,
      routeNummer: widget.routeNummer,
      visitNummer: widget.visitNummer,
      isTeamMemberUi: widget.isTeamMemberUi,
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
    CameraView(
      userNummer: widget.userNummer,
      username: widget.username,
      loggedUserNummer: widget.loggedUserNummer,
      isTeamMemberUi: widget.isTeamMemberUi,
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
                  icon: Icons.edit,
                  text: 'Manage Stock',
                ),
                GButton(
                  icon: Icons.receipt,
                  text: 'Orders',
                ),
                GButton(
                  icon: Icons.camera_alt,
                  text: 'Camara',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
