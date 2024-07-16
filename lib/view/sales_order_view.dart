import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/sales_order_in_view.dart';
import 'package:sdm/view/sales_order_out_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';

class SalesOrderView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final bool isTeamMemberUi;

  const SalesOrderView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.isTeamMemberUi,
  }) : super(key: key);

  @override
  State<SalesOrderView> createState() => _SalesOrderViewState();
}

class _SalesOrderViewState extends State<SalesOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Sales Orders',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: BackgroundImage(
          isTeamMemberUi: widget.isTeamMemberUi,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: CustomColors.appBarColor1,
                  labelColor: CustomColors.textColorWhite,
                  unselectedLabelColor: CustomColors.textColor,
                  labelStyle: TextStyle(
                    fontSize: getFontSize(),
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorWeight: 3,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
                  tabs: const [
                    Tab(
                      text: 'Sales In',
                      icon: Icon(Icons.arrow_downward, size: 22),
                    ),
                    Tab(
                      text: 'Sales Out',
                      icon: Icon(Icons.arrow_upward, size: 22),
                    ),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      SalesOrderInView(),
                      SalesOrderOutView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
