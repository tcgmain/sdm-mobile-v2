import 'package:flutter/material.dart';
import 'package:sdm/blocs/approval_organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/organization_info_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;
import 'package:flutter_slidable/flutter_slidable.dart';

class ApprovalOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;

  const ApprovalOrganizationView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
  }) : super(key: key);

  @override
  State<ApprovalOrganizationView> createState() => _ApprovalOrganizationViewState();
}

class _ApprovalOrganizationViewState extends State<ApprovalOrganizationView> {
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredOrganizations = [];
  List<Organization>? _allOrganizations;
  bool _isLoading = false;
  late ApprovalOrganizationBloc _approvalOrganizationBloc;
  Map<String, bool> _approvalStatus = {};

  @override
  void initState() {
    super.initState();
    _approvalOrganizationBloc = ApprovalOrganizationBloc();
    _approvalOrganizationBloc.getApprovalOrganization(widget.userNummer);
    _searchController.addListener(_onSearchChanged);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _approvalOrganizationBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateToOrganizationInfoView(
    organizationNummer,
  ) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OrganizationInfoView(
              username: widget.username,
              userNummer: widget.userNummer,
              organizationNummer: organizationNummer,
              isTeamMemberUi: widget.isTeamMemberUi,
              loggedUserNummer: widget.loggedUserNummer,
            )));

    if (result == true) {
      setState(() {
        _approvalOrganizationBloc.getApprovalOrganization(widget.userNummer);
        _isLoading = true;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isNotEmpty) {
        _filteredOrganizations = _allOrganizations
                ?.where((organization) =>
                    organization.namebspr!.toLowerCase().contains(_searchController.text.toLowerCase()))
                .toList() ??
            [];
      } else {
        _filteredOrganizations = _allOrganizations ?? [];
      }
    });
  }

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
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Column(
                children: [
                  textField.TextField(
                      controller: _searchController,
                      obscureText: false,
                      inputType: 'none',
                      isRequired: true,
                      fillColor: CustomColors.textFieldFillColor,
                      filled: true,
                      labelText: "Type to search organizations...",
                      onChangedFunction: () {}),
                  Expanded(
                    child: StreamBuilder<ResponseList<Organization>>(
                      stream: _approvalOrganizationBloc.approvalOrganizationStream,
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
                              _allOrganizations = snapshot.data!.data!;
                              _filteredOrganizations = _searchController.text.isNotEmpty
                                  ? _allOrganizations!
                                      .where((organization) => organization.namebspr!
                                          .toLowerCase()
                                          .contains(_searchController.text.toLowerCase()))
                                      .toList()
                                  : _allOrganizations!;

                              _initializeApprovalStatus();

                              final totalOrganizations = _filteredOrganizations!.length;
                              if (_filteredOrganizations!.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No pending organization approvals",
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
                                          'Total Pending Organizations: $totalOrganizations',
                                          style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SlidableAutoCloseBehavior(
                                        closeWhenOpened: true,
                                        closeWhenTapped: false,
                                        child: ListView.builder(
                                          itemCount: _filteredOrganizations!.length,
                                          itemBuilder: (context, index) {
                                            var organizations = _filteredOrganizations![index];
                                            String organizationId = organizations.id.toString();
                                            String organizationNummer = organizations.orgnummer.toString();
                                            String organizationName =
                                                organizations.namebspr?.toString() ?? 'Unnamed Route';
                                            String organizationAssignTo =
                                                organizations.yassigto?.toString() ?? 'Unnamed Route';
                                            String organizationColour =
                                                organizations.colour?.toString() ?? 'Unnamed Route';

                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                                              child: Slidable(
                                                key: const ValueKey(0),
                                                endActionPane: ActionPane(
                                                  extentRatio: 0.2,
                                                  motion: const ScrollMotion(),
                                                  children: [
                                                    SlidableAction(
                                                      onPressed: (context) {
                                                        _navigateToOrganizationInfoView(organizationNummer);
                                                      },
                                                      backgroundColor: CustomColors.buttonColor,
                                                      foregroundColor: CustomColors.buttonTextColor,
                                                      icon: Icons.edit,
                                                    ),
                                                  ],
                                                ),
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
                                                          leading: CircleAvatar(
                                                            backgroundColor: getColor(organizationColour),
                                                            radius: 20,
                                                            child: const Icon(
                                                              Icons.business,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          title: Text(organizationName,
                                                              style:
                                                                  const TextStyle(color: CustomColors.cardTextColor)),
                                                          subtitle: Text(
                                                            organizationAssignTo,
                                                            style: const TextStyle(color: CustomColors.textColorGrey),
                                                          ),
                                                          trailing: _buildToggleSwitch(
                                                              _approvalStatus[organizationId] ?? false, (value) {
                                                            setState(() {
                                                              _approvalStatus[organizationId] = value;
                                                              if(value == true) {
                                                                showConfirmationPopup(context, organizationName);
                                                              }
                                                            });
                                                          }))),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                            case Status.ERROR:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                                showErrorAlertDialog(context, snapshot.data!.message.toString());
                              });
                          }
                        }
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  void _initializeApprovalStatus() {
    _filteredOrganizations?.forEach((organization) {
      if (!_approvalStatus.containsKey(organization.id.toString())) {
        _approvalStatus[organization.id.toString()] = false; // Initialize with default value if needed
      }
    });
  }

  Widget _buildToggleSwitch(bool value, ValueChanged<bool> onChanged) {
    return Switch(
        value: value,
        onChanged: onChanged,
        activeColor: CustomColors.buttonColor,
        inactiveThumbColor: CustomColors.textColorGrey,
        inactiveTrackColor: CustomColors.textHighlightColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap);
  }

  showConfirmationPopup(BuildContext context, String organizationName) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: CustomColors.successAlertBorderColor),
          ),
          elevation: 24.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade400,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
             
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Are you sure you want to approve organization: $organizationName?",
                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.cardTextColor),
                          ),
                         
                        
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                       
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: CustomColors.errorAlertTitleTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: CustomColors.errorAlertTitleTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
