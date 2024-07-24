import 'package:flutter/material.dart';
import 'package:sdm/blocs/team_bloc.dart';
import 'package:sdm/models/team.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/text_field.dart' as textField;

class TeamView extends StatefulWidget {
  final String userNummer;
  final String username;
  final bool isTeamMemberUi;

  const TeamView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.isTeamMemberUi,
  });

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  late TeamBloc _teamBloc;
  final TextEditingController _searchController = TextEditingController();
  List<Team>? _filteredTeam;
  List<Team>? _allTeam;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _teamBloc = TeamBloc();
    _teamBloc.getTeamDetails(widget.userNummer);
    _searchController.addListener(_onSearchChanged);
     setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _teamBloc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredTeam = _allTeam
          ?.where((team) => team.ypasdefNamebspr!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.isTeamMemberUi == true ? 'Team - ${widget.username}' : 'My Team',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: widget.isTeamMemberUi == false ? true : false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Column(
                children: [
                  textField.TextField(
                      controller: _searchController,
                      obscureText: false,
                      inputType: 'none',
                      isRequired: true,
                      fillColor: CustomColors.textFieldFillColor,
                      filled: true,
                      labelText: "Type to search team member...",
                      onChangedFunction: () {}),
                  Expanded(
                    child: StreamBuilder<ResponseList<Team>>(
                      stream: _teamBloc.teamStream,
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
                              _allTeam = snapshot.data!.data!;
                              _filteredTeam ??= _allTeam;
                              final totalTeam = _filteredTeam!.length;

                              if (_filteredTeam!.isEmpty) {
                                return Center(
                                  child: Text(
                                    widget.isTeamMemberUi == false
                                        ? "No team members have been assigned for you."
                                        : "No team members have been assigned for ${widget.username}.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Total Team Members: $totalTeam',
                                          style: TextStyle(fontSize: getFontSizeSmall(), color: CustomColors.textColor),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _filteredTeam!.length,
                                        itemBuilder: (context, index) {
                                          final team = _filteredTeam![index];
                                          //final memberName = team.ypasdefNamebspr?.toString() ?? 'Unnamed Route';
                                          final memberSearchWord = team.such?.toString() ?? 'Unnamed Route';
                                          final memberOperatorId = team.ypasdefBezeich?.toString() ?? 'Unnamed Route';
                                          final memberNummer = team.nummer?.toString() ?? 'Unnamed Route';
                                          final memberOrganizationNummer = team.nummer?.toString() ?? 'Unnamed Route';
                                          final memberDesignationNummer = team.designationNummer?.toString() ?? 'Unnamed Route';

                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                                            child: ListButton(
                                              displayName: memberSearchWord,
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => HomePage(
                                                          username: memberOperatorId,
                                                          userNummer: memberNummer,
                                                          userOrganizationNummer: memberOrganizationNummer,
                                                          loggedUserNummer: widget.userNummer,
                                                          isTeamMemberUi: true, 
                                                          designationNummer: "",
                                                        )));
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            case Status.ERROR:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = false;
                                });
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
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }
}
