import 'package:flutter/material.dart';
import 'package:sdm/blocs/stock_bloc.dart';
import 'package:sdm/models/stock.dart';

class StockView extends StatefulWidget {
  final String userNummer;
  final String organizationNummer;

  const StockView({
    Key? key,
    required this.userNummer,
    required this.organizationNummer,
  }) : super(key: key);

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  @override
  Widget build(BuildContext context) {



    

    return const Placeholder();
  }
}
