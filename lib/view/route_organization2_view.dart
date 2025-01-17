import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/route_organization2_bloc.dart';
import 'package:sdm/models/route_organization2.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';

class RouteOrganization2View extends StatefulWidget {
  final String userNummer;
  final String username;
  final String routeNummer;
  final String routeName;
  final String date;
  final bool isTeamMemberUi;
  final String loggedUserNummer;
  final String designationNummer;
  final String userOrganizationNummer;

  const RouteOrganization2View({
    super.key,
    required this.userNummer,
    required this.username,
    required this.routeNummer,
    required this.routeName,
    required this.date,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
    required this.designationNummer,
    required this.userOrganizationNummer,
  });

  @override
  State<RouteOrganization2View> createState() => _RouteOrganization2ViewState();
}

class _RouteOrganization2ViewState extends State<RouteOrganization2View> {
  late RouteOrganization2Bloc _routeOrganization2Bloc;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _routeOrganization2Bloc = RouteOrganization2Bloc();
    _routeOrganization2Bloc.getRouteOrganization(widget.routeNummer, widget.date);
  }

  @override
  void dispose() {
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
        _routeOrganization2Bloc.getRouteOrganization(widget.routeNummer, widget.date);
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
                  Expanded(
                    child: StreamBuilder<ResponseList<RouteOrganization2>>(
                      stream: _routeOrganization2Bloc.routeOrganization2Stream,
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
                                return SlidableAutoCloseBehavior(
                                  closeWhenOpened: true,
                                  closeWhenTapped: false,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.data!.length,
                                    itemBuilder: (context, index) {
                                      final organizations = snapshot.data!.data![index];

                                      final organizationId = organizations.organizationId.toString();
                                      final organizationNummer = organizations.organizationNummer.toString();
                                      final organizationName = organizations.organizationNamebspr.toString();
                                      final organizationTypeId = organizations.organizationYcustypId.toString();
                                      final organizationPhone1 = organizations.organizationYphone1.toString();
                                      final organizationPhone2 = organizations.organizationYphone2.toString();
                                      final organizationWhatsapp = organizations.organizationYwhtapp.toString();
                                      final organizationAddress1 = organizations.organizationYaddressl1.toString();
                                      final organizationAddress2 = organizations.organizationYaddressl2.toString();
                                      final organizationColour = organizations.organizationYselcolourSuch.toString();
                                      final organizationLongitude = organizations.organizationYgpslon.toString();
                                      final organizationLatitude = organizations.organizationYgpslat.toString();
                                      final organizationDistance = organizations.organizationYvisdis.toString();
                                      final organizationMail = organizations.organizationYemail.toString();
                                      final ysuporgNummer = organizations.organizationYsuporgNummer.toString();
                                      final ysuporgNamebspr = organizations.organizationYsuporgNamebspr.toString();
                                      final organizationTypeNamebspr =
                                          organizations.organizationYcustypNamebspr.toString();
                                      final ownerName = organizations.organizationYowname.toString();
                                      final ownerBirthday = organizations.organizationYorgowndob.toString();
                                      final isMasonry = organizations.organizationYmasonry.toString();
                                      final isWaterproofing = organizations.organizationYswaterp.toString();
                                      final isFlooring = organizations.organizationYflooring.toString();
                                      final organizationAssignTo = organizations.organizationYassigtoSuch.toString();
                                      final nextVisitDueDate = organizations.nextvisitdue.toString();
                                      final yactiv = organizations.organizationYactiv.toString();

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
