// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/all_visit_history_view.dart';
import 'package:sdm/view/change_password_view.dart';
import 'package:sdm/view/home_view.dart';
import 'package:sdm/view/login_view.dart';
import 'package:sdm/view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;
  final bool isHomePage;
  final List<Widget>? customActions;

  const CommonAppBar({
    Key? key,
    required this.title,
    required this.onBackButtonPressed,
    required this.isHomePage,
    this.customActions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  String username = 'Guest';
  String userNummer = 'Guest';
  String userId = 'Guest';
  String userOrganizationNummer = 'Guest';
  String userDesignationNummer = 'Guest';

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
      userNummer = prefs.getString('userNummer') ?? 'Guest';
      userId = prefs.getString('userId') ?? 'Guest';
      userOrganizationNummer = prefs.getString('userOrganizationNummer') ?? 'Guest';
      userDesignationNummer = prefs.getString('userDesignationNummer') ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CustomColors.appBarColor3,
              CustomColors.appBarColor2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Text(
        widget.title,
        style: TextStyle(color: CustomColors.appBarTextColor, fontSize: getFontSizeLarge()),
      ),
      leading: widget.isHomePage
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackButtonPressed,
            ),
      actions: [
        if (!widget.isHomePage && widget.customActions == null)
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            username: username,
                            userNummer: userNummer,
                            userOrganizationNummer: userOrganizationNummer,
                            loggedUserNummer: userNummer,
                            isTeamMemberUi: false,
                            designationNummer: userDesignationNummer,
                          )),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        if (widget.customActions != null) ...widget.customActions!,
        PopupMenuButton<String>(
          onSelected: (String result) {
            switch (result) {
              case 'username':
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileView(username: username)));
                break;
              case 'changePassword':
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePasswordView(userId: userId)));
                break;
              case 'logout':
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                });
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'username',
              child: Row(
                children: [
                  const Icon(Icons.account_circle, color: CustomColors.appBarColor3),
                  const SizedBox(width: 10),
                  Text(
                    username,
                    style: const TextStyle(color: CustomColors.appBarColor3),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'changePassword',
              child: ListTile(
                leading: Icon(Icons.lock),
                title: Text('Change Password'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
