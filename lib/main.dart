// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sdm/view/splash_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ApprovalHub',
      theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(color: Color.fromRGBO(81, 95, 131, 1))),
      // ignore: prefer_const_constructors
      home: SplashView(),
    );
  }
}
