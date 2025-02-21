// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/mark_visit_bloc.dart';
import 'package:sdm/blocs/town_bloc.dart';
import 'package:sdm/blocs/update_organization_location_bloc.dart';
import 'package:sdm/blocs/user_details_bloc.dart';
import 'package:sdm/models/mark_visit.dart';
import 'package:sdm/models/town.dart';
import 'package:sdm/models/update_organization.dart';
import 'package:sdm/models/user_details.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_stock_view.dart';
import 'package:sdm/view/visit_history_view.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/birthday_popup.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/icon_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/location_util.dart';
import 'package:sdm/widgets/map_widget.dart';
import 'package:sdm/widgets/success_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarkVisitView extends StatefulWidget {
  final String username;
  final String userNummer;
  final String routeNummer;
  final String organizationId;
  final String organizationNummer;
  final String organizationName;
  final String organizationTypeNamebspr;
  final String organizationPhone1;
  final String organizationPhone2;
  final String organizationWhatsapp;
  final String organizationAddress1;
  final String organizationAddress2;
  final String organizationYtownNamebspr;
  final String organizationColour;
  final String organizationLongitude;
  final String organizationLatitude;
  final String organizationDistance;
  final String organizationMail;
  final bool isTeamMemberUi;
  final String loggedUserNummer;
  final String ysuporgNummer;
  final String ysuporgNamebspr;
  final String ownerName;
  final String ownerBirthday;

  const MarkVisitView({
    super.key,
    required this.username,
    required this.userNummer,
    required this.routeNummer,
    required this.organizationId,
    required this.organizationNummer,
    required this.organizationName,
    required this.organizationPhone1,
    required this.organizationPhone2,
    required this.organizationWhatsapp,
    required this.organizationAddress1,
    required this.organizationAddress2,
    required this.organizationYtownNamebspr,
    required this.organizationColour,
    required this.organizationLongitude,
    required this.organizationLatitude,
    required this.organizationDistance,
    required this.organizationMail,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
    required this.ysuporgNummer,
    required this.ysuporgNamebspr,
    required this.organizationTypeNamebspr,
    required this.ownerName,
    required this.ownerBirthday,
  });

  @override
  State<MarkVisitView> createState() => _MarkVisitViewState();
}

class _MarkVisitViewState extends State<MarkVisitView> {
  String _locationMessage = "";
  bool _isSuccessMessageShown = false;
  bool _isErrorMessageShown = false;
  late TownBloc _townBloc;
  late double organizationLatitude = double.parse(widget.organizationLatitude);
  late double organizationLongitude = double.parse(widget.organizationLongitude);
  late double organizationDistance = double.parse(widget.organizationDistance);
  bool _isLoading = false;
  bool _showLocationUpdateButton = false;
  late String loggedUsername;

  bool _isWithinRadius = false;
  late MarkVisitBloc _markVisitBloc;
  late UpdateOrganizationLocationBloc _updateOrganizationLocationBloc;
  String currentLatitude = "";
  String currentLongitude = "";
  String currentTownNummer = "";
  String currentTownNamebspr = "";
  late UserDetailsBloc _userDetailsBloc;
  bool _isUserDetailsErrorMessageShown = false;
  bool _isLocationUpdatePermissionLoaded = false;
  bool _isTownLoading = false;
  Town? _nearbyTown;
  bool _isTownErrorShown = false;
  bool _isUpdateLocationCompleted = false;
  bool _isBirthdayMessageShown = false;

  @override
  void initState() {
    super.initState();
    _markVisitBloc = MarkVisitBloc();
    _updateOrganizationLocationBloc = UpdateOrganizationLocationBloc();
    _townBloc = TownBloc();
    _userDetailsBloc = UserDetailsBloc();
    getUserPermission();
    showBirthdayPopup();
  }

  @override
  void dispose() {
    _markVisitBloc.dispose();
    _updateOrganizationLocationBloc.dispose();
    _userDetailsBloc.dispose();
    _townBloc.dispose();
    super.dispose();
  }

