import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/loading.dart';

class CameraView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const CameraView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final bool _isLoading = true; 

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
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: ListView(
                children: const [
                  Text('6787878', style: TextStyle(fontSize: 20),),
                 
                ],
              ),
            ),
            if (_isLoading)
              const Loading(), // Display loading indicator if _isLoading is true
          ],
        ),
      ),
    );
  }
}
