import 'package:flutter/material.dart';
import 'package:sdm/blocs/sub_organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;
import 'package:flutter_slidable/flutter_slidable.dart';

class SubOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String organizationNummer;
  final String organizationName;
  final bool isTeamMemberUi;
  final String loggedUserNummer;
  final String ysuporgNummer;
  final String ysuporgNamebspr;
  final String designationNummer;
  final String userOrganizationNummer;

  const SubOrganizationView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.organizationNummer,
    required this.organizationName,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
    required this.ysuporgNummer,
    required this.ysuporgNamebspr,
    required this.designationNummer,
    required this.userOrganizationNummer,
  });

  @override
  State<SubOrganizationView> createState() => _SubOrganizationViewState();
}

class _SubOrganizationViewState extends State<SubOrganizationView> {
  late SubOrganizationBloc _subOrganizationBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredSubOrganizations;
  List<Organization>? _allSubOrganizations;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _subOrganizationBloc = SubOrganizationBloc();
    _subOrganizationBloc.getSubOrganization(widget.organizationNummer);
    _searchController.addListener(_onSearchChanged);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _subOrganizationBloc.dispose();
    _searchController.dispose();
    super.dispose();
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
      ownerName,
      isMasonry,
      isWaterproofing,
      isFlooring,
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
                
