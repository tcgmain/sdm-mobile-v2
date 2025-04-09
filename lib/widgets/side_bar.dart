// common_drawer.dart
import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/approve_view.dart';
import 'package:sdm/view/dashboard_view.dart';
import 'package:sdm/view/settings_view.dart';

class CommonDrawer extends StatelessWidget {
  final String username;
  final String userNummer;
  final String userId;
  final String userOrganizationNummer;
  final String designationNummer;

  const CommonDrawer({
    super.key,
    required this.username,
    required this.userNummer,
    required this.userId,
    required this.userOrganizationNummer,
    required this.designationNummer,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //width: 300,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              CustomColors.sidebarColor5,
              CustomColors.sidebarColor3,
            ],
          ),
        ),
        child: Column(
          //padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: const Text('user@example.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              decoration: const BoxDecoration(
                //color: Colors.redAccent,
                gradient: LinearGradient(
                  colors: [
                    CustomColors.buttonColor3,
                    CustomColors.buttonColor2,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_customize, color: Colors.white),
              title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashboardView(userNummer: userNummer)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending_actions, color: Colors.white),
              title: const Text('Pending Approvals', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ApprovalView(
                          userNummer: userNummer,
                          username: username,
                          userId: userId,
                          loggedUserNummer: userNummer,
                          isTeamMemberUi: false,
                          userOrganizationNummer: userOrganizationNummer,
                          designationNummer: designationNummer,
                        )));
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                 Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
