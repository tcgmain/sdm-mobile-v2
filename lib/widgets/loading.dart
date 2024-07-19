// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  final String? loadingMessage;

  const Loading({super.key, this.loadingMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 80,
          ),
          // if (loadingMessage != null) ...[
          //   SizedBox(height: 20),
          //   Text(
          //     loadingMessage!,
          //     style: TextStyle(color: Colors.white, fontSize: 16),
          //   ),
          // ],
        ],
      ),
    );
  }
}
