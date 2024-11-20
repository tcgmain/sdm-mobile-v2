// ignore_for_file: library_prefixes, use_key_in_widget_constructors, library_private_types_in_public_api, unused_element, avoid_unnecessary_containers, sort_child_properties_last, use_build_context_synchronously

import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sdm/blocs/user_details_bloc.dart';
import 'package:sdm/models/user_details.dart';
import 'package:sdm/view/home_v2_view.dart';
import 'package:sdm/view/home_view.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:sdm/blocs/login_bloc.dart';
import 'package:sdm/models/login.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;
  late UserDetailsBloc _userDetailsBloc;
  bool _showPassword = true;
  var usernameController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');
  String deviceId = "";
  bool _saveCredentials = false;
  late String username;
  bool _isErrorMessageShown = false;
  bool _isUserDetailsErrorMessageShown = false;

  _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
      _isErrorMessageShown = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
    _userDetailsBloc = UserDetailsBloc();
    _fetchDeviceId();
    _loadCredentials();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    _userDetailsBloc.dispose();
    super.dispose();
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  Future<void> _saveCredentialsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setBool('saveCredentials', _saveCredentials);
  }

  Future<void> _fetchDeviceId() async {
    deviceId = (await _getId())!;
    setState(() {});
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      _saveCredentials = prefs.getBool('saveCredentials') ?? false;
    });
  }

  Future<void> _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('saveCredentials');
  }

  Widget loginButton(BuildContext context) {
    return CommonAppButton(
      buttonText: "Login",
      onPressed: () async {
        if (usernameController.text.toString() == "" || passwordController.text.toString() == "") {
          showErrorAlertDialog(context, "Please enter username and password");
        } else {
          _isErrorMessageShown = false;
          _isUserDetailsErrorMessageShown = false;

          String? deviceId = await _getId();
          print("THIS IS DEVICE ID:  $deviceId");

          _loginBloc.login(usernameController.text.toString(), passwordController.text.toString(), deviceId.toString());
          _isUserDetailsErrorMessageShown = false;
          if (_saveCredentials) {
            _saveCredentialsToPrefs();
          } else {
            _clearCredentials();
          }
        }
      },
    );
  }

  //This is for pop up message
  Widget deviceInfoButton(BuildContext context, String deviceId) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.info_outline_rounded, color: CustomColors.buttonTextColor),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Device ID',
          enabled: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Device ID: $deviceId"),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      FlutterClipboard.copy(deviceId).then((result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Device ID copied to clipboard')),
                        );
                      });
                    },
                  ),
                ],
              ),
              const Text("Version: 1.2"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
                image: const AssetImage('images/background.png'),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: deviceInfoButton(context, deviceId),
                ),
                Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      shape: BoxShape.rectangle,
                      color: Colors.transparent,
                    ),
                    height: 600,
                    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 60.0),
                    constraints: const BoxConstraints(
                      maxWidth: 550,
                    ),
                    child: ListView(children: [
                      const SizedBox(height: 40.0),
                      logo(context),
                      const SizedBox(height: 100.0),
                      text_field.TextField(
                          controller: usernameController,
                          obscureText: false,
                          inputType: 'none',
                          isRequired: true,
                          fillColor: CustomColors.textFieldFillColor,
                          filled: true,
                          labelText: "Username",
                          onChangedFunction: () {}),
                      const SizedBox(height: 20.0),
                      text_field.TextField(
                          controller: passwordController,
                          obscureText: _showPassword,
                          inputType: 'none',
                          isRequired: true,
                          function: _togglePasswordVisibility,
                          fillColor: CustomColors.textFieldFillColor,
                          filled: true,
                          labelText: "Password",
                          suffixIcon: getPasswordSuffixIcon(_togglePasswordVisibility, _showPassword),
                          onChangedFunction: () {
                            setState(() {
                              _isErrorMessageShown = true;
                            });
                          }),
                      const SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _saveCredentials,
                            onChanged: (value) {
                              setState(() {
                                _saveCredentials = value!;
                              });
                            },
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                color: CustomColors.checkBoxColor, // Border color
                                width: 1.0,
                              ),
                            ),
                            fillColor: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.transparent;
                                }
                                return Colors.transparent;
                              },
                            ),
                            checkColor: CustomColors.checkBoxColor,
                          ),
                          const Text(
                            "Save Credentials",
                            style: TextStyle(color: CustomColors.checkBoxColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: loginButton(context),
                      ),
                      const SizedBox(height: 20.0),
                      loginResponse(),
                      userDetailsResponse()
                    ]),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "SDM - SALES DATA MANAGEMENT",
                      style: TextStyle(color: CustomColors.appNameTextColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget logo(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60.0,
          child: Image.asset('images/tokyo_logo.png'),
        ),
      ],
    );
  }

  Widget loginResponse() {
    return StreamBuilder<Response<Login>>(
      stream: _loginBloc.loginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              return Column(
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              );
            case Status.COMPLETED:
              if (snapshot.data!.data!.ylogver == true) {
                username = snapshot.data!.data!.ylogopr.toString();
                _userDetailsBloc.getUserDetails(username);
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!_isErrorMessageShown) {
                    showErrorAlertDialog(context, snapshot.data!.data!.yerrmsg ?? 'Unknown error');
                    setState(() {
                      _isErrorMessageShown = true;
                    });
                  }
                });
              }
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isErrorMessageShown) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isErrorMessageShown = true;
                  });
                }
              });
              break;
          }
        }
        return Container();
      },
    );
  }

  Widget userDetailsResponse() {
    return StreamBuilder<ResponseList<UserDetails>>(
      stream: _userDetailsBloc.userDetailsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              return Column(
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              );

            case Status.COMPLETED:
              var userNummer = snapshot.data!.data![0].nummer.toString();
              var userOrganizationNummer = snapshot.data!.data![0].yorgNummer.toString();
              var designationNummer = snapshot.data!.data![0].designationNummer.toString();
              (isDataViewer(designationNummer))
                  ? WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeV2Page(
                                  username: username,
                                  userNummer: userNummer,
                                  userOrganizationNummer: userOrganizationNummer,
                                  loggedUserNummer: userNummer,
                                  isTeamMemberUi: false,
                                  designationNummer: designationNummer,
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
                                  userOrganizationNummer: userOrganizationNummer,
                                  loggedUserNummer: userNummer,
                                  isTeamMemberUi: false,
                                  designationNummer: designationNummer,
                                )),
                        (Route<dynamic> route) => false,
                      );
                    });

              usernameController = TextEditingController(text: '');
              passwordController = TextEditingController(text: '');
              break;
            case Status.ERROR:
              if (!_isUserDetailsErrorMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isErrorMessageShown = true;
                  });
                });
              }
          }
        }
        return Container();
      },
    );
  }
}
