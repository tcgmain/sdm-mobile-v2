import 'package:flutter/material.dart';
import 'package:sdm/blocs/team_bloc.dart';
import 'package:sdm/models/team.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_view.dart';
import 'package:sdm/view/profile_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/side_bar.dart';
import 'package:sdm/widgets/text_field.dart' as text_field;

class TeamView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String userId;
  final String loggedUserNummer;
  final bool isTeamMemberUi;
  final String designationNummer;
  final String userOrganizationNummer;

  const TeamView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.userId,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
    required this.designationNummer,
    required this.userOrganizationNummer,
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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
      key: _scaffoldKey,
      appBar: CommonAppBar(
        title: widget.isTeamMemberUi == true ? 'Team - ${widget.username}' : 'My Team',
        isSideBarShown: true,
        scaffoldKey: _scaffoldKey,
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: widget.isTeamMemberUi == false ? true : false,
      ),
       drawer: CommonDrawer(
        username: widget.username,
        userNummer: widget.userNummer,
        userId: widget.userId,
        userOrganizationNummer: widget.userOrganizationNummer,
        designationNummer: widget.designationNummer,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: Column(
                children: [
                  text_field.TextField(
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
                                      child: Builder(
                                        builder: (context) {
                                          // Sort by yemplevel ascending
                                          _filteredTeam!.sort(
                                              (a, b) => int.parse(a.yemplevel!).compareTo(int.parse(b.yemplevel!)));

                                          return ListView.builder(
                                            itemCount: _filteredTeam!.length,
                                            itemBuilder: (context, index) {
                                              final team = _filteredTeam![index];
                                              final memberSearchWord = team.such?.toString() ?? 'Unnamed Route';
                                              final memberOperatorId =
                                                  team.ypasdefBezeich?.toString() ?? 'Unnamed Route';
                                              final memberNummer = team.nummer?.toString() ?? 'Unnamed Route';
                                              final memberOrganizationNummer =
                                                  team.nummer?.toString() ?? 'Unnamed Route';
                                              final memberLevel = team.yemplevel?.toString() ?? 'Unnamed Route';

                                              return Padding(
                                                  padding: const EdgeInsets.only(bottom: 3, top: 3),
                                                  child: InkWell(
                                                    splashColor: CustomColors.buttonColor,
                                                    onTap: () {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => HomePage(
                                                          username: memberOperatorId,
                                                          userNummer: memberNummer,
                                                          userId: widget.userId,
                                                          userOrganizationNummer: memberOrganizationNummer,
                                                          loggedUserNummer: widget.userNummer,
                                                          isTeamMemberUi: true,
                                                          designationNummer: "",
                                                        ),
                                                      ));
                                                    },
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                                        shape: BoxShape.rectangle,
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
                                                        leading: CircleAvatar(
                                                          backgroundColor: getEmpLevelColor(memberLevel),
                                                          radius: 20,
                                                          child: const Icon(
                                                            Icons.group,
                                                            size: 20,
                                                          ),
                                                        ),
                                                        title: Text(memberSearchWord,
                                                            style: TextStyle(
                                                                color: CustomColors.textColor,
                                                                fontSize: getFontSize())),
                                                        trailing: IconButton(
                                                          icon: const Icon(Icons.info_outline, color: Colors.white),
                                                          onPressed: () {
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => 
                                                        ProfileView(username: memberOperatorId),
                                                      ));
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            },
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
