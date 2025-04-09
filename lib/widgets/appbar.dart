// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/approve_view.dart';
import 'package:sdm/view/change_password_view.dart';
import 'package:sdm/view/home_v2_view.dart';
import 'package:sdm/view/home_view.dart';
import 'package:sdm/view/login_view.dart';
import 'package:sdm/view/notification_view.dart';
import 'package:sdm/view/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackButtonPressed;
  final bool isHomePage;
  final List<Widget>? customActions;
  final bool? isPendingApprovalDisabled;
  final bool? isNotificationScreen;
  final bool? isSideBarShown;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CommonAppBar({
    super.key,
    required this.title,
    required this.onBackButtonPressed,
    required this.isHomePage,
    this.customActions,
    this.isPendingApprovalDisabled,
    this.isNotificationScreen,
    this.isSideBarShown,
    this.scaffoldKey,
  });

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
      leading: (widget.isSideBarShown == true)
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                if (widget.scaffoldKey?.currentState != null) {
                  widget.scaffoldKey!.currentState!.openDrawer();
                }
              },
            )
          : widget.isHomePage
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
              (isDataViewer(userDesignationNummer))
                  ? WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeV2Page(
                                  username: username,
                                  userNummer: userNummer,
                                  userId: userId,
                                  userOrganizationNummer: userOrganizationNummer,
                                  loggedUserNummer: userNummer,
                                  isTeamMemberUi: false,
                                  designationNummer: userDesignationNummer,
                                )),
                        (Route<dynamic> route) => false,
                      );
                    })
                  : WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  username: username,
                                  userNummer: userNummer,
                                  userId: userId,
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
        if (widget.isNotificationScreen != true)
          // Notification Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationView(),
                    ),
                  );
                },
              ),
              const Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.blue,
                  child: Text(
                    '1', // Replace with actual notification count
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
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
              // case 'approval':
              //   if (widget.isPendingApprovalDisabled != true) {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => ApprovalView(
              //               userNummer: userNummer,
              //               username: username,
              //               userId: userId,
              //               loggedUserNummer: userNummer,
              //               isTeamMemberUi: false,
              //               userOrganizationNummer: userOrganizationNummer,
              //               designationNummer: userDesignationNummer,
              //             )));
              //   }
              //   break;
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
            // PopupMenuItem<String>(
            //   value: 'approval',
            //   child: ListTile(
            //     leading: (widget.isPendingApprovalDisabled == true)
            //         ? const Icon(
            //             Icons.check_circle,
            //             color: CustomColors.textColor2,
            //           )
            //         : const Icon(Icons.check_circle),
            //     title: (widget.isPendingApprovalDisabled == true)
            //         ? const Text(
            //             'Pending Approvals',
            //             style: TextStyle(color: CustomColors.textColor2),
            //           )
            //         : const Text('Pending Approvals'),
            //   ),
            // ),
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
