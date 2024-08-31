import 'package:flutter/material.dart';
import 'package:sdm/blocs/permission_bloc.dart';
import 'package:sdm/models/permission.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/view/approve_organization_list_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';

class ApprovalView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userId;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;

  const ApprovalView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.userId,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
  });

  @override
  State<ApprovalView> createState() => _ApprovalViewState();
}

class _ApprovalViewState extends State<ApprovalView> {
  bool _isLoading = false;
  bool _isErrorMessageShown = false;
  bool _isDataLoaded = false;
  late PermissionBloc _permissionBloc;
  String approvalName = "";

  @override
  void initState() {
    super.initState();
    _permissionBloc = PermissionBloc();
  }

  @override
  void dispose() {
    _permissionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Pending Approvals',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
        isPendingApprovalDisabled: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: ListView(
                children: [
                  ListButton(
                      displayName: "Organization Approval",
                      onPressed: () {
                        _isErrorMessageShown = false;
                        _isDataLoaded = false;
                        setState(() {
                          _isLoading = true;
                        });
                        approvalName = "organizations";
                        _permissionBloc.getPermission("SDMOA", widget.userId);
                      })
                ],
              ),
            ),
            checkPermissionResponse(),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  Widget checkPermissionResponse() {
    return StreamBuilder<ResponseList<Permission>>(
      stream: _permissionBloc.permissionStream,
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
              if (!_isDataLoaded) {
                _isDataLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isLoading = false;
                  });
                });
                if (snapshot.data!.data!.isNotEmpty) {
                  String such = snapshot.data!.data![0].such.toString();
                  print(such);

                  if (such == "SDMOA") {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ApproveOrganizationListView(
                                userNummer: widget.userNummer,
                                isTeamMemberUi: widget.isTeamMemberUi,
                                username: widget.username,
                                userId: widget.userId,
                                loggedUserNummer: widget.loggedUserNummer,
                                userOrganizationNummer: widget.userOrganizationNummer,
                                designationNummer: widget.designationNummer,
                              )));
                    });
                  }
                } else {
                  if (!_isErrorMessageShown) {
                    _isErrorMessageShown = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showErrorAlertDialog(context,
                          "You have no permission to approve $approvalName. Please contact system administrator.");
                    });
                  }
                }
              }

              break;

            case Status.ERROR:
              if (!_isErrorMessageShown) {
                _isErrorMessageShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isLoading = false;
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
