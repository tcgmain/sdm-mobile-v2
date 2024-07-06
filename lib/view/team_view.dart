import 'package:flutter/material.dart';

class TeamView extends StatefulWidget {
  const TeamView({super.key});

  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("This is teams page"),
    );
  }
}