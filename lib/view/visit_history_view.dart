import 'package:flutter/material.dart';
import 'package:sdm/blocs/visit_bloc.dart';
import 'package:sdm/models/visit.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';

class VisitHistoryView extends StatefulWidget {
  final String userNummer;
  final String organizationNummer;
  final String organizationName;
  final bool isTeamMemberUi;

  const VisitHistoryView({
    Key? key,
    required this.userNummer,
    required this.organizationNummer,
    required this.organizationName,
    required this.isTeamMemberUi,
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
          isTeamMemberUi: widget.isTeamMemberUi,
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
                          if (snapshot.data!.data!.isNotEmpty) {
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
                          } else {
                            return Center(
                              child: Text(
                                "No visit history found from ${widget.organizationName}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                              ),
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
