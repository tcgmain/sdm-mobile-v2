import 'package:flutter/material.dart';

class SalesOrderOutView extends StatefulWidget {
  const SalesOrderOutView({super.key});

  @override
  State<SalesOrderOutView> createState() => _SalesOrderOutViewState();
}

class _SalesOrderOutViewState extends State<SalesOrderOutView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("OUT"),
    );
  }
}