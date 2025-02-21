import 'package:flutter/material.dart';
import 'package:sdm/blocs/organization_asignee_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/add_organization_view.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;
import 'package:flutter_slidable/flutter_slidable.dart';

class OrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;

  const OrganizationView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
  });

  @override
  State<OrganizationView> createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  late OrganizationAsigneeBloc _organizationAsigneeBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredOrganizations = [];
  List<Organization>? _allOrganizations;
  bool _isLoading = false;
  bool _onlyInactive = false;
  bool _isErrorMessageShown = false;

  @override
  void initState() {
    super.initState();
    _organizationAsigneeBloc = OrganizationAsigneeBloc();
    isDataViewer(widget.designationNummer) == true
        ? _organizationAsigneeBloc.getOrganization("", _onlyInactive ? "false" : "true", "")
        : _organizationAsigneeBloc.getOrganization(widget.userNummer, _onlyInactive ? "false" : "true", "");
    _searchController.addListener(_onSearchChanged);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _organizationAsigneeBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateToAddOrganizationView() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddOrganizationView(
                userNummer: widget.userNummer,
                loggedUserNummer: widget.loggedUserNummer,
                userOrganizationNummer: widget.userOrganizationNummer,
                username: widget.username,
                isTeamMemberUi: widget.isTeamMemberUi,
              )),
    );

    if (result == true) {
      setState(() {
        isDataViewer(widget.designationNummer) == true
            ? _organizationAsigneeBloc.getOrganization("", _onlyInactive ? "false" : "true", "")
            : _organizationAsigneeBloc.getOrganization(widget.userNummer, _onlyInactive ? "false" : "true", "");
        _isLoading = true;
      });
    }
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
      territoryNummer,
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
                territoryNummer: territoryNummer,
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
        isDataViewer(widget.designationNummer) == true
            ? _organizationAsigneeBloc.getOrganization("", _onlyInactive ? "false" : "true", "")
            : _organizationAsigneeBloc.getOrganization(widget.userNummer, _onlyInactive ? "false" : "true", "");
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
        title: widget.isTeamMemberUi == true
            ? 'Region - ${widget.username} '
            : isDataViewer(widget.designationNummer) == true
                ? 'All Organizations'
                : 'My Region',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: widget.isTeamMemberUi == false ? true : false,
      ),
      floatingActionButton: widget.isTeamMemberUi == false || isDataViewer(widget.designationNummer) == false
          ? FloatingActionButton(
              onPressed: () {
                _navigateToAddOrganizationView();
              },
              backgroundColor: CustomColors.buttonColor,
              child: const Icon(
                Icons.add,
                color: CustomColors.buttonTextColor,
              ),
            )
          : Container(),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Column(
                children: [
                  SwitchListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
                    title: Text(
                      "Show only inactive organizations",
                      style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                    ),
                    value: _onlyInactive,
                    activeTrackColor: CustomColors.buttonColor,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                    onChanged: (bool value) {
                      setState(() {
                        _onlyInactive = value;
                        isDataViewer(widget.designationNummer) == true
                            ? _organizationAsigneeBloc.getOrganization("", _onlyInactive ? "false" : "true", "")
                            : _organizationAsigneeBloc.getOrganization(
                                widget.userNummer, _onlyInactive ? "false" : "true", "");
                        _isLoading = true;
                      });
                    },
                  ),
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
                      stream: _organizationAsigneeBloc.organizationAsigneeStream,
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
                                        child: (_onlyInactive == false)
                                            ? Text(
                                                'Total Active Organizations: $totalOrganizations',
                                                style:
                                                    TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                              )
                                            : Text(
                                                'Total Inactive Organizations: $totalOrganizations',
                                                style:
                                                    TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
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
                                            // Sort the organizations alphabetically by their name
                                            _filteredOrganizations!
                                                .sort((a, b) => (a.namebspr ?? '').compareTo(b.namebspr ?? ''));

                                            var organizations = _filteredOrganizations![index];
                                            String organizationId = organizations.id.toString();
                                            String organizationNummer = organizations.orgnummer.toString();
                                            String organizationName =
                                                organizations.namebspr?.toString() ?? 'Unnamed Route';
                                            String organizationPhone1 =
                                                organizations.yphone1?.toString() ?? 'Unnamed Route';
                                            String organizationPhone2 =
                                                organizations.yphone2?.toString() ?? 'Unnamed Route';
                                            String organizationWhatsapp =
                                                organizations.ywhtapp?.toString() ?? 'Unnamed Route';
                                            String organizationAddress1 =
                                                organizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                            String organizationAddress2 =
                                                organizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                                String organizationYtownNamebspr =
                                                organizations.ytownNamebspr?.toString() ?? 'Unnamed Route';
                                            String territoryNummer =
                                                organizations.yterritory?.toString() ?? 'Unnamed Route';
                                            String organizationColour =
                                                organizations.colour?.toString() ?? 'Unnamed Route';
                                            String organizationLongitude =
                                                organizations.longitude?.toString() ?? 'Unnamed Route';
                                            String organizationLatitude =
                                                organizations.latitude?.toString() ?? 'Unnamed Route';
                                            String organizationDistance =
                                                organizations.distance?.toString() ?? 'Unnamed Route';
                                            String organizationMail =
                                                organizations.yemail?.toString() ?? 'Unnamed Route';
                                            String ysuporgNummer =
                                                organizations.ysuporgNummer?.toString() ?? 'Unnamed Route';
                                            String ysuporgNamebspr =
                                                organizations.ysuporgNamebspr?.toString() ?? 'Unnamed Route';
                                            String organizationTypeId =
                                                organizations.ycustypId?.toString() ?? 'Unnamed Route';
                                            String organizationTypeNamebspr =
                                                organizations.ycustypNamebspr?.toString() ?? 'Unnamed Route';
                                            String organizationAssignTo =
                                                organizations.yassigto?.toString() ?? 'Unnamed Route';
                                            String ownerName = organizations.yowname?.toString() ?? 'Unnamed Route';
                                            String ownerBirthday =
                                                organizations.yorgowndob?.toString() ?? 'Unnamed Route';
                                            String isMasonry = organizations.ymasonry?.toString() ?? 'Unnamed Route';
                                            String isWaterproofing =
                                                organizations.ywaterpr?.toString() ?? 'Unnamed Route';
                                            String isFlooring = organizations.yflooring?.toString() ?? 'Unnamed Route';

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
                                                            territoryNummer,
                                                            ysuporgNummer,
                                                            ownerName,
                                                            ownerBirthday,
                                                            isMasonry,
                                                            isWaterproofing,
                                                            isFlooring,
                                                            organizationColour);
                                                      },
                                                      backgroundColor: CustomColors.buttonColor,
                                                      foregroundColor: CustomColors.buttonTextColor,
                                                      icon: Icons.edit,
                                                    ),
                                                  ],
                                                ),

                                                child: (!isDataViewer(widget.designationNummer))
                                                    ? InkWell(
                                                        splashColor: CustomColors.buttonColor,
                                                        onTap: () {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => HomeOrganizationView(
                                                                    userNummer: widget.userNummer,
                                                                    username: widget.username,
                                                                    routeNummer: "",
                                                                    organizationId: organizationId,
                                                                    organizationNummer: organizationNummer,
                                                                    organizationName: organizationName,
                                                                    organizationPhone1: organizationPhone1,
                                                                    organizationPhone2: organizationPhone2,
                                                                    organizationWhatsapp: organizationWhatsapp,
                                                                    organizationAddress1: organizationAddress1,
                                                                    organizationAddress2: organizationAddress2,
                                                                    organizationYtownNamebspr: organizationYtownNamebspr,
                                                                    territoryNummer: territoryNummer,
                                                                    organizationColour: organizationColour,
                                                                    organizationLongitude: organizationLongitude,
                                                                    organizationLatitude: organizationLatitude,
                                                                    organizationDistance: organizationDistance,
                                                                    organizationMail: organizationMail,
                                                                    isTeamMemberUi: widget.isTeamMemberUi,
                                                                    loggedUserNummer: widget.loggedUserNummer,
                                                                    ysuporgNummer: ysuporgNummer,
                                                                    ysuporgNamebspr: ysuporgNamebspr,
                                                                    designationNummer: widget.designationNummer,
                                                                    organizationTypeNamebspr: organizationTypeNamebspr,
                                                                    userOrganizationNummer:
                                                                        widget.userOrganizationNummer,
                                                                    ownerName: ownerName,
                                                                    ownerBirthday: ownerBirthday
                                                                  )));
                                                        },
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                                            shape: BoxShape.rectangle,
                                                            gradient: LinearGradient(
                                                              colors: <Color>[
                                                                Colors.black,
                                                                Colors.black26,
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
                                                                  style: TextStyle(
                                                                      color: CustomColors.textColor,
                                                                      fontSize: getFontSize()))),
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius: BorderRadius.circular(5),
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: <Color>[
                                                                Colors.black,
                                                                Colors.black26,
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
                                                                style: const TextStyle(color: CustomColors.textColor)),
                                                            subtitle: Text(
                                                              organizationAssignTo,
                                                              style: const TextStyle(color: CustomColors.textColor2),
                                                            ),
                                                          ),
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
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }
}
