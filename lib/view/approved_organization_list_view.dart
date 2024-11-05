import 'package:flutter/material.dart';
import 'package:sdm/blocs/organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/organization_info_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;
import 'package:flutter_slidable/flutter_slidable.dart';

class ApprovedOrganizationListView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;

  const ApprovedOrganizationListView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
  });

  @override
  State<ApprovedOrganizationListView> createState() => _ApprovedOrganizationListViewState();
}

class _ApprovedOrganizationListViewState extends State<ApprovedOrganizationListView> {
  late OrganizationBloc _organizationBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredOrganizations = [];
  List<Organization>? _allOrganizations;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;

  @override
  void initState() {
    super.initState();
    _organizationBloc = OrganizationBloc();
    _organizationBloc.getOrganizationByApprover("", "true", "true", widget.username);
    _searchController.addListener(_onSearchChanged);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _organizationBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isNotEmpty) {
        _filteredOrganizations = _allOrganizations
                ?.where((organization) =>
                    organization.namebspr!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                    organization.yassigto!.toLowerCase().contains(_searchController.text.toLowerCase()))
                .toList() ??
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
        _organizationBloc.getOrganization("", "true", "true");
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
                stream: _organizationBloc.organizationStream,
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

                        final totalOrganizations = _filteredOrganizations!.length;
                        //print(_filteredOrganizations!.length.toString());
                        if (_filteredOrganizations!.isEmpty) {
                          return Center(
                            child: Text(
                              widget.isTeamMemberUi == false
                                  ? "No organizations have been assigned for you."
                                  : "No organizations have been assigned for ${widget.username}.",
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
                                    'Total Approved Organizations: $totalOrganizations',
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
                                      String organizationName = organizations.namebspr?.toString() ?? 'Unnamed Route';
                                      String organizationPhone1 = organizations.yphone1?.toString() ?? 'Unnamed Route';
                                      String organizationPhone2 = organizations.yphone2?.toString() ?? 'Unnamed Route';
                                      String organizationWhatsapp =
                                          organizations.ywhtapp?.toString() ?? 'Unnamed Route';
                                      String organizationAddress1 =
                                          organizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                      String organizationAddress2 =
                                          organizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                      String organizationAddress3 =
                                          organizations.yaddressl3?.toString() ?? 'Unnamed Route';
                                      String ownerBirthday = organizations.yorgowndob?.toString() ?? 'Unnamed Route';
                                      String organizationColor = organizations.colour?.toString() ?? 'Unnamed Route';
                                      // String organizationLongitude =
                                      //     organizations.longitude?.toString() ?? 'Unnamed Route';
                                      // String organizationLatitude =
                                      //     organizations.latitude?.toString() ?? 'Unnamed Route';
                                      // String organizationDistance =
                                      //     organizations.distance?.toString() ?? 'Unnamed Route';
                                      String organizationMail = organizations.yemail?.toString() ?? 'Unnamed Route';
                                      String ysuporgNummer = organizations.ysuporgNummer?.toString() ?? 'Unnamed Route';
                                      // String ysuporgNamebspr =
                                      //     organizations.ysuporgNamebspr?.toString() ?? 'Unnamed Route';
                                      String organizationTypeId =
                                          organizations.ycustypId?.toString() ?? 'Unnamed Route';
                                      // String organizationTypeNamebspr =
                                      //     organizations.ycustypNamebspr?.toString() ?? 'Unnamed Route';
                                      String organizationAssignTo =
                                          organizations.yassigto?.toString() ?? 'Unnamed Route';
                                      String organizationTown = organizations.yaddressl4?.toString() ?? 'Unnamed Route';
                                      String ownerName = organizations.yowname?.toString() ?? 'Unnamed Route';
                                      String isMasonry = organizations.ymasonry?.toString() ?? 'Unnamed Route';
                                      String isWaterproofing = organizations.ywaterpr?.toString() ?? 'Unnamed Route';
                                      String isFlooring = organizations.yflooring?.toString() ?? 'Unnamed Route';
                                      String creationDate = organizations.erfass?.toString() ?? 'Unnamed Route';
                                      String approvedBy = organizations.yorgappu?.toString() ?? 'Unnamed Route';
                                      String approvedDate = organizations.yorgappdt?.toString() ?? 'Unnamed Route';
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
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => OrganizationInfoView(
                                                        username: widget.username,
                                                        userNummer: widget.userNummer,
                                                        organizationNummer: organizationNummer,
                                                        isTeamMemberUi: widget.isTeamMemberUi,
                                                        loggedUserNummer: widget.loggedUserNummer,
                                                      )));
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
                                                          style: TextStyle(
                                                              color: CustomColors.textColorGrey,
                                                              fontSize: getFontSize()),
                                                        ),
                                                        Text(
                                                          "Created: $creationDate",
                                                          style: TextStyle(
                                                              color: CustomColors.textColorGrey,
                                                              fontSize: getFontSizeSmall()),
                                                        ),
                                                        Text(
                                                          "Approved: $approvedBy, $approvedDate",
                                                          style: TextStyle(
                                                              color: CustomColors.textColorGrey,
                                                              fontSize: getFontSizeSmall()),
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
}
