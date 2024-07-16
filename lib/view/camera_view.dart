import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Camera',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
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
