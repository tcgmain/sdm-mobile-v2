import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';

class SalesOrderView extends StatefulWidget {
  const SalesOrderView({super.key});

  @override
  State<SalesOrderView> createState() => _SalesOrderViewState();
}

class _SalesOrderViewState extends State<SalesOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Sales Orders',
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