                organizationAddress1: organizationAddress1,
                organizationAddress2: organizationAddress2,
                organizationAddress3: organizationAddress3,
                organizationTown: organizationTown,
                ownerName: ownerName,
                isMasonry: isMasonry,
                isWaterproofing: isWaterproofing,
                isFlooring: isFlooring,
                userOrganizationNummer: widget.userOrganizationNummer,
                designationNummer: widget.userOrganizationNummer,
                organizationColor: organizationColor,
              )),
    );

    if (result == true) {
      setState(() {
        _subOrganizationBloc.getSubOrganization(widget.organizationNummer);
        _isLoading = true;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredSubOrganizations = _allSubOrganizations
          ?.where((subOrganization) =>
              subOrganization.namebspr!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Sub Organizations',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: text_field.TextField(
                        controller: _searchController,
                        obscureText: false,
                        inputType: 'none',
                        isRequired: true,
                        fillColor: CustomColors.textFieldFillColor,
                        filled: true,
                        labelText: "Type to search sub organizations...",
                        onChangedFunction: () {}),
                  ),
                  Expanded(
                    child: StreamBuilder<ResponseList<Organization>>(
                      stream: _subOrganizationBloc.subOrganizationStream,
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
                              _allSubOrganizations = snapshot.data!.data!;
                              _filteredSubOrganizations ??= _allSubOrganizations;

                              if (_filteredSubOrganizations!.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No sub organizations have been assigned for ${widget.organizationName}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                  ),
                                );
                              } else {
                                return SlidableAutoCloseBehavior(
                                  closeWhenOpened: true,
                                  closeWhenTapped: false,
                                  child: ListView.builder(
                                    itemCount: _filteredSubOrganizations!.length,
                                    itemBuilder: (context, index) {
                                      final subOrganizations = snapshot.data!.data![index];
                                      final subOrganizationId = subOrganizations.id.toString();
                                      final subOrganizationNummer = subOrganizations.orgnummer.toString();
                                      final subOrganizationName =
                                          subOrganizations.namebspr?.toString() ?? 'Unnamed Route';
                                      final subOrganizationPhone1 =
                                          subOrganizations.yphone1?.toString() ?? 'Unnamed Route';
                                      final subOrganizationPhone2 =
                                          subOrganizations.yphone2?.toString() ?? 'Unnamed Route';
                                          final subOrganizationWhatsapp =
                                          subOrganizations.ywhtapp?.toString() ?? 'Unnamed Route';
                                      final subOrganizationAddress1 =
                                          subOrganizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                      final subOrganizationAddress2 =
                                          subOrganizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                      final subOrganizationAddress3 =
                                          subOrganizations.yaddressl3?.toString() ?? 'Unnamed Route';
                                      final subOrganizationTown =
                                          subOrganizations.yaddressl4?.toString() ?? 'Unnamed Route';
                                      final subOrganizationColour =
                                          subOrganizations.colour?.toString() ?? 'Unnamed Route';
                                      final subOrganizationLongitude =
                                          subOrganizations.longitude?.toString() ?? 'Unnamed Route';
                                      final subOrganizationLatitude =
                                          subOrganizations.latitude?.toString() ?? 'Unnamed Route';
                                      final subOrganizationDistance =
                                          subOrganizations.distance?.toString() ?? 'Unnamed Route';
                                      final subOrganizationMail =
                                          subOrganizations.yemail?.toString() ?? 'Unnamed Route';
                                      final subOrganizationSuperiorOrgNummer =
                                          subOrganizations.ysuporgNummer?.toString() ?? 'Unnamed Route';
                                      final subOrganizationSuperiorOrgNamebspr =
                                          subOrganizations.ysuporgNamebspr?.toString() ?? 'Unnamed Route';
                                      final subOrganizationCustomerTypeId =
                                          subOrganizations.ycustypId?.toString() ?? 'Unnamed Route';
                                      final subOrganizationCustomerTypeNamebspr =
                                          subOrganizations.ycustypNamebspr?.toString() ?? 'Unnamed Route';
                                      final ownerName = subOrganizations.yowname?.toString() ?? 'Unnamed Route';
                                      final isMasonry = subOrganizations.ymasonry?.toString() ?? 'Unnamed Route';
                                      final isWaterproofing = subOrganizations.ywaterpr?.toString() ?? 'Unnamed Route';
                                      final isFlooring = subOrganizations.yflooring?.toString() ?? 'Unnamed Route';

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
                                                  print("Pressed");

                                                  _navigateToUpdateOrganizationView(
                                                      subOrganizationId,
                                                      subOrganizationNummer,
                                                      subOrganizationName,
                                                      subOrganizationCustomerTypeId,
                                                      subOrganizationMail,
                                                      subOrganizationPhone1,
                                                      subOrganizationPhone2,
                                                      subOrganizationWhatsapp,
                                                      subOrganizationAddress1,
                                                      subOrganizationAddress2,
                                                      subOrganizationAddress3,
                                                      subOrganizationTown,
                                                      ownerName,
                                                      isMasonry,
                                                      isWaterproofing,
                                                      isFlooring,
                                                      subOrganizationColour);
                                                },
                                                backgroundColor: CustomColors.buttonColor,
                                                foregroundColor: CustomColors.buttonTextColor,
                                                icon: Icons.edit,
                                              ),
                                            ],
                                          ),
                                          child: ListButton(
                                            displayName: subOrganizationName,
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => HomeOrganizationView(
                                                        userNummer: widget.userNummer,
                                                        username: widget.username,
                                                        routeNummer: "",
                                                        organizationId: subOrganizationId,
                                                        organizationNummer: subOrganizationNummer,
                                                        organizationName: subOrganizationName,
                                                        organizationPhone1: subOrganizationPhone1,
                                                        organizationPhone2: subOrganizationPhone2,
                                                        organizationWhatsapp: subOrganizationWhatsapp,
                                                        organizationAddress1: subOrganizationAddress1,
                                                        organizationAddress2: subOrganizationAddress2,
                                                        organizationAddress3: subOrganizationAddress3,
                                                        organizationTown: subOrganizationTown,
                                                        organizationColour: subOrganizationColour,
                                                        organizationLongitude: subOrganizationLongitude,
                                                        organizationLatitude: subOrganizationLatitude,
                                                        organizationDistance: subOrganizationDistance,
                                                        organizationMail: subOrganizationMail,
                                                        isTeamMemberUi: widget.isTeamMemberUi,
                                                        loggedUserNummer: widget.loggedUserNummer,
                                                        ysuporgNummer: subOrganizationSuperiorOrgNummer,
                                                        ysuporgNamebspr: subOrganizationSuperiorOrgNamebspr,
                                                        designationNummer: widget.designationNummer,
                                                        organizationTypeNamebspr: subOrganizationCustomerTypeNamebspr,
                                                        userOrganizationNummer: widget.userOrganizationNummer,
                                                      )));
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
}
