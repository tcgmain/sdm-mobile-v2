import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/loading.dart';

class ApprovalView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const ApprovalView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<ApprovalView> createState() => _ApprovalViewState();
}

class _ApprovalViewState extends State<ApprovalView> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Pending Approvals',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: ListView(
                children: const [
                  Text(
                    '6787878',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            if (_isLoading) const Loading(), // Display loading indicator if _isLoading is true
          ],
        ),
      ),
    );
  }
}
