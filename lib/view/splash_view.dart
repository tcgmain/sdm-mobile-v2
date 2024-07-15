import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdm/view/login_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Disable screenshots
    //FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    
    // Set system UI visibility flags
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
          image: const AssetImage('images/background.png'),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.0,
              child: Image.asset('images/tokyo_logo.png'),
            ),
            SizedBox(
              height: 130.0,
              child: Image.asset('images/sdm_logo.png'),
            ),
            const SizedBox(height: 100),
            LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
