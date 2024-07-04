// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/region_view.dart';
import 'package:sdm/view/routes_view.dart';
import 'package:sdm/view/team_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
  }

  final List<Widget> _pages = [
    const RoutesView(),
    const RegionView(),
    const TeamView(),
  ];
  //double buttonPadding = 10;
  //double buttonHeight = 60.0;

  @override
  void initState() {
    super.initState();
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
                icon: Icons.route,
                text: 'Routes',
              ),
              GButton(
                icon: Icons.location_on,
                text: 'Region',
              ),
              GButton(
                icon: Icons.people,
                text: 'Team',
              )
            ],
          ),
        ),
      ),
    );
  }
}
