import 'package:flutter/material.dart';
import 'package:sdm/blocs/change_password_bloc.dart';
import 'package:sdm/models/change_password.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/success_alert.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;
import 'package:sdm/widgets/text_field.dart';

class ChangePasswordView extends StatefulWidget {
  final String userId;

  const ChangePasswordView({
    super.key,
    required this.userId,
  });

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late ChangePasswordBloc _changePasswordBloc;
  bool _isSuccessMessageShown = false;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = ChangePasswordBloc();
  }

  @override
  void dispose() {
    _changePasswordBloc.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void clearFormFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Change Password',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: false,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                ),
                height: 600,
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 40.0),
                constraints: const BoxConstraints(
                  maxWidth: 550,
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 40.0),
                    const Center(
                      child: Icon(
                        Icons.lock_open,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    text_field.TextField(
                        controller: _currentPasswordController,
                        obscureText: false,
                        inputType: 'none',
                        isRequired: true,
                        fillColor: CustomColors.textFieldFillColor,
                        filled: true,
                        labelText: "Current Password",
                        onChangedFunction: () {}),
                    const SizedBox(height: 20),
                    text_field.TextField(
                        controller: _newPasswordController,
                        obscureText: _showPassword,
                        inputType: 'none',
                        isRequired: true,
                        fillColor: CustomColors.textFieldFillColor,
                        filled: true,
                        suffixIcon: getPasswordSuffixIcon(_togglePasswordVisibility, _showPassword),
                        labelText: "New Password",
                        onChangedFunction: () {}),
                    const SizedBox(height: 20),
                    text_field.TextField(
                        controller: _confirmPasswordController,
                        obscureText: _showConfirmPassword,
                        inputType: 'none',
                        isRequired: true,
                        fillColor: CustomColors.textFieldFillColor,
                        filled: true,
                        suffixIcon: getPasswordSuffixIcon(_toggleConfirmPasswordVisibility, _showConfirmPassword),
                        labelText: "Confirm New Password",
                        onChangedFunction: () {}),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: changePasswordButton(context),
                    ),
                    const SizedBox(height: 20),
                    changePasswordResponse(),
                  ],
                ),
              ),
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  Widget changePasswordResponse() {
    return StreamBuilder<Response<ChangePassword>>(
      stream: _changePasswordBloc.changePasswordStream,
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
              if (!_isSuccessMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSuccessAlertDialog(context, "Password changed successfully", () {});
                  setState(() {
                    _isSuccessMessageShown = true;
                  });
                  Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                      clearFormFields();
                    });
                  });
                });
              }

              break;

            case Status.ERROR:
              if (!_isErrorMessageShown) {
                _isErrorMessageShown= true;
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
    );
  }

  Widget changePasswordButton(BuildContext context) {
    return CommonAppButton(
      buttonText: "Change Password",
      onPressed: () async {
        final currentPassword = _currentPasswordController.text;
        final newPassword = _newPasswordController.text;
        final confirmPassword = _confirmPasswordController.text;
        if (currentPassword == "" || newPassword == "" || confirmPassword == "") {
          showErrorAlertDialog(context, 'Please enter password fields');
        } else if (newPassword == confirmPassword) {
          setState(() {
            _isLoading = true;
          });
          _isErrorMessageShown = false;
          _isSuccessMessageShown = false;
          _changePasswordBloc.changePassword(newPassword, widget.userId);
        } else {
          showErrorAlertDialog(context, 'Passwords do not match');
        }
      },
    );
  }
}
