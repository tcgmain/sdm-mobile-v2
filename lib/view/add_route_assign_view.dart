// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:sdm/blocs/organization_bloc.dart';
import 'package:sdm/blocs/route_bloc.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/blocs/update_organization_bloc.dart';
import 'package:sdm/blocs/update_route_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/models/update_route.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/pendingapproval_organization_list_view.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sdm/widgets/success_alert.dart';

class RouteAssignView extends StatefulWidget {
  final String userId;
  final String userNummer;
  final String username;
  final String userOrganizationNummer;
  final String loggedUserNummer;
  final String organizationId;
  final String organizationNummer;
  final String organizationName;
  final String superiorOrganizationNummer;
  final String designationNummer;
  final bool isTeamMemberUi;

  const RouteAssignView({
    Key? key,
    required this.userId,
    required this.userNummer,
    required this.username,
    required this.userOrganizationNummer,
    required this.loggedUserNummer,
    required this.organizationId,
    required this.organizationNummer,
    required this.organizationName,
    required this.superiorOrganizationNummer,
    required this.designationNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<RouteAssignView> createState() => _RouteAssignViewState();
}

class _RouteAssignViewState extends State<RouteAssignView> {
  bool _isOrganizationLoading = true;
  bool _isRouteLoading = true;
  bool _isUpdateRouteLoading = false;
  bool _isUpdateOrganizationLoading = false;
  late OrganizationBloc _organizationBloc;
  late RouteOrganizationBloc _routeOrganizationBloc;
  late UpdateRouteBloc _updateRouteBloc;
  late UpdateOrganizationBloc _updateOrganizationBloc;
  List<Organization> _organizations = [];
  List<RouteOrganization> _routeOrganization = [];
  Organization? _selectedOrganization;
  RouteOrganization? _selectedRoute;
  bool _isOrganizationsLoaded = false;
  bool _isRoutesLoaded = false;
  bool _isButtonPressed = false;
  bool _isSuccessMessageShown = false;

  bool _isUpdateRouteCompleted = false;
  bool _isUpdateOrganizationCompleted = false;
  bool _isOrganizationErrorShown = false;
  bool _isRouteErrorShown = false;
  bool _isUpdateOrganizationErrorShown = false;
  bool _isUpdateRouteErrorShown = false;

  @override
  void initState() {
    super.initState();
    _organizationBloc = OrganizationBloc();
    _routeOrganizationBloc = RouteOrganizationBloc();
    _updateRouteBloc = UpdateRouteBloc();
    _updateOrganizationBloc = UpdateOrganizationBloc();
    _organizationBloc.getOrganization("", "true", "");
    _routeOrganizationBloc.getRouteOrganization("");
    setState(() {
      _isOrganizationLoading = true;
      _isRouteLoading = true;
    });
  }

  @override
  void dispose() {
    _organizationBloc.dispose();
    _routeOrganizationBloc.dispose();
    _updateRouteBloc.dispose();
    _updateOrganizationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Assign Route',
        onBackButtonPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PendingApproveOrganizationListView(
                    userNummer: widget.userNummer,
                    isTeamMemberUi: widget.isTeamMemberUi,
                    username: widget.username,
                    userId: widget.userId,
                    loggedUserNummer: widget.loggedUserNummer,
                    userOrganizationNummer: widget.userOrganizationNummer,
                    designationNummer: widget.designationNummer,
                  )));
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade400,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      organizationResponse(),
                      routeResponse(),
                      updateRouteResponse(),
                      updateOrganizationResponse(),
                      buildOrganizationDropdown(),
                      const SizedBox(height: 16),
                      buildRouteDropdown(),
                      const SizedBox(height: 16),
                      Center(
                        child: CommonAppButton(
                          buttonText: 'Update',
                          onPressed: () {
                            if (_selectedOrganization != null || _selectedRoute != null) {
                              String selectedOrganizationNummer = "";
                              String selectedRouteId = "";
                              if (_selectedOrganization != null) {
                                selectedOrganizationNummer = _selectedOrganization!.orgnummer.toString();
                              }
                              if (_selectedRoute != null) {
                                selectedRouteId = _selectedRoute!.id.toString();
                              }

                              showConfirmationPopup(context, selectedRouteId, selectedOrganizationNummer);
                            } else {
                              showErrorAlertDialog(context,
                                  "Please select a superior organization or route to proceed with the update.");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isOrganizationLoading || _isRouteLoading || _isUpdateOrganizationLoading || _isUpdateRouteLoading)
              const Loading(),
          ],
        ),
      ),
    );
  }

  Widget organizationResponse() {
    return StreamBuilder<ResponseList<Organization>>(
      stream: _organizationBloc.organizationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isOrganizationLoading = true;
                });
              });

            case Status.COMPLETED:
              if (!_isOrganizationsLoaded) {
                _isOrganizationsLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isOrganizationLoading = false;
                    _organizations = snapshot.data!.data!;

                    // Find the matching organization or set a default value
                    Organization? matchingOrg =
                        _organizations.firstWhere((org) => org.orgnummer == widget.superiorOrganizationNummer);

                    _selectedOrganization = matchingOrg;
                  });
                });
              }

              break;
            case Status.ERROR:
              if (!_isOrganizationErrorShown) {
                _isOrganizationErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isOrganizationLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
          }
        }
        return Container();
      },
    );
  }

  Widget routeResponse() {
    return StreamBuilder<ResponseList<RouteOrganization>>(
      stream: _routeOrganizationBloc.routeOrganizationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isRouteLoading = true;
                });
              });

            case Status.COMPLETED:
              if (!_isRoutesLoaded) {
                _isRoutesLoaded = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isRouteLoading = false;
                    _routeOrganization = snapshot.data!.data!;
                  });
                });
              }

            case Status.ERROR:
              if (!_isRouteErrorShown) {
                _isRouteErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isRouteLoading = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
          }
        }
        return Container();
      },
    );
  }

  Widget updateRouteResponse() {
    return StreamBuilder<Response<UpdateRoute>>(
      stream: _updateRouteBloc.updateRouteStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateRouteLoading = true;
                });
              });

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateRouteLoading = false;
                  _isButtonPressed = false;
                  _isUpdateRouteCompleted = true;
                });
                if (!_isSuccessMessageShown) {
                  _isSuccessMessageShown = true;
                  showSuccessAlertDialogWithBack(context, "${widget.organizationName} has been updated.");
                }
                _checkForSuccess();
              });
              break;
            case Status.ERROR:
              if (!_isUpdateRouteErrorShown) {
                _isUpdateRouteErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isUpdateRouteLoading = false;
                    _isButtonPressed = false;
                  });
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
          }
        }
        return Container();
      },
    );
  }

  Widget updateOrganizationResponse() {
    return StreamBuilder<Response<UpdateOrganization>>(
      stream: _updateOrganizationBloc.updateOrganizationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateOrganizationLoading = true;
                });
              });

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isUpdateOrganizationLoading = false;
                  _isUpdateOrganizationCompleted = true;
                });
                _checkForSuccess();
              });

              break;
            case Status.ERROR:
              if (!_isUpdateOrganizationErrorShown) {
                _isUpdateOrganizationErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isUpdateOrganizationErrorShown = true;
                    _isUpdateOrganizationLoading = false;
                  });
                });
              }
          }
        }
        return Container();
      },
    );
  }

  Widget buildOrganizationDropdown() {
    return DropdownSearch<Organization>(
      items: _organizations,
      itemAsString: (Organization u) => u.namebspr.toString(),
      onChanged: (Organization? organization) {
        setState(() {
          _selectedOrganization = organization;
        });
      },
      selectedItem: _selectedOrganization,
      clearButtonProps: const ClearButtonProps(isVisible: true),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Superior Organization",
          hintText: "Select Superior Organization",
          fillColor: CustomColors.textFieldFillColor,
          labelStyle: TextStyle(
            color: CustomColors.textFieldTextColor,
          ),
        ),
      ),
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            focusColor: CustomColors.buttonColor,
            labelText: 'Search Superior Organization',
            hintText: 'Type to Search Superior Organization...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(
                color: CustomColors.textFieldBorderColor,
                width: 2.0,
              ),
            ),
            fillColor: CustomColors.textFieldFillColor,
            filled: true,
            labelStyle: const TextStyle(
              color: CustomColors.textFieldTextColor,
            ),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(
              "${item.namebspr} | ${item.yassigto}",
              style: TextStyle(
                color: CustomColors.cardTextColor,
                fontSize: getFontSize(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRouteDropdown() {
    // Use a Set to store unique route names
    final Set<String> uniqueRouteNames = _routeOrganization.map((e) => e.namebsprRoute.toString()).toSet();

    // Filter the _routeOrganization list to include only unique route names
    final List<RouteOrganization> uniqueRoutes = _routeOrganization.where((route) {
      if (uniqueRouteNames.contains(route.namebsprRoute)) {
        uniqueRouteNames.remove(route.namebsprRoute);
        return true;
      }
      return false;
    }).toList();

    return DropdownSearch<RouteOrganization>(
      items: uniqueRoutes,
      itemAsString: (RouteOrganization u) => u.namebsprRoute.toString(),
      onChanged: (RouteOrganization? routeOrganization) {
        setState(() {
          _selectedRoute = routeOrganization;
        });
      },
      selectedItem: _selectedRoute,
      clearButtonProps: const ClearButtonProps(isVisible: true),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Select Route",
          hintText: "Select Route",
          fillColor: CustomColors.textFieldFillColor,
          labelStyle: TextStyle(
            color: CustomColors.textFieldTextColor,
          ),
        ),
      ),
      popupProps: PopupProps.bottomSheet(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            focusColor: CustomColors.buttonColor,
            labelText: 'Search Route',
            hintText: 'Type to Search Route...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(
                color: CustomColors.textFieldBorderColor,
                width: 2.0,
              ),
            ),
            fillColor: CustomColors.textFieldFillColor,
            filled: true,
            labelStyle: const TextStyle(
              color: CustomColors.textFieldTextColor,
            ),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(
              item.namebsprRoute.toString(),
              style: TextStyle(
                color: CustomColors.cardTextColor,
                fontSize: getFontSize(),
              ),
            ),
          );
        },
      ),
    );
  }

  showConfirmationPopup(BuildContext context, String selectedRouteId, String selectedOrganizationNummer) {
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
                            "Are you sure you want to update ${widget.organizationName}",
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
                          if (!_isButtonPressed) {
                            _isButtonPressed = true;
                            Navigator.of(context).pop();
                            if (selectedRouteId == null || selectedRouteId.isEmpty) {
                              _isUpdateRouteCompleted = true;
                            }
                            if (selectedOrganizationNummer.isEmpty || selectedOrganizationNummer == null) {
                              _isUpdateOrganizationCompleted = true;
                            }

                            if (selectedRouteId != null && selectedRouteId.isNotEmpty) {
                              setState(() {
                                _isUpdateRouteLoading = true;
                                _isUpdateRouteErrorShown = false;
                              });

                              _updateRouteBloc.updateRoute(selectedRouteId, widget.organizationNummer);
                            }
                            //if (selectedOrganizationNummer != null && selectedOrganizationNummer.isNotEmpty) {
                            setState(() {
                              _isUpdateOrganizationLoading = true;
                              _isUpdateOrganizationErrorShown = false;
                            });

                            _updateOrganizationBloc.updateSuperiorOrganization(
                                widget.organizationId, selectedOrganizationNummer);
                            //}
                          }
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

  void _checkForSuccess() {
    if (_isUpdateRouteCompleted && _isUpdateOrganizationCompleted && !_isSuccessMessageShown) {
      setState(() {
        _isSuccessMessageShown = true;
      });
      showSuccessAlertDialog(context, "${widget.organizationName} has been updated.", () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PendingApproveOrganizationListView(
                    userNummer: widget.userNummer,
                    isTeamMemberUi: widget.isTeamMemberUi,
                    username: widget.username,
                    userId: widget.userId,
                    loggedUserNummer: widget.loggedUserNummer,
                    userOrganizationNummer: widget.userOrganizationNummer,
                    designationNummer: widget.designationNummer,
                  )));
        });
      });
    }
  }
}
