import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';

class CameraView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const CameraView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Camera',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: true,
      ),
      body: SafeArea(
        child: BackgroundImage(
          isTeamMemberUi: widget.isTeamMemberUi,
          child: Container(),
        ),
      ),
    );
  }
}
