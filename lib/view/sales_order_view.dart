import 'package:flutter/material.dart';

class SalesOrderView extends StatefulWidget {
  const SalesOrderView({super.key});

  @override
  State<SalesOrderView> createState() => _SalesOrderViewState();
}

class _SalesOrderViewState extends State<SalesOrderView> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Text("This is sales order page"),
    );
  }
}