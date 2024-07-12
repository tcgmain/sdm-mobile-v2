import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Teams',
        onBackButtonPressed: () {},
        isHomePage: true,
      ),
      body: SafeArea(
        child: BackgroundImage(
          child: Container(),
        ),
      ),
    );
  }
}
