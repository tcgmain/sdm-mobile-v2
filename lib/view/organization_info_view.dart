// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sdm/blocs/organization_info_bloc.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/icon_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class OrganizationInfoView extends StatefulWidget {
  final String username;
  final String userNummer;
  final String organizationNummer;
  final bool isTeamMemberUi;
  final String loggedUserNummer;

  const OrganizationInfoView({
    super.key,
    required this.username,
    required this.userNummer,
    required this.organizationNummer,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
  });

  @override
  State<OrganizationInfoView> createState() => _OrganizationInfoViewState();
}

class _OrganizationInfoViewState extends State<OrganizationInfoView> {
  late double organizationLatitude;
  late double organizationLongitude;
  late double organizationDistance;
  String routeName = "Not Assigned";
  String superiorOrganization = "Not Assigned";
  bool _isLoading = false;
  bool _isRouteLoading = false;
  late OrganizationInfoBloc _organizationInfoBloc;
  late RouteOrganizationBloc _routeOrganizationBloc;
  bool _isErrorMessageShown = false;
  bool _isRouteErrorMessageShown = false;

  @override
  void initState() {
    super.initState();
    _organizationInfoBloc = OrganizationInfoBloc();
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

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
    );

    if (await canLaunch(whatsappUri.toString())) {
      await launch(whatsappUri.toString());
    } else {
      throw 'Could not launch $whatsappUri';
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
        title: 'Organization Info',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
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
                        //final id = organization.id.toString();
                        //final such = organization.such.toString();
                        final yassigto = organization.yassigto.toString();
                        //final yassigtoNummer = organization.yassigtoNummer.toString();
                        //final yassigtoNamebspr = organization.yassigtoNamebspr.toString();
                        final namebspr = organization.namebspr.toString();
                        //final orgnummer = organization.orgnummer.toString();
                        final yphone1 = organization.yphone1.toString();
                        final yphone2 = organization.yphone2.toString();
                        final ywhtapp = organization.ywhtapp.toString();
                        final yaddressl1 = organization.yaddressl1.toString();
                        final yaddressl2 = organization.yaddressl2.toString();
                        final yaddressl3 = organization.yaddressl3.toString();
                        final yaddressl4 = organization.yaddressl4.toString();
                        final colour = organization.colour.toString();
                        final longitude = organization.longitude.toString();
                        final latitude = organization.latitude.toString();
                        //final distance = organization.distance.toString();
                        final yemail = organization.yemail.toString();
                        final yactiv = organization.yactiv.toString();
                        final ylev = organization.ylev.toString();
                        final ysuporgNummer = organization.ysuporgNummer.toString();
                        final ysuporgNamebspr = organization.ysuporgNamebspr.toString();
                        //final ycustypSuch = organization.ycustypSuch.toString();
                        final ycustypNamebspr = organization.ycustypNamebspr.toString();
                        final yscemet = organization.yscemet.toString();
                        final ystilea = organization.ystilea.toString();
                        final yswaterp = organization.yswaterp.toString();
                        final ysanmet = organization.ysanmet.toString();
                        final yspaint = organization.yspaint.toString();

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
                                    if (ysuporgNamebspr.isNotEmpty)
                                      Row(
                                        children: [
                                          const Icon(Icons.supervised_user_circle, color: CustomColors.textColor),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "Superior: $ysuporgNamebspr",
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
                                    if (ysuporgNamebspr.isNotEmpty)
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
                                                _showCallOptions(context, yphone1, yphone2, ywhtapp);
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
                            //Divider(),
                            const SizedBox(height: 10),
                            // MapWidget(
                            //   latitude: double.parse(latitude),
                            //   longitude: double.parse(longitude),
                            // ),
                          ],
                        );

                      case Status.ERROR:
                        if (!_isErrorMessageShown) {
                          _isErrorMessageShown = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _isLoading = true;
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
            if (_isLoading || _isRouteLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  void _showCallOptions(BuildContext context, phone1, phone2, ywhtapp) {
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
              if (ywhtapp.isNotEmpty)
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.whatsapp),
                  title: Text(ywhtapp),
                  onTap: () {
                    _launchWhatsApp(ywhtapp);
                    Navigator.pop(context);

                    
                  },
                ),
              if (phone1.isEmpty && phone2.isEmpty && ywhtapp.isEmpty)
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
