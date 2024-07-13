// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_view.dart';
import 'package:sdm/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;
  final bool isHomePage;

  const CommonAppBar({
    Key? key,
    required this.title,
    required this.onBackButtonPressed,
    required this.isHomePage,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  String username = '';
  String userNummer = '';

  @override
  void initState() {
    super.initState();
    _getUsername();
    _getUserNummer();
  }

  Future<void> _getUsername() async {
    SharedPreferences prefsUserName = await SharedPreferences.getInstance();
    setState(() {
      username = prefsUserName.getString('username') ?? 'Guest';
    });
  }

  Future<void> _getUserNummer() async {
    SharedPreferences prefsUserNummer = await SharedPreferences.getInstance();
    setState(() {
      userNummer = prefsUserNummer.getString('userNummer') ?? 'Guest';
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
        style: const TextStyle(color: CustomColors.appBarTextColor),
      ),
      leading: widget.isHomePage
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackButtonPressed,
            ),
      actions: [
        if (!widget.isHomePage)
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(username: username, userNummer: userNummer, loggedUserNummer: userNummer,)),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        PopupMenuButton<String>(
          onSelected: (String result) {
            switch (result) {
              case 'changePassword':
                break;
              case 'activityLog':
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
                  Text(username, style: const TextStyle(color: CustomColors.appBarColor3),),
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
              value: 'activityLog',
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('Activity Log'),
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
