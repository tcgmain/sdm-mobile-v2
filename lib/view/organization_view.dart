import 'package:flutter/material.dart';
import 'package:sdm/blocs/organization_bloc.dart';
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

class OrganizationView extends StatefulWidget {
  final String userNummer;

  const OrganizationView({
    Key? key,
    required this.userNummer,
  }) : super(key: key);

  @override
  State<OrganizationView> createState() => _OrganizationViewState();
}

class _OrganizationViewState extends State<OrganizationView> {
  late OrganizationBloc _organizationBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Organization>? _filteredOrganizations;
  List<Organization>? _allOrganizations;

  @override
  void initState() {
    super.initState();
    _organizationBloc = OrganizationBloc();
    _organizationBloc.getOrganization();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _organizationBloc.dispose();
    _searchController.dispose();
    super.dispose();
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
        title: 'Organizations',
        onBackButtonPressed: () {},
        isHomePage: true,
      ),
      body: SafeArea(
        child: BackgroundImage(
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
                    labelText: "Type to search organizations...",
                    onChangedFunction: () {}),
              ),
              Expanded(
                child: StreamBuilder<ResponseList<Organization>>(
                  stream: _organizationBloc.organizationStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return Loading(loadingMessage: snapshot.data!.message.toString());

                        case Status.COMPLETED:
                          _allOrganizations = snapshot.data!.data!;
                          _filteredOrganizations ??= _allOrganizations;

                          if (_filteredOrganizations!.isEmpty) {
                            return Center(
                              child: Text(
                                "No organizations have been assigned for you.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: _filteredOrganizations!.length,
                              itemBuilder: (context, index) {
                                final organizations = snapshot.data!.data![index];
                                final organizationNummer = organizations.orgnummer.toString();
                                final organizationName = organizations.namebspr?.toString() ?? 'Unnamed Route';
                                final organizationPhone1 = organizations.yphone1?.toString() ?? 'Unnamed Route';
                                final organizationPhone2 = organizations.yphone2?.toString() ?? 'Unnamed Route';
                                final organizationAddress1 = organizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                final organizationAddress2 = organizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                final organizationAddress3 = organizations.yaddressl3?.toString() ?? 'Unnamed Route';
                                final organizationAddress4 = organizations.yaddressl4?.toString() ?? 'Unnamed Route';
                                final organizationColour = organizations.colour?.toString() ?? 'Unnamed Route';
                                final organizationLongitude = organizations.longitude?.toString() ?? 'Unnamed Route';
                                final organizationLatitude = organizations.latitude?.toString() ?? 'Unnamed Route';
                                final organizationDistance = organizations.distance?.toString() ?? 'Unnamed Route';
                                final organizationMail = organizations.yemail?.toString() ?? 'Unnamed Route';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3, top: 3),
                                  child: ListButton(
                                    displayName: organizationName,
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => HomeOrganizationView(
                                                userNummer: widget.userNummer,
                                                routeNummer: "",
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
