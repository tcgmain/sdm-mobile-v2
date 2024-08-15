import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/create_order_view.dart';
import 'package:sdm/view/sales_order_in_list_view.dart';
import 'package:sdm/view/sales_order_out_list_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';

class SalesOrderListView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String loggedUserNummer;
  final String organizationNummer;
  final String organizationName;
  final String ysuporgNummer;
  final String ysuporgNamebspr;
  final bool isTeamMemberUi;

  const SalesOrderListView({
    super.key,
    required this.userNummer,
    required this.username,
    required this.loggedUserNummer,
    required this.organizationNummer,
    required this.organizationName,
    required this.ysuporgNummer,
    required this.ysuporgNamebspr,
    required this.isTeamMemberUi,
  });

  @override
  State<SalesOrderListView> createState() => _SalesOrderListViewState();
}

class _SalesOrderListViewState extends State<SalesOrderListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Order Management',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.ysuporgNummer == "") {
            showErrorAlertDialog(context, "You cannot create orders in this organization");
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => CreateOrderView(
                        userNummer: widget.userNummer,
                        organizationNummer: widget.organizationNummer,
                        organizationName: widget.organizationName,
                        ysuporgNummer: widget.ysuporgNummer,
                        ysuporgNamebspr: widget.ysuporgNamebspr,
                        isTeamMemberUi: widget.isTeamMemberUi,
                        username: widget.username,
                        loggedUserNummer: widget.loggedUserNummer,
                      )),
            );
          }
        },
        backgroundColor: CustomColors.buttonColor,
        child: const Icon(
          Icons.add,
          color: CustomColors.buttonTextColor,
        ),
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
                      text: 'IN Orders',
                      icon: Icon(Icons.arrow_downward, size: 22),
                    ),
                    Tab(
                      text: 'OUT Orders',
                      icon: Icon(Icons.arrow_upward, size: 22),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SalesOrderInListView(
                        userNummer: widget.userNummer,
                        username: widget.username,
                        loggedUserNummer: widget.loggedUserNummer,
                        organizationNummer: widget.organizationNummer,
                        isTeamMemberUi: widget.isTeamMemberUi,
                      ),
                      SalesOrderOutListView(
                        userNummer: widget.userNummer,
                        username: widget.username,
                        loggedUserNummer: widget.loggedUserNummer,
                        organizationNummer: widget.organizationNummer,
                        isTeamMemberUi: widget.isTeamMemberUi,
                      ),
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
