// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  final String? loadingMessage;

  const Loading({super.key, this.loadingMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.0, 0.0),
          radius: 1.0,
          colors: [
            Colors.black.withOpacity(0.5), // Starting color at corners
            Colors.black.withOpacity(0.0), // Ending color at center
          ],
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}
