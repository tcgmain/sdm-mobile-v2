import 'package:flutter/material.dart';
import 'package:sdm/blocs/organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/search_field.dart';
import 'package:sdm/widgets/login_text_field.dart' as textField;

class OrganizationView extends StatefulWidget {
  const OrganizationView({super.key});

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
        userName: '',
        isHomePage: true,
      ),
      body: SafeArea(
        child: BackgroundImage(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                // child: TextField(
                //   controller: _searchController,
                //   decoration: const InputDecoration(
                //     labelText: 'Search',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                child:          textField.TextField(
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
                                style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: _filteredOrganizations!.length,
                              itemBuilder: (context, index) {
                                final organization = _filteredOrganizations![index];
                                final organizationName = organization.namebspr?.toString() ?? 'Unnamed Route';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 3, top: 3),
                                  child: ListButton(
                                    displayName: organizationName,
                                    onPressed: () {
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (context) => RouteOrganizationView(
                                      //           routeNummer: routeNumb,
                                      //         )));
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
