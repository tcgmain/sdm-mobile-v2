import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/location_util.dart';
import 'package:sdm/widgets/map_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkVisitView extends StatefulWidget {
  final String organizationNummer;
  final String organizationName;
  final String organizationPhone1;
  final String organizationPhone2;
  final String organizationAddress1;
  final String organizationAddress2;
  final String organizationAddress3;
  final String organizationAddress4;
  final String organizationColour;
  final String organizationLongitude;
  final String organizationLatitude;
  final String organizationDistance;

  const MarkVisitView({
    Key? key,
    required this.organizationNummer,
    required this.organizationName,
    required this.organizationPhone1,
    required this.organizationPhone2,
    required this.organizationAddress1,
    required this.organizationAddress2,
    required this.organizationAddress3,
    required this.organizationAddress4,
    required this.organizationColour,
    required this.organizationLongitude,
    required this.organizationLatitude,
    required this.organizationDistance,
  }) : super(key: key);

  @override
  State<MarkVisitView> createState() => _MarkVisitViewState();
}

class _MarkVisitViewState extends State<MarkVisitView> {
  String _locationMessage = "";
  late double organizationLatitude = double.parse(widget.organizationLatitude); 
  late double organizationLongitude = double.parse(widget.organizationLongitude);
  late double organizationDistance = double.parse(widget.organizationDistance);
  bool _isWithinRadius = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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

    // setState(() {
    //   _locationMessage = "Latitude: $currentLat, Longitude: $currentLon";
    // });

    // Check if the current location is within the radius
    bool isWithin = LocationUtils.isWithinRadius(currentLat, currentLon, organizationLatitude, organizationLongitude, organizationDistance);

    if (isWithin) {
      setState(() {
        _isWithinRadius = isWithin;
        _locationMessage += "You are within the range of this organization.";
      });
    } else {
      setState(() {
        _locationMessage += "You are not within the ${widget.organizationDistance} range of this organization.";
      });
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
        title: 'Mark Visit',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        userName: '',
        isHomePage: false,
      ),
      body: SafeArea(
        child: BackgroundImage(
          child: ListView(
            children: [
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: CustomColors.textColor,
                          size: 35,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.organizationAddress1,
                                style: TextStyle(
                                  color: CustomColors.textColor,
                                  fontSize: getFontSize(),
                                ),
                              ),
                              Text(
                                widget.organizationAddress2,
                                style: TextStyle(
                                  color: CustomColors.textColor,
                                  fontSize: getFontSize(),
                                ),
                              ),
                              Text(
                                widget.organizationAddress3,
                                style: TextStyle(
                                  color: CustomColors.textColor,
                                  fontSize: getFontSize(),
                                ),
                              ),
                              Text(
                                widget.organizationAddress4,
                                style: TextStyle(
                                  color: CustomColors.textColor,
                                  fontSize: getFontSize(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [CustomColors.buttonColor3, CustomColors.buttonColor2],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showCallOptions(context);
                      },
                      icon: const Icon(Icons.call, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              MapWidget(
                latitude: double.parse(widget.organizationLatitude), 
                longitude: double.parse(widget.organizationLongitude),
              ),
              const SizedBox(height: 16),
              if (_isWithinRadius)
              CommonAppButton(
                buttonText: 'Mark Visit',
                onPressed: () {},
              ),
              Text(_locationMessage, style: TextStyle(color: Colors.red, fontSize: getFontSize()),textAlign:TextAlign.center)
            ],
            
          ),
        ),
      ),
    );
  }

  void _showCallOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.organizationPhone1.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(widget.organizationPhone1),
                    onTap: () {
                      _launchDialer(widget.organizationPhone1);
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (widget.organizationPhone2.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(widget.organizationPhone2),
                    onTap: () {
                      _launchDialer(widget.organizationPhone2);
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (widget.organizationPhone1.isEmpty && widget.organizationPhone2.isEmpty)
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
}
