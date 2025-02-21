import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RouteOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String routeNummer;
  final String routeName;
  final bool isTeamMemberUi;
  final String loggedUserNummer;
  final String designationNummer;
  final String userOrganizationNummer;

  const RouteOrganizationView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.routeNummer,
    required this.routeName,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
    required this.designationNummer,
    required this.userOrganizationNummer,
  });

  @override
  State<RouteOrganizationView> createState() => _RouteOrganizationViewState();
}

class _RouteOrganizationViewState extends State<RouteOrganizationView> {
  late RouteOrganizationBloc _routeOrganizationBloc;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;
  String _sortBy = 'Priority'; // Default sort by Priority

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _routeOrganizationBloc = RouteOrganizationBloc();
    _routeOrganizationBloc.getRouteOrganization(widget.routeNummer);
  }

  @override
  void dispose() {
    _routeOrganizationBloc.dispose();
    super.dispose();
  }

  // Function to sort organizations based on the selected criteria
  List<RouteOrganization> _sortOrganizations(List<RouteOrganization> organizations) {
    if (_sortBy == 'Priority') {
      organizations.sort((a, b) {
        final dateFormat = DateFormat('dd/MM/yyyy');
        DateTime? dateA, dateB;

        // Parse date strings if they are not null or empty
        if (a.ynxtvisitdat != null && a.ynxtvisitdat!.isNotEmpty) {
          try {
            dateA = dateFormat.parse(a.ynxtvisitdat!);
          } catch (_) {
            dateA = null;
          }
        }
        if (b.ynxtvisitdat != null && b.ynxtvisitdat!.isNotEmpty) {
          try {
            dateB = dateFormat.parse(b.ynxtvisitdat!);
          } catch (_) {
            dateB = null;
          }
        }

        // Handle cases where one or both dates are null
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1; // `a` should come last if `dateA` is null
        if (dateB == null) return -1; // `b` should come last if `dateB` is null

        return dateA.compareTo(dateB);
      });
    } else if (_sortBy == 'Sequence') {
      organizations.sort((a, b) {
        final seqA = a.ysequno.toString();
        final seqB = b.ysequno.toString();
        return seqA.compareTo(seqB);
      });
    }
    return organizations;
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
                organizationWhatsapp: organizationWhatsapp,
                organizationAddress1: organizationAddress1,
                organizationAddress2: organizationAddress2,
                territoryNummer: territoryNummer,
                ownerName: ownerName,
                ownerBirthday: ownerBirthday,
                isMasonry: bool.parse(isMasonry),
                isWaterproofing: bool.parse(isWaterproofing),
                isFlooring: bool.parse(isFlooring),
                userOrganizationNummer: widget.userOrganizationNummer,
                designationNummer: widget.designationNummer,
                organizationColor: organizationColor,
                superiorOrganizationNummer: superiorOrganizationNummer,
              )),
    );

    if (result == true) {
      setState(() {
        _routeOrganizationBloc.getRouteOrganization(widget.routeNummer);
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.isTeamMemberUi == true ? 'Organizations - ${widget.username} ' : 'Organizations',
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
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.routeName,
                        style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  // Add DropdownButton for sorting
                  Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(8),
                      iconEnabledColor: CustomColors.textColor,
                      dropdownColor: CustomColors.dropDownColor,
                      value: _sortBy,
                      items: const [
                        DropdownMenuItem(value: 'Priority', child: Text('Sort by Priority')),
                        DropdownMenuItem(value: 'Sequence', child: Text('Sort by Sequence')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                        });
                      },
                      isExpanded: false,
                      underline: Container(),
                      style: const TextStyle(color: CustomColors.textColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder<ResponseList<RouteOrganization>>(
                      stream: _routeOrganizationBloc.routeOrganizationStream,
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

                              int noOfOrganizations = snapshot.data!.data!.length;
                              if (noOfOrganizations == 0) {
                                return Center(
                                  child: Text(
                                    "No organizations have been assigned for this route.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                  ),
                                );
                              } else {
                                // Sort organizations before displaying
                                List<RouteOrganization> sortedOrganizations = _sortOrganizations(snapshot.data!.data!);

                                return SlidableAutoCloseBehavior(
                                  closeWhenOpened: true,
                                  closeWhenTapped: false,
                                  child: ListView.builder(
                                    itemCount: sortedOrganizations.length,
                                    itemBuilder: (context, index) {
                                      final organizations = sortedOrganizations[index];
                                      final organizationId = organizations.ysdmorgId.toString();
                                      final organizationNummer = organizations.orgnummer.toString();
                                      final organizationName = organizations.namebspr?.toString() ?? 'Unnamed Route';
                                      final organizationTypeId = organizations.ycustypId?.toString() ?? 'Unnamed Route';
                                      final organizationPhone1 = organizations.yphone1?.toString() ?? 'Unnamed Route';
                                      final organizationPhone2 = organizations.yphone2?.toString() ?? 'Unnamed Route';
                                      final organizationWhatsapp = organizations.ywhtapp?.toString() ?? 'Unnamed Route';
                                      final organizationAddress1 =
                                          organizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                      final organizationAddress2 =
                                          organizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                           final organizationTownNamebspr =
                                          organizations.townNamebspr?.toString() ?? 'Unnamed Route';
                                      final organizationColour = organizations.colour?.toString() ?? 'Unnamed Route';
                                      final organizationLongitude =
                                          organizations.longitude?.toString() ?? 'Unnamed Route';
                                      final organizationLatitude =
                                          organizations.latitude?.toString() ?? 'Unnamed Route';
                                      final organizationDistance =
                                          organizations.distance?.toString() ?? 'Unnamed Route';
                                      final organizationMail = organizations.yemail?.toString() ?? 'Unnamed Route';
                                      final ysuporgNummer = organizations.ysuporgNummer?.toString() ?? 'Unnamed Route';
                                      final ysuporgNamebspr =
                                          organizations.ysuporgNamebspr?.toString() ?? 'Unnamed Route';
                                      final organizationTypeNamebspr =
                                          organizations.ycustypNamebspr?.toString() ?? 'Unnamed Route';
                                      final ownerName = organizations.yowname?.toString() ?? 'Unnamed Route';
                                      final ownerBirthday = organizations.yorgowndob?.toString() ?? 'Unnamed Route';
                                      final isMasonry = organizations.ymasonry?.toString() ?? 'Unnamed Route';
                                      final isWaterproofing = organizations.ywaterpr?.toString() ?? 'Unnamed Route';
                                      final isFlooring = organizations.yflooring?.toString() ?? 'Unnamed Route';
                                      final organizationAssignTo =
                                          organizations.yassigtoSuch?.toString() ?? 'Unnamed Route';
                                      final nextVisitDueDate = organizations.ynxtvisitdat?.toString() ?? '';
                                      final yactiv = organizations.yactiv.toString();

                                      // Parse the nextVisitDueDate to DateTime
                                      DateTime? nextVisitDate;
                                      if (nextVisitDueDate != '') {
                                        nextVisitDate = DateFormat('dd/MM/yyyy').parse(nextVisitDueDate);
                                      }

                                      // Check if nextVisitDueDate is in the past
                                      bool isPastDueDate =
                                          nextVisitDate != null && nextVisitDate.isBefore(DateTime.now());

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
                                                          "territoryNummer",
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
                                              child: InkWell(
                                                splashColor: CustomColors.buttonColor,
                                                onTap: () {
                                                  // Add your onPressed functionality here

                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => HomeOrganizationView(
                                                            userNummer: widget.userNummer,
                                                            username: widget.username,
                                                            routeNummer: widget.routeNummer,
                                                            organizationId: organizationId,
                                                            organizationNummer: organizationNummer,
                                                            organizationName: organizationName,
                                                            organizationPhone1: organizationPhone1,
                                                            organizationPhone2: organizationPhone2,
                                                            organizationWhatsapp: organizationWhatsapp,
                                                            organizationAddress1: organizationAddress1,
                                                            organizationYtownNamebspr: organizationTownNamebspr,
                                                            territoryNummer: "territoryNummer",
                                                            organizationAddress2: organizationAddress2,
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
                                                            userOrganizationNummer: widget.userOrganizationNummer,
                                                            ownerName: ownerName,
                                                            ownerBirthday: ownerBirthday,
                                                          )));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                    shape: BoxShape.rectangle,
                                                    gradient: LinearGradient(
                                                      colors: <Color>[
                                                        Colors.black,
                                                        (isPastDueDate) ? CustomColors.buttonColor3 : Colors.black26,
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                  child: ListTile(
                                                    leading: Stack(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: getColor(organizationColour),
                                                          radius: 20,
                                                          child: const Icon(
                                                            Icons.business,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 0,
                                                          bottom: 0,
                                                          child: (yactiv == "true")
                                                              ? const Icon(Icons.circle, color: Colors.green, size: 12)
                                                              : const Icon(Icons.circle, color: Colors.red, size: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    title: Text(organizationName,
                                                        style: const TextStyle(color: CustomColors.textColor)),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Assigned To: $organizationAssignTo',
                                                          style: TextStyle(
                                                            fontSize: getFontSize(),
                                                            color: CustomColors.textColor2,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Next Visit: $nextVisitDueDate',
                                                          style: TextStyle(
                                                            fontSize: getFontSizeSmall(),
                                                            color: CustomColors.textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // trailing: (yactiv == "true")
                                                    //     ? const Icon(Icons.check_circle, color: Colors.green)
                                                    //     : const Icon(
                                                    //         Icons.cancel,
                                                    //         color: Colors.red,
                                                    //       ),
                                                  ),
                                                ),
                                              )));
                                    },
                                  ),
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
