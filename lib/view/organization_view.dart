import 'package:flutter/material.dart';
import 'package:sdm/blocs/organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/add_organization_view.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class OrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const OrganizationView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<OrganizationView> createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  late OrganizationBloc _organizationBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredOrganizations;
  List<Organization>? _allOrganizations;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _organizationBloc = OrganizationBloc();
    _organizationBloc.getOrganization(widget.userNummer);
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

  Future<void> _navigateToAddOrganizationView() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddOrganizationView(
                userNummer: widget.userNummer,
                loggedUserNummer: widget.loggedUserNummer,
                username: widget.username,
                isTeamMemberUi: widget.isTeamMemberUi,
              )),
    );

    if (result == true) {
      setState(() {
        _organizationBloc.getOrganization(widget.userNummer);
        _isLoading = true;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      _filteredOrganizations = _allOrganizations
          ?.where((organization) => organization.namebspr!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.isTeamMemberUi == true ? 'Region - ${widget.username} ' : 'My Region',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: widget.isTeamMemberUi == false ? true : false,
      ),
      floatingActionButton: widget.isTeamMemberUi == false
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
                              _filteredOrganizations ??= _allOrganizations;
                              final totalOrganizations = _filteredOrganizations!.length;

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
                                          'Total Organizations: $totalOrganizations',
                                          style: TextStyle(fontSize: getFontSizeSmall(), color: CustomColors.textColor),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _filteredOrganizations!.length,
                                        itemBuilder: (context, index) {
                                          final organizations = _filteredOrganizations![index];
                                          final organizationId = organizations.id.toString();
                                          final organizationNummer = organizations.orgnummer.toString();
                                          final organizationName =
                                              organizations.namebspr?.toString() ?? 'Unnamed Route';
                                          final organizationPhone1 =
                                              organizations.yphone1?.toString() ?? 'Unnamed Route';
                                          final organizationPhone2 =
                                              organizations.yphone2?.toString() ?? 'Unnamed Route';
                                          final organizationAddress1 =
                                              organizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                          final organizationAddress2 =
                                              organizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                          final organizationAddress3 =
                                              organizations.yaddressl3?.toString() ?? 'Unnamed Route';
                                          final organizationAddress4 =
                                              organizations.yaddressl4?.toString() ?? 'Unnamed Route';
                                          final organizationColour =
                                              organizations.colour?.toString() ?? 'Unnamed Route';
                                          final organizationLongitude =
                                              organizations.longitude?.toString() ?? 'Unnamed Route';
                                          final organizationLatitude =
                                              organizations.latitude?.toString() ?? 'Unnamed Route';
                                          final organizationDistance =
                                              organizations.distance?.toString() ?? 'Unnamed Route';
                                          final organizationMail = organizations.yemail?.toString() ?? 'Unnamed Route';
                                          final ysuporgNummer =
                                              organizations.ysuporgNummer?.toString() ?? 'Unnamed Route';
                                          final ysuporgNamebspr =
                                              organizations.ysuporgNamebspr?.toString() ?? 'Unnamed Route';
                                          return Dismissible(
                                            key: Key(organizationId),
                                            background: Container(
                                              color: Colors.blue,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: Icon(Icons.edit, color: Colors.white),
                                            ),
                                            direction: DismissDirection.endToStart,
                                            onDismissed: (direction) {
                                              // Perform any action on dismiss (if needed)
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                                              child: ListButton(
                                                displayName: organizationName,
                                                onPressed: () {
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
                                                            organizationAddress1: organizationAddress1,
                                                            organizationAddress2: organizationAddress2,
                                                            organizationAddress3: organizationAddress3,
                                                            organizationAddress4: organizationAddress4,
                                                            organizationColour: organizationColour,
                                                            organizationLongitude: organizationLongitude,
                                                            organizationLatitude: organizationLatitude,
                                                            organizationDistance: organizationDistance,
                                                            organizationMail: organizationMail,
                                                            isTeamMemberUi: widget.isTeamMemberUi,
                                                            loggedUserNummer: widget.loggedUserNummer,
                                                            ysuporgNummer: ysuporgNummer,
                                                            ysuporgNamebspr: ysuporgNamebspr,
                                                          )));
                                                },
                                              ),
                                            ),
                                          );
                                        },
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
}
