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
    required String userName,
    required this.isHomePage,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  String? username;

  @override
  void initState() {
    super.initState();
    _getUsername();
    print(_getUsername());
  }

  Future<void> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';
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
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        PopupMenuButton<String>(
          onSelected: (String result) {
            if (result == 'logout') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              });
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'userName',
              enabled: false,
              child: Text(username ?? ''),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }
}
