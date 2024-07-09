import 'package:flutter/material.dart';
import 'package:sdm/blocs/visit_bloc.dart';
import 'package:sdm/models/organization.dart';
import 'package:sdm/models/visit.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;
import 'package:shared_preferences/shared_preferences.dart';

class VisitHistoryView extends StatefulWidget {
  final String userNummer;
  final String organizationNummer;

  const VisitHistoryView({
    Key? key,
    required this.userNummer,
    required this.organizationNummer,
  }) : super(key: key);

  @override
  State<VisitHistoryView> createState() => _VisitHistoryViewState();
}

class _VisitHistoryViewState extends State<VisitHistoryView> {
  late VisitBloc _visitBloc;

  @override
  void initState() {
    super.initState();
    _visitBloc = VisitBloc();
    _visitBloc.visit(widget.userNummer, widget.organizationNummer);
  }

  @override
  void dispose() {
    _visitBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Visit History",
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: BackgroundImage(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<ResponseList<Visit>>(
                  stream: _visitBloc.visitStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status!) {
                        case Status.LOADING:
                          return Loading(loadingMessage: snapshot.data!.message.toString());

                        case Status.COMPLETED:
                          print(snapshot.data!.data![0].yorgNamebspr);
                          //var organizationName = snapshot.data!.data![0].yorgNamebspr.toString();
                          // var routeName = snapshot.data!.data![0].yvroutNamebspr.toString();
                          // var date = snapshot.data!.data![0].yvdat.toString();
                          // var time = snapshot.data!.data![0].yvtim.toString();

                          var visits = snapshot.data!.data!;
                          var organizationName =
                              visits.isNotEmpty ? visits[0].yorgNamebspr.toString() : "Unknown Organization";

                          return ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  organizationName,
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: CustomColors.buttonColor2, // Heading color
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              ...visits
                                  .map(
                                    (visit) => Container(
                                      decoration: const BoxDecoration(
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
                                        //contentPadding: const EdgeInsets.all(16.0),
                                        title: Text('${visit.yvdat.toString()} at ${visit.yvtim.toString()}',
                                            style: TextStyle(color: CustomColors.textColor, fontSize: getFontSize())),
                                        subtitle: visit.yvroutNamebspr.toString() != "null"
                                            ? Text(visit.yvroutNamebspr.toString(),
                                                style: TextStyle(
                                                    color: CustomColors.textColor, fontSize: getFontSizeSmall()))
                                            : Container(),
                                        //tileColor: Colors.black12, // Adjust as needed
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          );

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