  showBirthdayPopup(){
     DateTime currentDate = DateTime.now();
  String birthdayString = widget.ownerBirthday;

  try {
    DateTime userBirthDate = DateFormat("dd/MM/yyyy").parse(birthdayString);

    if (currentDate.day == userBirthDate.day && currentDate.month == userBirthDate.month) {
      if (!_isBirthdayMessageShown) {
        _isBirthdayMessageShown = true;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => BirthdayPopup(
              ownerName: widget.ownerName,
            ),
          );
        });
      }
    }
  } catch (e) {
    print("Error parsing or comparing birthday: $e");
  }
  }

  getUserPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedUsername = prefs.getString('username') ?? '';
    _userDetailsBloc.getUserDetails(loggedUsername);
  }

  getFullAddress() {
    String fullAddress = "";
    if (widget.organizationAddress1.isNotEmpty) fullAddress += widget.organizationAddress1;
    if (widget.organizationAddress2.isNotEmpty) fullAddress += ", ${widget.organizationAddress2}";
    if (widget.organizationAddress2.isNotEmpty) fullAddress += ", ${widget.organizationYtownNamebspr}";
    return fullAddress;
  }

  Map<String, double> calculateLatLngRangeForTown(double latitude, double longitude, double radiusKm) {
    const double earthRadiusKm = 6371.0; // Radius of the Earth in km

    // Convert latitude and longitude from degrees to radians
    double latRad = latitude * (pi / 180);

    // Calculate latitude bounds
    double latDiff = (radiusKm / earthRadiusKm) * (180 / pi);
    double minLat = latitude - latDiff;
    double maxLat = latitude + latDiff;

    // Calculate longitude bounds
    double lonDiff = (radiusKm / earthRadiusKm) * (180 / pi) / cos(latRad);
    double minLon = longitude - lonDiff;
    double maxLon = longitude + lonDiff;

    return {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLon': minLon,
      'maxLon': maxLon,
    };
  }

  Town? _getNearestTown(List<Town> towns, double currentLat, double currentLng) {
    if (towns.isEmpty) return null;

    Town? nearestTown;
    double shortestDistance = double.infinity;

    for (var town in towns) {
      double distance = _calculateDistance(
          currentLat, currentLng, double.parse(town.ylatitude.toString()), double.parse(town.ylongtitude.toString()));
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestTown = town;
      }
    }
    return nearestTown;
  }

  // Haversine Formula to calculate distance
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  Future<void> _getCurrentLocation(bool isLocUpdPermissionEnable) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double currentLat = position.latitude;
    double currentLon = position.longitude;

    currentLatitude = position.latitude.toString();
    currentLongitude = position.longitude.toString();

    bool isWithin = LocationUtils.isWithinRadius(
        currentLat, currentLon, organizationLatitude, organizationLongitude, organizationDistance);
    _isLoading = false;
    if (isWithin) {
      setState(() {
        _isWithinRadius = isWithin;
        _locationMessage += "You are within the range of this organization.";
      });
    } else {
      setState(() {
        _locationMessage += "You are not within the ${widget.organizationDistance} range of this organization.";

        // Check if the current date is within the specified range
        if (isLocUpdPermissionEnable == true) {
          _showLocationUpdateButton = true;
        } else {
          _showLocationUpdateButton = false;
        }
      });

      if (position.latitude < 0 || position.longitude < 0) {
        showErrorAlertDialogWithBack(context, "You are not permitted to mark visit in this location");
      } else {
        setState(() {
          _isTownLoading = true;
        });
        Map<String, double> geoTownMinRange = calculateLatLngRangeForTown(position.latitude, position.longitude, 4);
        _townBloc.getTown(geoTownMinRange['minLon'].toString(), geoTownMinRange['maxLon'].toString(),
            geoTownMinRange['minLat'].toString(), geoTownMinRange['maxLat'].toString());
      }
    }
  }

  Widget getTownResponse() {
    return StreamBuilder<ResponseList<Town>>(
      stream: _townBloc.townStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isTownLoading = true;
                });
              });

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isTownLoading = false;
                });
              });

              // Extract nearest town
              Town? nearestTown =
                  _getNearestTown(snapshot.data!.data!, double.parse(currentLatitude), double.parse(currentLongitude));
              if (nearestTown != null) {
                _nearbyTown = nearestTown;
                currentTownNummer = _nearbyTown!.nummer.toString();
                currentTownNamebspr = _nearbyTown!.namebspr.toString();
              }

              break;

            case Status.ERROR:
              if (!_isTownErrorShown) {
                _isTownErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isTownLoading = false;
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
        title: widget.isTeamMemberUi == true ? 'Mark Visit - ${widget.username} ' : 'Mark Visit',
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
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonAppButton(
                        buttonText: 'Visit History',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => VisitHistoryView(
                                      userNummer: widget.userNummer,
                                      organizationNummer: widget.organizationNummer,
                                      organizationName: widget.organizationName,
                                      isTeamMemberUi: widget.isTeamMemberUi,
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: getColor(widget.organizationColour),
                    radius: 40,
                    child: const Icon(
                      Icons.business,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.organizationName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CustomColors.textColor),
                  ),
                  Text(
                    widget.organizationTypeNamebspr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: getFontSize(), fontWeight: FontWeight.normal, color: CustomColors.textColor2),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.location_on,
                        color: CustomColors.textColor,
                        size: 25,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          getFullAddress(),
                          style: TextStyle(
                            color: CustomColors.textColor,
                            fontSize: getFontSize(),
                          ),
                        ),
                      ),
                      CustomIconButton(
                          tooltip: 'Navigate to google map',
                          icon: const Icon(Icons.directions),
                          onPressed: () {
                            openGoogleMaps(
                                double.parse(widget.organizationLatitude), double.parse(widget.organizationLongitude));
                          })
                    ],
                  ),
                  const SizedBox(height: 15),
                  widget.organizationPhone1.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.phone,
                              color: CustomColors.textColor,
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.organizationPhone1,
                              style: TextStyle(
                                color: CustomColors.textColor,
                                fontSize: getFontSize(),
                              ),
                            ),
                            widget.organizationPhone2.isNotEmpty
                                ? Text(
                                    " / ${widget.organizationPhone2}",
                                    style: TextStyle(
                                      color: CustomColors.textColor,
                                      fontSize: getFontSize(),
                                    ),
                                  )
                                : Container(),
                            const Spacer(),
                            CustomIconButton(
                                tooltip: 'Call',
                                icon: const Icon(Icons.call),
                                onPressed: () {
                                  _showCallOptions(context, widget.organizationPhone1, widget.organizationPhone2,
                                      widget.organizationWhatsapp);
                                })
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 15),
                  widget.organizationMail.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.mail,
                              color: CustomColors.textColor,
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.organizationMail,
                              style: TextStyle(
                                color: CustomColors.textColor,
                                fontSize: getFontSize(),
                              ),
                            ),
                            const Spacer(),
                            CustomIconButton(
                                tooltip: 'E-Mail',
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  _launchEmail(widget.organizationMail);
                                })
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  MapWidget(
                    latitude: double.parse(widget.organizationLatitude),
                    longitude: double.parse(widget.organizationLongitude),
                  ),
                  const SizedBox(height: 10),
                  if (_isWithinRadius)
                    CommonAppButton(
                      buttonText: 'Mark Visit',
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                          _isSuccessMessageShown = false;
                          _isErrorMessageShown = false;
                        });
                        _markVisitBloc.markVisit(widget.loggedUserNummer, widget.organizationNummer, widget.routeNummer,
                            getCurrentDate(), getCurrentTime());
                      },
                    ),
                  const SizedBox(height: 5),
                  Text(_locationMessage,
                      style: TextStyle(color: _isWithinRadius ? Colors.green : Colors.red, fontSize: getFontSize()),
                      textAlign: TextAlign.center),
                  if (_showLocationUpdateButton)
                    CommonAppButton(
                        buttonText: "Update Location",
                        onPressed: () {
                          showConfirmationPopup(context, currentLongitude, currentLatitude, currentTownNummer);
                        }),
                  if (_showLocationUpdateButton)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            _nearbyTown != null
                                ? "Now you are in ${_nearbyTown!.namebspr}"
                                : "No town found in your location",
                            style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                          )),
                    ),
                  markVisitResponse(),
                  updateLocationResponse(),
                  userDetailsResponse(),
                  getTownResponse()
                ],
              ),
            ),
            if (_isLoading || _isTownLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  void _showCallOptions(BuildContext context, String phone1, String phone2, String whatsapp) {
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
              if (whatsapp.isNotEmpty)
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.whatsapp),
                  title: Text(whatsapp),
                  onTap: () {
                    Navigator.pop(context);

                    _launchWhatsApp(whatsapp);
                  },
                ),
              if (widget.organizationPhone1.isEmpty &&
                  widget.organizationPhone2.isEmpty &&
                  widget.organizationWhatsapp.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No contact numbers available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

//Mark Visit response
  Widget markVisitResponse() {
    return StreamBuilder<Response<MarkVisit>>(
      stream: _markVisitBloc.markVisitStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = true;
                });
              });
              break;
            case Status.COMPLETED:
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = false;
                });
              });
              if (!_isSuccessMessageShown) {
                String visitNummer = snapshot.data!.data!.nummer.toString();
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  showSuccessAlertDialog(context, "Visit Successfully Marked", () {}).then((_) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => HomeStockView(
                                userNummer: widget.userNummer,
                                username: widget.username,
                                organizationId: widget.organizationId,
                                organizationNummer: widget.organizationNummer,
                                routeNummer: widget.routeNummer,
                                visitNummer: visitNummer,
                                loggedUserNummer: widget.loggedUserNummer,
                                isTeamMemberUi: widget.isTeamMemberUi,
                                organizationName: widget.organizationName,
                                ysuporgNummer: widget.ysuporgNummer,
                                ysuporgNamebspr: widget.ysuporgNamebspr,
                              )),
                    );
                  });
                });
                _isSuccessMessageShown = true;
              }
              break;
            case Status.ERROR:
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = false;
                });
              });
              if (!_isErrorMessageShown) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
                _isErrorMessageShown = true;
              }
              break;
          }
        }
        return Container();
      },
    );
  }

  //Update location response
  Widget updateLocationResponse() {
    return StreamBuilder<Response<UpdateOrganization>>(
      stream: _updateOrganizationLocationBloc.updateOrganizationLocationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = true;
                });
              });
              break;
            case Status.COMPLETED:
              if (!_isUpdateLocationCompleted) {
                _isUpdateLocationCompleted = true;

                String latitude = snapshot.data!.data!.ygpslat.toString();
                String longitude = snapshot.data!.data!.ygpslon.toString();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showSuccessAlertDialog(
                      context, "${widget.organizationName}'s location has been updated successfully.", () {
                    //WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MarkVisitView(
                                username: widget.username,
                                userNummer: widget.userNummer,
                                routeNummer: widget.routeNummer,
                                organizationId: widget.organizationId,
                                organizationNummer: widget.organizationNummer,
                                organizationName: widget.organizationName,
                                organizationPhone1: widget.organizationPhone1,
                                organizationPhone2: widget.organizationPhone2,
                                organizationWhatsapp: widget.organizationWhatsapp,
                                organizationAddress1: widget.organizationAddress1,
                                organizationAddress2: widget.organizationAddress2,
                                organizationYtownNamebspr: currentTownNamebspr,
                                organizationColour: widget.organizationColour,
                                organizationLongitude: longitude,
                                organizationLatitude: latitude,
                                organizationDistance: widget.organizationDistance,
                                organizationMail: widget.organizationMail,
                                isTeamMemberUi: widget.isTeamMemberUi,
                                loggedUserNummer: widget.loggedUserNummer,
                                ysuporgNummer: widget.ysuporgNummer,
                                ysuporgNamebspr: widget.ysuporgNamebspr,
                                organizationTypeNamebspr: widget.organizationTypeNamebspr,
                                ownerName: widget.ownerName,
                                ownerBirthday: widget.ownerBirthday,
                              )),
                    );
                    //});
                  });
                });
              }

              break;
            case Status.ERROR:
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = false;
                });
              });
              if (!_isErrorMessageShown) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
                _isErrorMessageShown = true;
              }
              break;
          }
        }
        return Container();
      },
    );
  }

  showConfirmationPopup(
      BuildContext context, String currentLongitude, String currentLatitude, String currentTownNummer) {
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
                            "Are you sure you want to update the location of ${widget.organizationName}? You must be at this location to proceed.",
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
                          Navigator.of(context).pop();
                          _updateOrganizationLocationBloc.updateOrganizationLocation(
                              widget.organizationId,
                              currentLongitude,
                              currentLatitude,
                              currentTownNummer,
                              loggedUsername,
                              getCurrentDate() + " " + getCurrentTime());
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

  Widget userDetailsResponse() {
    return StreamBuilder<ResponseList<UserDetails>>(
      stream: _userDetailsBloc.userDetailsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = true;
                });
              });
              break;

            case Status.COMPLETED:
              if (!_isLocationUpdatePermissionLoaded) {
                _isLocationUpdatePermissionLoaded = true;
                bool yenableupdatelocationpermission = snapshot.data!.data![0].yenableupdatelocationpermission ?? false;
                print(yenableupdatelocationpermission);
                _getCurrentLocation(yenableupdatelocationpermission);
              }

              break;
            case Status.ERROR:
              if (!_isUserDetailsErrorMessageShown) {
                _isUserDetailsErrorMessageShown = true;
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
}
