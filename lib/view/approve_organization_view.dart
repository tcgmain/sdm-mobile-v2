// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:sdm/blocs/approve_organization_bloc.dart';
import 'package:sdm/blocs/organization_info_bloc.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/approve_organization_list_view.dart';
import 'package:sdm/view/organization_info_view.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/icon_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/success_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ApproveOrganizationView extends StatefulWidget {
  final String userId;
  final String username;
  final String userNummer;
  final String organizationNummer;
  final String userOrganizationNummer;
  final bool isTeamMemberUi;
  final String designationNummer;
  final String loggedUserNummer;

  const ApproveOrganizationView({
    super.key,
    required this.userId,
    required this.username,
    required this.userNummer,
    required this.organizationNummer,
    required this.userOrganizationNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
    required this.loggedUserNummer,
  });

  @override
  State<ApproveOrganizationView> createState() => _ApproveOrganizationViewState();
}

class _ApproveOrganizationViewState extends State<ApproveOrganizationView> {
  late double organizationLatitude;
  late double organizationLongitude;
  late double organizationDistance;
  String routeName = "Not Assigned";
  String superiorOrganization = "Not Assigned";
  bool _isLoading = false;
  bool _isRouteLoading = false;
  bool _isApproveLoading = false;
  bool _isSuccessMessageShown = false;
  late OrganizationInfoBloc _organizationInfoBloc;
  late ApproveOrganizationBloc _approveOrganizationBloc;
  late RouteOrganizationBloc _routeOrganizationBloc;
  bool _isErrorMessageShown = false;
  bool _isRouteErrorMessageShown = false;
  late String organizationNameMessage;
  late String superiorOrganizationNummer;
  late String organizationNummer;
  late String organizationName;
  late String organizationId;

