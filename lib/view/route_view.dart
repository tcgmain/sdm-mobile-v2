// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sdm/models/route.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/route_bloc.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/route_organization_view.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/date_picker_calender.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';

class RouteView extends StatefulWidget {


  final String userNummer;

  const RouteView({
    Key? key,
    required this.userNummer,
  }) : super(key: key);

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  late RouteBloc _routeBloc;
  DateTime _selectedDate = DateTime.now();
  late String username;

  @override
  void initState() {
    super.initState();
    _routeBloc = RouteBloc();
    _getRoutesForSelectedDate();
  }

  @override
  void dispose() {
    _routeBloc.dispose();
    super.dispose();
  }




  void _getRoutesForSelectedDate() {
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);
    print(formattedDate);
    _routeBloc.getRoute(formattedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePickerDialog(
          selectedDate: _selectedDate,
          onDateSelected: (DateTime date) {
            Navigator.of(context).pop(date);
          },
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          color1: [
            const Color.fromARGB(131, 255, 255, 255).withOpacity(0.4),
            const Color.fromARGB(90, 228, 168, 5).withOpacity(0.4),
          ],
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _getRoutesForSelectedDate(); // Fetch routes for the new selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Routes',
        onBackButtonPressed: () {},
        isHomePage: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getRoutesForSelectedDate();
        },
        backgroundColor: CustomColors.buttonColor,
        child: const Icon(
          Icons.refresh,
          color: CustomColors.buttonTextColor,
        ),
      ),
      body: SafeArea(
        child: BackgroundImage(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    style: TextStyle(fontSize: getFontSize(), color: Colors.white),
                  ),
                  CommonAppButton(
                    buttonText: 'Select Date',
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder<ResponseList<Routes>>(
                  stream: _routeBloc.routeStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return Loading(loadingMessage: snapshot.data!.message.toString());

                        case Status.COMPLETED:
                          int noOfRoutes = snapshot.data!.data!.length;
                          if (noOfRoutes == 0) {
                            return Center(
                              child: Text(
                                "No routes have been assigned for this date.",
                                style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) {
                                final route = snapshot.data!.data![index];
                                final routeNumb = route.yplrouteNummer?.toString() ?? 'Unnamed Route';
                                final routeName = route.yplrouteNamebspr?.toString() ?? 'Unnamed Route';
                                return Padding(
                                    padding: const EdgeInsets.only(bottom: 3, top: 3),
                                    child: ListButton(
                                      displayName: routeName,
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => RouteOrganizationView(
                                              userNummer: widget.userNummer,
                                                  routeNummer: routeNumb,
                                                )));
                                      },
                                    ));
                              },
                            );
                          }

                        case Status.ERROR:
                          if (snapshot.data!.message.toString() == "404") {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showErrorAlertDialog(context, "No routes haven't been assigned yet.");
                            });
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
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
      ),
    );
  }
}
