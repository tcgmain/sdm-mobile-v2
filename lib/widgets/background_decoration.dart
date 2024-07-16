import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;
  final bool isTeamMemberUi;
  const BackgroundImage({
    Key? key, 
    required this.child,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          //color: Colors.black,
          image: DecorationImage(
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
        image: const AssetImage('images/background.png'),
      )),
      child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: isTeamMemberUi == false ? CustomColors.borderColor: CustomColors.borderColor1),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: child),
    );
  }
}
