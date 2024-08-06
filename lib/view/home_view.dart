// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/organization_view.dart';
import 'package:sdm/view/route_view.dart';
import 'package:sdm/view/team_view.dart';

class HomePage extends StatefulWidget {
  final String userNummer;
  final String userOrganizationNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;
  final int initialTabIndex;

  const HomePage({
    super.key,
    required this.userNummer,
    required this.userOrganizationNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
    this.initialTabIndex = 0,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  late final List<Widget> _pages;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;

    _pages = [
      RouteView(
        username: widget.username,
        userNummer: widget.userNummer,
        isTeamMemberUi: widget.isTeamMemberUi,
        loggedUserNummer: widget.loggedUserNummer,
        designationNummer: widget.designationNummer,
        userOrganizationNummer: widget.userOrganizationNummer,
      ),
      OrganizationView(
        username: widget.username,
        userNummer: widget.userNummer,
        userOrganizationNummer: widget.userOrganizationNummer,
        loggedUserNummer: widget.loggedUserNummer,
        isTeamMemberUi: widget.isTeamMemberUi,
        designationNummer: widget.designationNummer,
      ),
      TeamView(
        userNummer: widget.userNummer,
        username: widget.username,
        isTeamMemberUi: widget.isTeamMemberUi,
      ),
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
              selectedIndex: _selectedIndex,
              tabs: [
                const GButton(
                  icon: Icons.route,
                  text: 'Routes',
                ),
                GButton(
                  icon: Icons.business,
                  text: isDataViewer(widget.designationNummer) == true ? 'All Organizations' : 'Region',
                ),
                const GButton(
                  icon: Icons.people,
                  text: 'Team',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
