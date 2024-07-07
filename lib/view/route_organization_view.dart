import 'package:flutter/material.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';

class RouteOrganizationView extends StatefulWidget {
  final String routeNummer;

  const RouteOrganizationView({
    Key? key,
    required this.routeNummer,
  }) : super(key: key);

  @override
  State<RouteOrganizationView> createState() => _RouteOrganizationViewState();
}

class _RouteOrganizationViewState extends State<RouteOrganizationView> {
  late RouteOrganizationBloc _routeOrganizationBloc;
  

  @override
  void initState() {
    super.initState();
    _routeOrganizationBloc = RouteOrganizationBloc();
    _routeOrganizationBloc.getRouteOrganization(widget.routeNummer);
  }

  @override
  void dispose() {
    _routeOrganizationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Organizations',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        userName: '',
        isHomePage: false,
      ),
      body: SafeArea(
        child: BackgroundImage(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<ResponseList<RouteOrganization>>(
                  stream: _routeOrganizationBloc.routeOrganizationStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return Loading(loadingMessage: snapshot.data!.message.toString());

                        case Status.COMPLETED:
                          int noOfOrganizations = snapshot.data!.data!.length;
                          if (noOfOrganizations == 0) {
                            return Center(
                              child: Text(
                                "No organizations have been assigned for this route.",
                                style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) {
                                final organizations = snapshot.data!.data![index];
                                final organizationNummer = organizations.orgnummer.toString() ?? 'Unnamed Route';
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
                                    ));
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
