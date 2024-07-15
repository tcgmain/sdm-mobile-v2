import 'package:flutter/material.dart';

class SalesOrderInView extends StatefulWidget {
  const SalesOrderInView({super.key});

  @override
  State<SalesOrderInView> createState() => _SalesOrderInViewState();
}

class _SalesOrderInViewState extends State<SalesOrderInView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("IN"),
    );
  }
}