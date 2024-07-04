// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String? loadingMessage;

  const Loading({super.key, this.loadingMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // const CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            //   strokeWidth: 5.0,
            // ),
            //const SizedBox(height: 24),
            if (loadingMessage != null) ...[
              Text(
                loadingMessage!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            //const SizedBox(height: 16),
            const LoadingAnimation(),
          ],
        ),
      ),
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const Icon(
        Icons.hourglass_bottom,
        color: Colors.teal,
        size: 40,
      ),
    );
  }
}


