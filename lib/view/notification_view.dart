import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sdm/models/Bdnotification.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/bdnotification_bloc.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationView();
}

class _NotificationView extends State<NotificationView> {
  late BdnotificationBloc _bdnotificationBloc;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;
  List<Bdnotification>? _allTerritoryOrganizations;
  List<Bdnotification>? _allBirthdayNotifications;

  @override
  void initState() {
    super.initState();
    _bdnotificationBloc = BdnotificationBloc();
    getOwnerDetails();
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _showCallOptions(BuildContext context, String phone1, String phone2, String whatsapp) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (phone1.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(phone1),
                    onTap: () {
                      _launchDialer(phone1);
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (phone2.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(phone2),
                    onTap: () {
                      _launchDialer(phone2);
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (whatsapp.isNotEmpty)
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.whatsapp),
                  title: Text(whatsapp),
                  onTap: () {
                    Navigator.pop(context);
                    _launchWhatsApp(whatsapp);
                  },
                ),
              if (phone1.isEmpty && phone2.isEmpty && whatsapp.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No contact numbers available',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> getOwnerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? territoryNummer = prefs.getString('userTerritoryNumber');
    if (int.tryParse(territoryNummer!) != null) {
      setState(() {
        _isLoading = true;
      });
      _bdnotificationBloc.getBdnotification(territoryNummer);
    } else {
      print("Failed to fetch territory number");
    }
    return null;
  }

  bool isBirthday(String? orgOwnerBd) {
    try {
      if (orgOwnerBd == null || orgOwnerBd.trim().isEmpty) return false; // Handle null or empty values

      // Check the format before parsing
      if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(orgOwnerBd)) {
        print("Invalid date format: $orgOwnerBd");
        return false;
      }

      DateTime userBirthDate = DateFormat('dd/MM/yyyy').parse(orgOwnerBd);
      DateTime today = DateTime.now();

      return userBirthDate.day == today.day && userBirthDate.month == today.month;
    } catch (e) {
      print("Error in isBirthday: $e");
      return false;
    }
  }

  @override
  void dispose() {
    _bdnotificationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Notifications',
        onBackButtonPressed: () {
          Navigator.pop(context, false);
        },
        isHomePage: false,
        isNotificationScreen: true,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          BackgroundImage(
              isTeamMemberUi: false,
              child: StreamBuilder<ResponseList<Bdnotification>>(
                stream: _bdnotificationBloc.bdnotificationStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status!) {
                      case Status.LOADING:
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _isLoading = true;
                          });
                        });

                      case Status.COMPLETED:
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                        _allTerritoryOrganizations = snapshot.data!.data!;

                        _allBirthdayNotifications = _allTerritoryOrganizations!
                            .where((notification) => isBirthday(notification.yorgowndob))
                            .toList();

                        if (_allBirthdayNotifications!.isEmpty) {
                          return Center(
                            child: Text(
                              "No Birthdays Today.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Today, there are ${_allBirthdayNotifications!.length} birthdays. Don't miss the chance to wish them!",
                                    style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _allBirthdayNotifications!.length,
                                  itemBuilder: (context, index) {
                                    final response = _allBirthdayNotifications![index];
                                    final ownerName = response.yowname ?? "Undefined Owner Name";
                                    final organizationName = response.namebspr.toString();
                                    final phone1 = response.yphone1.toString();
                                    final phone2 = response.yphone2.toString();
                                    final whatsapp = response.ywhtapp.toString();

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                Colors.grey.shade400,
                                                Colors.white,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: const CircleAvatar(
                                              backgroundColor: Colors.yellow,
                                              radius: 20,
                                              child: Icon(
                                                Icons.cake,
                                                size: 20,
                                              ),
                                            ),
                                            title: Text(ownerName,
                                                style: const TextStyle(color: CustomColors.cardTextColor)),
                                            subtitle: Text(
                                              organizationName,
                                              style: const TextStyle(color: CustomColors.textColorGrey),
                                            ),
                                          
                                            trailing: 
                                              IconButton(
                                                icon: const Icon(Icons.call),
                                                onPressed: () {
                                                  _showCallOptions(context, phone1, phone2, whatsapp);
                                                },
                                              ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }

                      case Status.ERROR:
                        if (!_isErrorMessageShown) {
                          _isErrorMessageShown = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _isLoading = false;
                            });
                            showErrorAlertDialog(context, snapshot.data!.message.toString());
                          });
                        }
                    }
                  }
                  return Container();
                },
              )),
          if (_isLoading) const Loading()
        ],
      )),
    );
  }

  Widget listItemView(Bdnotification notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefxIcon(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${notification.yowname}'s Birthday is Today",
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  const Text(
                    "Don't miss the chnace to wish Him!",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefxIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.notifications, size: 25, color: Colors.black),
    );
  }
}
