import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';

class AddOrganizationView extends StatefulWidget {
  const AddOrganizationView({super.key});

  @override
  State<AddOrganizationView> createState() => _AddOrganizationViewState();
}

class _AddOrganizationViewState extends State<AddOrganizationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Add Organizations',
        onBackButtonPressed: () {},
        isHomePage: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddOrganizationView()));
        },
        backgroundColor: CustomColors.buttonColor,
        child: const Icon(
          Icons.refresh,
          color: CustomColors.buttonTextColor,
        ),
      ),
      body: SafeArea(
        child: BackgroundImage(
          child: Container(),
        ),
      ),
    );
  }
}
