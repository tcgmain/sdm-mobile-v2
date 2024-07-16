import 'package:flutter/material.dart';
import 'package:sdm/blocs/sub_organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class SubOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String organizationNummer;
  final String organizationName;
  final bool isTeamMemberUi;
  final String loggedUserNummer;

  const SubOrganizationView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.organizationNummer,
    required this.organizationName,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
  }) : super(key: key);

  @override
  State<SubOrganizationView> createState() => _SubOrganizationViewState();
}

class _SubOrganizationViewState extends State<SubOrganizationView> {
  late SubOrganizationBloc _subOrganizationBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredSubOrganizations;
  List<Organization>? _allSubOrganizations;

  @override
  void initState() {
    super.initState();
    _subOrganizationBloc = SubOrganizationBloc();
    _subOrganizationBloc.getSubOrganization(widget.organizationNummer);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _subOrganizationBloc.dispose();
    _searchController.dispose();
    super.dispose();
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
        child: BackgroundImage(
          isTeamMemberUi: widget.isTeamMemberUi,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textField.TextField(
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
                          return Loading(loadingMessage: snapshot.data!.message.toString());

                        case Status.COMPLETED:
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
                            return ListView.builder(
                              itemCount: _filteredSubOrganizations!.length,
                              itemBuilder: (context, index) {
                                final subOrganizations = snapshot.data!.data![index];
                                final subOrganizationId = subOrganizations.id.toString();
                                final subOrganizationNummer = subOrganizations.orgnummer.toString();
                                final subOrganizationName = subOrganizations.namebspr?.toString() ?? 'Unnamed Route';
                                final subOrganizationPhone1 = subOrganizations.yphone1?.toString() ?? 'Unnamed Route';
                                final subOrganizationPhone2 = subOrganizations.yphone2?.toString() ?? 'Unnamed Route';
                                final subOrganizationAddress1 =
                                    subOrganizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                final subOrganizationAddress2 =
                                    subOrganizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                final subOrganizationAddress3 =
                                    subOrganizations.yaddressl3?.toString() ?? 'Unnamed Route';
                                final subOrganizationAddress4 =
                                    subOrganizations.yaddressl4?.toString() ?? 'Unnamed Route';
                                final subOrganizationColour = subOrganizations.colour?.toString() ?? 'Unnamed Route';
                                final subOrganizationLongitude =
                                    subOrganizations.longitude?.toString() ?? 'Unnamed Route';
                                final subOrganizationLatitude =
                                    subOrganizations.latitude?.toString() ?? 'Unnamed Route';
                                final subOrganizationDistance =
                                    subOrganizations.distance?.toString() ?? 'Unnamed Route';
                                final subOrganizationMail = subOrganizations.yemail?.toString() ?? 'Unnamed Route';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3, top: 3),
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
                                                organizationAddress1: subOrganizationAddress1,
                                                organizationAddress2: subOrganizationAddress2,
                                                organizationAddress3: subOrganizationAddress3,
                                                organizationAddress4: subOrganizationAddress4,
                                                organizationColour: subOrganizationColour,
                                                organizationLongitude: subOrganizationLongitude,
                                                organizationLatitude: subOrganizationLatitude,
                                                organizationDistance: subOrganizationDistance,
                                                organizationMail: subOrganizationMail,
                                                isTeamMemberUi: widget.isTeamMemberUi,
                                                loggedUserNummer: widget.loggedUserNummer,
                                              )));
                                    },
                                  ),
                                );
                              },
                            );
                          }

                        case Status.ERROR:
                          WidgetsBinding.instance.addPostFrameCallback((_) {
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
      ),
    );
  }
}
