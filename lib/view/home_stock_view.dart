import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/camera_view.dart';
import 'package:sdm/view/manage_stock_view.dart';
import 'package:sdm/view/sales_order_view.dart';

class HomeStockView extends StatefulWidget {
  final String userNummer;
  final String organizationId;
  final String organizationNummer;
  final String routeNummer;

  const HomeStockView({
    Key? key,
    required this.userNummer,
    required this.organizationId,
    required this.organizationNummer,
    required this.routeNummer,
  }) : super(key: key);

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
      organizationId: widget.organizationId,
      organizationNummer: widget.organizationNummer,
      routeNummer: widget.routeNummer,
    ),
    const SalesOrderView(),
    const CameraView(),
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
      bottomNavigationBar: Container(
        color: CustomColors.navigationBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
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
                text: 'Sales Order',
              ),
              GButton(
                icon: Icons.camera_alt,
                text: 'Camara',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
