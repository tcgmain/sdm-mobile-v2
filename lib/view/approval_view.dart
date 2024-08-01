import 'package:flutter/material.dart';
import 'package:sdm/view/approval_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';

class ApprovalView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;

  const ApprovalView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
  }) : super(key: key);

  @override
  State<ApprovalView> createState() => _ApprovalViewState();
}

class _ApprovalViewState extends State<ApprovalView> {
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
                children: [
                  ListButton(displayName: "Organization Approval", onPressed: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ApprovalOrganizationView(
                                      userNummer: widget.userNummer,
                                      isTeamMemberUi: widget.isTeamMemberUi, 
                                      username: widget.username, 
                                      loggedUserNummer: widget.loggedUserNummer, 
                                      userOrganizationNummer: widget.userOrganizationNummer, 
                                      designationNummer: widget.designationNummer,
                                    )),
                          );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