  @override
  void initState() {
    super.initState();
    _organizationInfoBloc = OrganizationInfoBloc();
    _approveOrganizationBloc = ApproveOrganizationBloc();
    _routeOrganizationBloc = RouteOrganizationBloc();
    _organizationInfoBloc.getOrganizationInfo(widget.organizationNummer);
    _routeOrganizationBloc.getRouteOrganizationByOrg(widget.organizationNummer);
    setState(() {
      _isLoading = true;
      _isRouteLoading = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _approveOrganizationBloc.dispose();
    _organizationInfoBloc.dispose();
    _routeOrganizationBloc.dispose();
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Subject&body=Body',
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email clients installed or could not launch email app')),
      );
    }
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Approve Organization',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            approveOrganizationResponse(),
            routeResponse(),
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: StreamBuilder<ResponseList<Organization>>(
                stream: _organizationInfoBloc.organizationInfoStream,
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
                        final organization = snapshot.data!.data![0];
                        final id = organization.id.toString();
                        //final such = organization.such.toString();
                        final yassigto = organization.yassigto.toString();
                        //final yassigtoNummer = organization.yassigtoNummer.toString();
                        //final yassigtoNamebspr = organization.yassigtoNamebspr.toString();
                        final namebspr = organization.namebspr.toString();
                        final orgnummer = organization.orgnummer.toString();
                        final yphone1 = organization.yphone1.toString();
                        final yphone2 = organization.yphone2.toString();
                        final yaddressl1 = organization.yaddressl1.toString();
                        final yaddressl2 = organization.yaddressl2.toString();
                        final yaddressl3 = organization.yaddressl3.toString();
                        final yaddressl4 = organization.yaddressl4.toString();
                        final colour = organization.colour.toString();
                        final longitude = organization.longitude.toString();
                        final latitude = organization.latitude.toString();
                        final yemail = organization.yemail.toString();
                        final yactiv = organization.yactiv.toString();
                        final ylev = organization.ylev.toString();
                        final ysuporgNummer = organization.ysuporgNummer.toString();
                        final ysuporgNamebspr = organization.ysuporgNamebspr.toString();
                        final ycustypNamebspr = organization.ycustypNamebspr.toString();

                        if (ysuporgNamebspr != "" || ysuporgNamebspr.isNotEmpty) superiorOrganization = ysuporgNamebspr;

                        organizationNameMessage = namebspr;
                        superiorOrganizationNummer = ysuporgNummer;
                        organizationNummer = orgnummer;
                        organizationName = namebspr;
                        organizationId = id;

                        String fullAddress = "";
                        if (yaddressl1.isNotEmpty) fullAddress += yaddressl1;
                        if (yaddressl2.isNotEmpty) fullAddress += ", $yaddressl2";
                        if (yaddressl3.isNotEmpty) fullAddress += ", $yaddressl3";
                        if (yaddressl4.isNotEmpty) fullAddress += ", $yaddressl4";

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          children: [
                            const SizedBox(height: 10),
                            CircleAvatar(
                              backgroundColor: getColor(colour),
                              radius: 40,
                              child: const Icon(
                                Icons.business,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              namebspr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold, color: CustomColors.textColor),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: CustomColors.textColorGrey,
                            ),
                            Card(
                              color: CustomColors.cardBackgroundColor1,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.business_center, color: CustomColors.textColor),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Type: $ycustypNamebspr",
                                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: CustomColors.textColorGrey,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.bar_chart, color: CustomColors.textColor),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Level: $ylev",
                                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: CustomColors.textColorGrey,
                                    ),

                                    Row(
                                      children: [
                                        const Icon(Icons.supervised_user_circle, color: CustomColors.textColor),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Superior: $superiorOrganization",
                                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                          ),
                                        ),
                                        IconButton(
                                            focusColor: CustomColors.buttonColor2,
                                            color: CustomColors.textColor,
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => OrganizationInfoView(
                                                        username: widget.username,
                                                        userNummer: widget.userNummer,
                                                        organizationNummer: ysuporgNummer,
                                                        isTeamMemberUi: widget.isTeamMemberUi,
                                                        loggedUserNummer: widget.loggedUserNummer,
                                                      )));
                                            },
                                            icon: const Icon(Icons.open_in_new))
                                      ],
                                    ),

                                    const Divider(
                                      color: CustomColors.textColorGrey,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.group, color: CustomColors.textColor),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Assigned To: $yassigto",
                                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: CustomColors.textColorGrey,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.route, color: CustomColors.textColor),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Assigned Route: $routeName",
                                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: CustomColors.textColorGrey,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: CustomColors.textColor),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Status: ${yactiv == "true" ? "Active" : "Inactive"}",
                                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                          ),
                                        ),
                                        Icon(Icons.circle, color: yactiv == "true" ? Colors.green : Colors.red)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            fullAddress.isNotEmpty
                                ? Card(
                                    color: CustomColors.cardBackgroundColor1,
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.location_on, color: CustomColors.textColor),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              fullAddress,
                                              style: TextStyle(color: CustomColors.textColor, fontSize: getFontSize()),
                                            ),
                                          ),
                                          CustomIconButton(
                                              tooltip: 'Navigate to google map',
                                              icon: const Icon(Icons.directions),
                                              onPressed: () {
                                                openGoogleMaps(double.parse(latitude), double.parse(longitude));
                                              })
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 10),
                            yphone1.isNotEmpty
                                ? Card(
                                    color: CustomColors.cardBackgroundColor1,
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.phone, color: CustomColors.textColor),
                                          const SizedBox(width: 10),
                                          Text(
                                            yphone1,
                                            style: TextStyle(color: CustomColors.textColor, fontSize: getFontSize()),
                                          ),
                                          yphone2.isNotEmpty
                                              ? Text(
                                                  " / $yphone2",
                                                  style:
                                                      TextStyle(color: CustomColors.textColor, fontSize: getFontSize()),
                                                )
                                              : Container(),
                                          const Spacer(),
                                          CustomIconButton(
                                              tooltip: 'Call',
                                              icon: const Icon(Icons.call),
                                              onPressed: () {
                                                _showCallOptions(context, yphone1, yphone2);
                                              })
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 10),
                            yemail.isNotEmpty
                                ? Card(
                                    color: CustomColors.cardBackgroundColor1,
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.email, color: CustomColors.textColor),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              yemail,
                                              style: TextStyle(color: CustomColors.textColor, fontSize: getFontSize()),
                                            ),
                                          ),
                                          CustomIconButton(
                                              tooltip: 'E-Mail',
                                              icon: const Icon(Icons.send),
                                              onPressed: () {
                                                _launchEmail(yemail);
                                              })
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 10),
                            yemail.isNotEmpty
                                ? Card(
                                    color: CustomColors.cardBackgroundColor1,
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.route, color: CustomColors.textColor),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              yemail,
                                              style: TextStyle(color: CustomColors.textColor, fontSize: getFontSize()),
                                            ),
                                          ),
                                          // CustomIconButton(
                                          //     tooltip: 'Assigned Route',
                                          //     icon: const Icon(Icons.send),
                                          //     onPressed: () {
                                          //       _launchEmail(yemail);
                                          //     })
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 20),
                            Center(
                              child: CommonAppButton(
                                buttonText: 'Approve',
                                onPressed: () {
                                  setState(() {
                                    showConfirmationPopup(context, id, namebspr, yassigto);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );

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
            ),
            if (_isLoading || _isApproveLoading || _isRouteLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  void _showCallOptions(BuildContext context, phone1, phone2) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (phone1.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(phone1),
                    onTap: () {
                      _launchDialer(phone1);
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (phone2.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(phone2),
                    onTap: () {
                      _launchDialer(phone2);
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (phone1.isEmpty && phone2.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No contact numbers available',
                    style: TextStyle(fontSize: getFontSize(), fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  showConfirmationPopup(
      BuildContext context, String organizationId, String organizationName, String organizationAssignTo) {
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
                            "Are you sure you want to approve $organizationName that has been assigned to $organizationAssignTo?",
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _isApproveLoading = true;
                              _isSuccessMessageShown = false;
                              _isErrorMessageShown = false;
                            });
                          });
                          Navigator.of(context).pop();

                          _approveOrganizationBloc.approveOrganization(organizationId, widget.username);
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

  Widget approveOrganizationResponse() {
    return StreamBuilder<Response<UpdateOrganization>>(
      stream: _approveOrganizationBloc.approveOrganizationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isApproveLoading = true;
                });
              });

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isApproveLoading = false;
                });
              });
              if (!_isSuccessMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSuccessAlertDialog(context, "$organizationNameMessage has been approved.", () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ApproveOrganizationListView(
                              userNummer: widget.userNummer,
                              isTeamMemberUi: widget.isTeamMemberUi,
                              username: widget.username,
                              userId: widget.userId,
                              loggedUserNummer: widget.loggedUserNummer,
                              userOrganizationNummer: widget.userOrganizationNummer,
                              designationNummer: widget.designationNummer,
                            )));
                  });
                  setState(() {
                    _isSuccessMessageShown = true;
                  });
                });
              }
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isApproveLoading = false;
                });
              });
              if (!_isErrorMessageShown) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isErrorMessageShown = true;
                  });
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isRouteLoading = false;
                });
              });
              if (snapshot.data!.data!.isNotEmpty) {
                routeName = snapshot.data!.data![0].namebsprRoute.toString();
              }
              break;
            case Status.ERROR:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isRouteErrorMessageShown) {
                  _isRouteErrorMessageShown = true;
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                  setState(() {
                    _isRouteLoading = false;
                  });
                }
              });
              break;
          }
        }
        return Container();
      },
    );
  }
}
