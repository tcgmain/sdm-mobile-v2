import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Routes',
        onBackButtonPressed: () {},
        userName: '',
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: CustomColors.borderColor),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: Text('My Awesome Border'),
        ),
      ),
    );
  }
}
