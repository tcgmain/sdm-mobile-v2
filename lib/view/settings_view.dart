import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/loading.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Settings',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: false,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                ),
                height: 600,
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 40.0),
                constraints: const BoxConstraints(
                  maxWidth: 550,
                ),
                child: const Column(
                  children: [
                    Text(
                      "🔧 Settings Under Development",
                      style: TextStyle(fontWeight: FontWeight.bold, color: CustomColors.textColor),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "We're still working on this section to improve your experience. Some features may be unavailable or incomplete for now. Stay tuned for updates!",
                      style: TextStyle(color: CustomColors.textColor),
                    )
                  ],
                ),
              ),
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }
}
