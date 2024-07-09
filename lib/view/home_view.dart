// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/organization_view.dart';
import 'package:sdm/view/route_view.dart';
import 'package:sdm/view/team_view.dart';

class HomePage extends StatefulWidget {
  final String userNummer;

  const HomePage({super.key, required this.userNummer});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      RouteView(
        userNummer: widget.userNummer,
      ),
      OrganizationView(userNummer: widget.userNummer),
      const TeamView(),
    ];
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
