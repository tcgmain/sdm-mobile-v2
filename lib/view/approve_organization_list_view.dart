import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/approved_organization_list_view.dart';
import 'package:sdm/view/create_order_view.dart';
import 'package:sdm/view/pendingapproval_organization_list_view.dart';
import 'package:sdm/view/sales_order_in_list_view.dart';
import 'package:sdm/view/sales_order_out_list_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';

class ApproveOrganizationListView extends StatefulWidget {
 
    final String userNummer;
  final String username;
  final String userId;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;

  const ApproveOrganizationListView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.userId,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
  }) : super(key: key);

  @override
  State<ApproveOrganizationListView> createState() => _ApproveOrganizationListViewState();
}

class _ApproveOrganizationListViewState extends State<ApproveOrganizationListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Organization Approvals',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: BackgroundImage(
          isTeamMemberUi: widget.isTeamMemberUi,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: CustomColors.appBarColor1,
                  labelColor: CustomColors.textColorWhite,
                  unselectedLabelColor: CustomColors.textColor,
                  labelStyle: TextStyle(
                    fontSize: getFontSize(),
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorWeight: 3,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tabs: const [
                    Tab(
                      text: 'Pending',
                      icon: Icon(Icons.hourglass_empty, size: 22),
                    ),
                    Tab(
                      text: 'Approved',
                      icon: Icon(Icons.check_circle, size: 22),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      PendingApproveOrganizationListView(
                        userNummer: widget.userNummer,
                        isTeamMemberUi: widget.isTeamMemberUi,
                        username: widget.username,
                        userId: widget.userId,
                        loggedUserNummer: widget.loggedUserNummer,
                        userOrganizationNummer: widget.userOrganizationNummer,
                        designationNummer: widget.designationNummer,
                      ),
                      ApprovedOrganizationListView(
                        userNummer: widget.userNummer,
                        username: widget.username,
                        loggedUserNummer: widget.loggedUserNummer,
                        isTeamMemberUi: widget.isTeamMemberUi, 
                        userOrganizationNummer: widget.userOrganizationNummer, 
                        designationNummer: widget.designationNummer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
