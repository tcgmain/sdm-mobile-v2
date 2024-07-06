import 'package:flutter/material.dart';

class RegionView extends StatefulWidget {
  const RegionView({super.key});

  @override
  State<RegionView> createState() => _RegionViewState();
}

class _RegionViewState extends State<RegionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("This is region page"),
    );
  }
}