import 'package:flutter/material.dart';
import 'package:sdm/blocs/user_details_bloc.dart';
import 'package:sdm/models/user_details.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';

class ProfileView extends StatefulWidget {
  final String username;

  const ProfileView({
    super.key,
    required this.username,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late UserDetailsBloc _userDetailsBloc;
  bool _isLoading = false;
  bool _isErrorMessageShown = false;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = UserDetailsBloc();
    _userDetailsBloc.getUserDetails(widget.username.toString());
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    _userDetailsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Profile',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: false,
              child: StreamBuilder<ResponseList<UserDetails>>(
                stream: _userDetailsBloc.userDetailsStream,
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
                        var fullName = snapshot.data!.data![0].namebspr.toString();
                        var designation = snapshot.data!.data![0].ydes.toString();
                        var email = snapshot.data!.data![0].email.toString();
                        var nic = snapshot.data!.data![0].ynic.toString();
                        var address = snapshot.data!.data![0].str.toString();
                        var location = snapshot.data!.data![0].yusrloc.toString();
                        var hrisId = snapshot.data!.data![0].yhrisid.toString();

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        fullName.isNotEmpty ? fullName[0] : '?',
                                        style: const TextStyle(color: Colors.white, fontSize: 40),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      fullName,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      designation,
                                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey.shade400,
                                      Colors.white,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                //elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow(Icons.email, 'Email', email),
                                      _buildInfoRow(Icons.perm_identity, 'NIC', nic),
                                      _buildInfoRow(Icons.home, 'Address', address),
                                      _buildInfoRow(Icons.location_on, 'Location', location),
                                      _buildInfoRow(Icons.card_membership, 'HRIS ID', hrisId),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
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
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black38), // Customize icon color here
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
