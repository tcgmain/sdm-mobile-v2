import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/target_achievement_bloc.dart';
import 'package:sdm/models/target_achievement.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardView extends StatefulWidget {
  final String userNummer;
  const DashboardView({
    required this.userNummer,
    super.key,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isLoading = false;
  bool _isTargetAchievementErrorShown = false;
  late TargetAchievementBloc _targetAchievementBloc;
  double barChartWidth = 0.7;
  double barChartSpace = 0.1;

  late List<ProductData> chartData = [];

  late int selectedYear;
  late int selectedMonth;

  List<int> years = List.generate(10, (index) => DateTime.now().year - index);
  List<int> months = List.generate(12, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    _targetAchievementBloc = TargetAchievementBloc();

    DateTime now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;

    _loadTargetAchievement();

    setState(() {
      _isLoading = true;
    });
  }

  void _loadTargetAchievement() {
    _targetAchievementBloc.getTargetAchievement(
      widget.userNummer,
      selectedYear.toString(),
      selectedMonth.toString(),
    );
  }

  @override
  void dispose() {
    _targetAchievementBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Dashboard',
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade400, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  //padding: const EdgeInsets.all(8.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<int>(
                          value: selectedYear,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedYear = newValue;
                                _loadTargetAchievement();
                              });
                            }
                          },
                          items: years
                              .map<DropdownMenuItem<int>>(
                                (int value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                ),
                              )
                              .toList(),
                        ),
                        DropdownButton<int>(
                          value: selectedMonth,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedMonth = newValue;
                                _loadTargetAchievement();
                              });
                            }
                          },
                          items: months
                              .map<DropdownMenuItem<int>>(
                                (int value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(DateFormat.MMMM().format(DateTime(0, value))),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    targetAchievementResponse(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        //width: MediaQuery.of(context).size.width,
                        width: 1500,
                        //height: 600,
                        child: SfCartesianChart(
                          isTransposed: true,
                          title: const ChartTitle(text: 'Targets Vs Achievement', alignment: ChartAlignment.near),
                          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                          primaryXAxis: const CategoryAxis(title: AxisTitle(text: 'Product'), labelRotation: 45),
                          primaryYAxis: const NumericAxis(
                            title: AxisTitle(text: 'MT', alignment: ChartAlignment.center),
                          ),
                          series: <CartesianSeries>[
                            // Target group
                            StackedBarSeries<ProductData, String>(
                              isVisibleInLegend: true,
                              groupName: 'target',
                              dataSource: chartData,
                              xValueMapper: (ProductData data, _) => data.product,
                              yValueMapper: (ProductData data, _) => data.directTarget,
                              name: 'Direct Target',
                              color: const Color(0xFF009688),
                              width: barChartWidth,
                              spacing: barChartSpace,
                            ),
                            StackedBarSeries<ProductData, String>(
                              isVisibleInLegend: true,
                              groupName: 'target',
                              dataSource: chartData,
                              xValueMapper: (ProductData data, _) => data.product,
                              yValueMapper: (ProductData data, _) => data.indirectTarget,
                              name: 'Indirect Target',
                              color: const Color(0xFF3F51B5),
                              width: barChartWidth,
                              spacing: barChartSpace,
                            ),

                            // Achievement group
                            StackedBarSeries<ProductData, String>(
                              isVisibleInLegend: true,
                              groupName: 'achievement',
                              dataSource: chartData,
                              xValueMapper: (ProductData data, _) => data.product,
                              yValueMapper: (ProductData data, _) => data.directAchievement,
                              name: 'Direct Achievement',
                              color: const Color(0xFFFF7043),
                              width: barChartWidth,
                              spacing: barChartSpace,
                            ),
                            StackedBarSeries<ProductData, String>(
                              isVisibleInLegend: true,
                              groupName: 'achievement',
                              dataSource: chartData,
                              xValueMapper: (ProductData data, _) => data.product,
                              yValueMapper: (ProductData data, _) => data.indirectAchievement,
                              name: 'Indirect Achievement',
                              color: const Color(0xFF7E57C2),
                              width: barChartWidth,
                              spacing: barChartSpace,
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Widget targetAchievementResponse() {
    return StreamBuilder<ResponseList<TargetAchievement>>(
      stream: _targetAchievementBloc.targetAchievementStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status!) {
            case Status.LOADING:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
              });
              break;

            case Status.COMPLETED:
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isLoading = false;
                  chartData.clear();
                  for (var item in snapshot.data!.data!) {
                    chartData.add(ProductData(
                      item.yprodtecl.toString(),
                      item.ytargetqty?.toDouble() ?? 0.0,
                      item.yindtargetqty?.toDouble() ?? 0.0,
                      item.ydirachqty?.toDouble() ?? 0.0,
                      item.yindachqty?.toDouble() ?? 0.0,
                    ));
                  }
                });
              });
              break;

            case Status.ERROR:
              if (!_isTargetAchievementErrorShown) {
                _isTargetAchievementErrorShown = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showErrorAlertDialog(context, snapshot.data!.message.toString());
                });
              }
              break;
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ProductData {
  final String product;
  final double directTarget;
  final double indirectTarget;
  final double directAchievement;
  final double indirectAchievement;

  ProductData(this.product, this.directTarget, this.indirectTarget, this.directAchievement, this.indirectAchievement);
}
