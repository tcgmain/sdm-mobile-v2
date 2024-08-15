import 'package:flutter/material.dart';
import 'package:sdm/view/splash_view.dart';

void main() async {
 
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sdm',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(81, 95, 131, 1)),
      ),
      home: const SplashView(),
    );
  }

}
