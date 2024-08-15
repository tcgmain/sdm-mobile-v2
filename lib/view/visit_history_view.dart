import 'package:flutter/material.dart';
import 'package:sdm/blocs/visit_bloc.dart';
import 'package:sdm/models/visit.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:intl/intl.dart';

class VisitHistoryView extends StatefulWidget {
  final String userNummer;
  final String organizationNummer;
  final String organizationName;
  final bool isTeamMemberUi;

  const VisitHistoryView({
    super.key,
    required this.userNummer,
    required this.organizationNummer,
    required this.organizationName,
    required this.isTeamMemberUi,
  });

  @override
  State<VisitHistoryView> createState() => _VisitHistoryViewState();
}

class _VisitHistoryViewState extends State<VisitHistoryView> {
  late VisitBloc _visitBloc;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;

  @override
  void initState() {
    super.initState();
    _visitBloc = VisitBloc();
    _visitBloc.visit(widget.userNummer, widget.organizationNummer);
    setState(() {
      _isLoading = true;
    });
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
        child: Stack(
          children: [
            BackgroundImage(
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
                              if (snapshot.data!.data!.isNotEmpty) {
                                var visits = snapshot.data!.data!;

                                final dateFormat = DateFormat("dd/MM/yyyy");
                                final timeFormat = DateFormat("HH:mm");

                                visits.sort((a, b) {
                                  try {
                                    DateTime dateTimeA = DateTime(
                                      dateFormat.parse(a.yvdat.toString()).year,
                                      dateFormat.parse(a.yvdat.toString()).month,
                                      dateFormat.parse(a.yvdat.toString()).day,
                                      timeFormat.parse(a.yvtim.toString()).hour,
                                      timeFormat.parse(a.yvtim.toString()).minute,
                                    );
                                    DateTime dateTimeB = DateTime(
                                      dateFormat.parse(b.yvdat.toString()).year,
                                      dateFormat.parse(b.yvdat.toString()).month,
                                      dateFormat.parse(b.yvdat.toString()).day,
                                      timeFormat.parse(b.yvtim.toString()).hour,
                                      timeFormat.parse(b.yvtim.toString()).minute,
                                    );
                                    return dateTimeB.compareTo(dateTimeA);
                                  } catch (e) {
                                    return 0;
                                  }
                                });

                                var organizationName =
                                    visits.isNotEmpty ? visits[0].yorgNamebspr.toString() : "Unknown Organization";

                                return ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        organizationName,
                                        style: TextStyle(
                                            fontSize: getFontSizeExtraLarge(), color: CustomColors.textColorWhite),
                                      ),
                                    ),
                                    ...visits.map(
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
                                          title: Text('${visit.yvdat.toString()} at ${visit.yvtim.toString()}',
                                              style: TextStyle(color: CustomColors.textColor, fontSize: getFontSize())),
                                          subtitle: visit.yvroutNamebspr.toString() != "null"
                                              ? Text(visit.yvroutNamebspr.toString(),
                                                  style: TextStyle(
                                                      color: CustomColors.textColor, fontSize: getFontSizeSmall()))
                                              : Container(),
                                        ),
                                      ),
                                    ),
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
