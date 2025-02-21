import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class BirthdayPopup extends StatefulWidget {
  final String ownerName;

  const BirthdayPopup({
    super.key,
    required this.ownerName,
  });

  @override
  State<BirthdayPopup> createState() => _BirthdayPopupState();
}

class _BirthdayPopupState extends State<BirthdayPopup> {
  late ConfettiController _centerController;

  @override
  void initState() {
    super.initState();
    _centerController = ConfettiController(duration: const Duration(milliseconds: 240));

    // Play confetti animation and show popup dialog after widget initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerController.play();
      // Automatically close the dialog after 9 seconds
      Future.delayed(const Duration(seconds: 9), () {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti widget for celebratory effect
          ConfettiWidget(
            confettiController: _centerController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            gravity: 0.08,
            numberOfParticles: 240,
            emissionFrequency: 0.05,
          ),
          // Popup design
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  // const Color.fromARGB(255, 37, 35, 35).withOpacity(0.95),
                  // const Color.fromARGB(255, 151, 47, 47).withOpacity(0.95),
                  Colors.black38.withOpacity(0.9),
                  Colors.black87.withOpacity(0.5),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Today is ${widget.ownerName}'s Birthday!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "We thought you wouldn't want to miss a chance to wish them a happy birthday!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'images/white_cake.png',
                  height: 250,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
