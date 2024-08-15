import 'package:flutter/material.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
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

  Future<void> _navigateToUpdateOrganizationView(
      organizationId,
      organizationNummer,
      organizationName,
      organizationTypeId,
      organizationMail,
      organizationPhone1,
      organizationPhone2,
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
                designationNummer: widget.designationNummer,
                organizationColor: organizationColor,
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
                                return SlidableAutoCloseBehavior(
                                  closeWhenOpened: true,
                                  closeWhenTapped: false,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.data!.length,
                                    itemBuilder: (context, index) {
                                      final organizations = snapshot.data!.data![index];
                                      final organizationId = organizations.ysdmorgId.toString();
                                      final organizationNummer = organizations.orgnummer.toString();
                                      final organizationName = organizations.namebspr?.toString() ?? 'Unnamed Route';
                                      final organizationTypeId = organizations.ycustypId?.toString() ?? 'Unnamed Route';
                                      final organizationPhone1 = organizations.yphone1?.toString() ?? 'Unnamed Route';
                                      final organizationPhone2 = organizations.yphone2?.toString() ?? 'Unnamed Route';
                                      final organizationAddress1 =
                                          organizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                      final organizationAddress2 =
                                          organizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                      final organizationAddress3 =
                                          organizations.yaddressl3?.toString() ?? 'Unnamed Route';
                                      final organizationTown = organizations.yaddressl4?.toString() ?? 'Unnamed Route';
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
                                      final isMasonry = organizations.ymasonry?.toString() ?? 'Unnamed Route';
                                      final isWaterproofing = organizations.ywaterpr?.toString() ?? 'Unnamed Route';
                                      final isFlooring = organizations.yflooring?.toString() ?? 'Unnamed Route';
                                      final organizationAssignTo =
                                          organizations.yassigtoSuch?.toString() ?? 'Unnamed Route';

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
                                                    print("Pressed");

                                                    _navigateToUpdateOrganizationView(
                                                        organizationId,
                                                        organizationNummer,
                                                        organizationName,
                                                        organizationTypeId,
                                                        organizationMail,
                                                        organizationPhone1,
                                                        organizationPhone2,
                                                        organizationAddress1,
                                                        organizationAddress2,
                                                        organizationAddress3,
                                                        organizationTown,
                                                        ownerName,
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
                                                print('Container pressed!');

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
                                                          organizationAddress1: organizationAddress1,
                                                          organizationAddress2: organizationAddress2,
                                                          organizationAddress3: organizationAddress3,
                                                          organizationTown: organizationTown,
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
                                                      style: const TextStyle(color: CustomColors.textColor)),
                                                  subtitle: Text(
                                                    organizationAssignTo,
                                                    style: const TextStyle(color: CustomColors.textColor2),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // child: ListButton(
                                            //   displayName: organizationName,
                                            //   onPressed: () {
                                            //     Navigator.of(context).push(MaterialPageRoute(
                                            //         builder: (context) => HomeOrganizationView(
                                            //               userNummer: widget.userNummer,
                                            //               username: widget.username,
                                            //               routeNummer: widget.routeNummer,
                                            //               organizationId: organizationId,
                                            //               organizationNummer: organizationNummer,
                                            //               organizationName: organizationName,
                                            //               organizationPhone1: organizationPhone1,
                                            //               organizationPhone2: organizationPhone2,
                                            //               organizationAddress1: organizationAddress1,
                                            //               organizationAddress2: organizationAddress2,
                                            //               organizationAddress3: organizationAddress3,
                                            //               organizationTown: organizationTown,
                                            //               organizationColour: organizationColour,
                                            //               organizationLongitude: organizationLongitude,
                                            //               organizationLatitude: organizationLatitude,
                                            //               organizationDistance: organizationDistance,
                                            //               organizationMail: organizationMail,
                                            //               isTeamMemberUi: widget.isTeamMemberUi,
                                            //               loggedUserNummer: widget.loggedUserNummer,
                                            //               ysuporgNummer: ysuporgNummer,
                                            //               ysuporgNamebspr: ysuporgNamebspr,
                                            //               designationNummer: widget.designationNummer,
                                            //               organizationTypeNamebspr: organizationTypeNamebspr,
                                            //               userOrganizationNummer: widget.userOrganizationNummer,
                                            //             )));
                                            //   },
                                            // ),
                                          ));
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
