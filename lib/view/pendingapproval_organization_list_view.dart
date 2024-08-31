import 'package:flutter/material.dart';
import 'package:sdm/blocs/approve_organization_bloc.dart';
import 'package:sdm/blocs/pending_approval_organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/approve_organization_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;
import 'package:flutter_slidable/flutter_slidable.dart';

class PendingApproveOrganizationListView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userId;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;

  const PendingApproveOrganizationListView({
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
  State<PendingApproveOrganizationListView> createState() => _PendingApproveOrganizationListViewState();
}

class _PendingApproveOrganizationListViewState extends State<PendingApproveOrganizationListView> {
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredOrganizations = [];
  List<Organization>? _allOrganizations;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;
  late ApprovalOrganizationBloc _approvalOrganizationBloc;
  late ApproveOrganizationBloc _approveOrganizationBloc;
  late String organizationNameMessage;
  //bool _onlyApprovedOrganizations = false;

  final Map<String, bool> _approvalStatus = {};

  @override
  void initState() {
    super.initState();
    _approvalOrganizationBloc = ApprovalOrganizationBloc();
    _approveOrganizationBloc = ApproveOrganizationBloc();
    _approvalOrganizationBloc.getApprovalOrganization(widget.userNummer);
    _searchController.addListener(_onSearchChanged);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _approvalOrganizationBloc.dispose();
    _approveOrganizationBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    print('Search Text: ${_searchController.text}');
    setState(() {
      if (_searchController.text.isNotEmpty) {
        _filteredOrganizations = _allOrganizations?.where((organization) {
              return organization.namebspr!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                  organization.yassigto!.toLowerCase().contains(_searchController.text.toLowerCase());
            }).toList() ??
            [];
      } else {
        _filteredOrganizations = _allOrganizations ?? [];
      }
    });
  }

  Future<void> _navigateToUpdateOrganizationView(
      organizationId,
      organizationNummer,
      organizationName,
      organizationTypeId,
      organizationMail,
      organizationPhone1,
      organizationPhone2,
      organizationWhatsapp,
      organizationAddress1,
      organizationAddress2,
      organizationAddress3,
      organizationTown,
      superiorOrganizationNummer,
      ownerName,
      ownerBirthday,
      ymasonry,
      ywaterpr,
      yflooring,
      organizationColor) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateOrganizationView(
                userNummer: widget.userNummer,
                loggedUserNummer: widget.loggedUserNummer,
                username: widget.username,
                isTeamMemberUi: widget.isTeamMemberUi,
                organizationId: organizationId,
                organizationNummer: organizationNummer,
                organizationName: organizationName,
                organizationTypeId: organizationTypeId,
                organizationMail: organizationMail,
                organizationPhone1: organizationPhone1,
                organizationPhone2: organizationPhone2,
                organizationWhatsapp: organizationWhatsapp,
                organizationAddress1: organizationAddress1,
                organizationAddress2: organizationAddress2,
                organizationAddress3: organizationAddress3,
                organizationTown: organizationTown,
                superiorOrganizationNummer: superiorOrganizationNummer,
                ownerName: ownerName,
                ownerBirthday: ownerBirthday,
                isMasonry: bool.parse(ymasonry),
                isWaterproofing: bool.parse(ywaterpr),
                isFlooring: bool.parse(yflooring),
                userOrganizationNummer: widget.userOrganizationNummer,
                designationNummer: widget.designationNummer,
                organizationColor: organizationColor,
              )),
    );
    if (result == true) {
      setState(() {
        _approvalOrganizationBloc.getApprovalOrganization(widget.userNummer);
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            text_field.TextField(
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
                                .where((organization) =>
                                    organization.namebspr!
                                        .toLowerCase()
                                        .contains(_searchController.text.toLowerCase()) ||
                                    organization.yassigto!.toLowerCase().contains(_searchController.text.toLowerCase()))
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
                                    'Total Pending Approval Organizations: $totalOrganizations',
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
                                      //String organizationId = organizations.id.toString();
                                      String organizationId = organizations.id.toString();
                                      String organizationNummer = organizations.orgnummer.toString();
                                      String organizationName = organizations.namebspr?.toString() ?? 'Unnamed Route';
                                      String organizationTypeId = organizations.ycustypId.toString();
                                      String organizationMail = organizations.yemail.toString();
                                      String organizationPhone1 = organizations.yphone1.toString();
                                      String organizationPhone2 = organizations.yphone2.toString();
                                      String organizationWhatsapp = organizations.ywhtapp.toString();
                                      String organizationAddress1 = organizations.yaddressl1.toString();
                                      String organizationAddress2 = organizations.yaddressl2.toString();
                                      String organizationAddress3 = organizations.yaddressl3.toString();
                                      String organizationTown = organizations.yaddressl4.toString();
                                      String ysuporgNummer = organizations.ysuporgNummer.toString();
                                      String ownerName = organizations.yowname.toString();
                                      String ownerBirthday = organizations.yorgowndob.toString();
                                      String isMasonry = organizations.ymasonry.toString();
                                      String isWaterproofing = organizations.ywaterpr.toString();
                                      String isFlooring = organizations.yflooring.toString();
                                      String organizationAssignTo =
                                          organizations.yassigto?.toString() ?? 'Unnamed Route';
                                      String organizationColor = organizations.colour?.toString() ?? 'Unnamed Route';
                                      String organizationCreationDate = organizations.erfass.toString();

                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 3, top: 3),
                                        child: Slidable(
                                          key: const ValueKey(0),
                                          // The end action pane is the one at the right or the bottom side.
                                          endActionPane: ActionPane(
                                            extentRatio: 0.2,
                                            motion: const ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  _navigateToUpdateOrganizationView(
                                                      organizationId,
                                                      organizationNummer,
                                                      organizationName,
                                                      organizationTypeId,
                                                      organizationMail,
                                                      organizationPhone1,
                                                      organizationPhone2,
                                                      organizationWhatsapp,
                                                      organizationAddress1,
                                                      organizationAddress2,
                                                      organizationAddress3,
                                                      organizationTown,
                                                      ysuporgNummer,
                                                      ownerName,
                                                      ownerBirthday,
                                                      isMasonry,
                                                      isWaterproofing,
                                                      isFlooring,
                                                      organizationColor);
                                                },
                                                backgroundColor: CustomColors.buttonColor,
                                                foregroundColor: CustomColors.buttonTextColor,
                                                icon: Icons.edit,
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => ApproveOrganizationView(
                                                          username: widget.username,
                                                          userNummer: widget.userNummer,
                                                          organizationNummer: organizationNummer,
                                                          isTeamMemberUi: widget.isTeamMemberUi,
                                                          loggedUserNummer: widget.loggedUserNummer,
                                                          userId: widget.userId,
                                                          userOrganizationNummer: widget.userOrganizationNummer,
                                                          designationNummer: widget.designationNummer,
                                                        )));
                                              });
                                            },
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
                                                      backgroundColor: getColor(organizationColor),
                                                      radius: 20,
                                                      child: const Icon(
                                                        Icons.business,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    title: Text(organizationName,
                                                        style: const TextStyle(color: CustomColors.cardTextColor)),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Assigned to: $organizationAssignTo",
                                                          style: const TextStyle(color: CustomColors.textColorGrey),
                                                        ),
                                                        Text(
                                                          "Created: $organizationCreationDate",
                                                          style: const TextStyle(color: CustomColors.textColorGrey),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
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
              ),
            )
          ],
        ),
        if (_isLoading) const Loading(),
      ],
    );
  }

  void _initializeApprovalStatus() {
    _filteredOrganizations?.forEach((organization) {
      if (!_approvalStatus.containsKey(organization.id.toString())) {
        _approvalStatus[organization.id.toString()] = false; // Initialize with default value if needed
      }
    });
  }

  // Widget _buildToggleSwitch(bool value, ValueChanged<bool> onChanged) {
  //   return Switch(
  //       value: value,
  //       onChanged: onChanged,
  //       activeTrackColor: CustomColors.buttonColor,
  //       activeColor: Colors.white,
  //       inactiveThumbColor: Colors.white,
  //       inactiveTrackColor: Colors.grey,
  //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap);
  // }

  showConfirmationPopup(
      BuildContext context, String organizationId, String organizationName, String organizationAssignTo) {
    return showDialog<bool>(
      barrierDismissible: false,
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
                            "Are you sure you want to approve $organizationName that has been assigned to $organizationAssignTo?",
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
                          setState(() {
                            _approvalStatus[organizationId] = false;
                          });
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
                          Navigator.of(context).pop();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _isLoading = true;
                            });
                          });
                          _approveOrganizationBloc.approveOrganization(organizationId, widget.username);
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
