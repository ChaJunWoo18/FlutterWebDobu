import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BarWidget());
}

class BarWidget extends StatefulWidget {
  const BarWidget({super.key});

  @override
  _BarWidgetState createState() => _BarWidgetState();
}

int touchedIndex = -1;

bool isPlaying = false;
List<double> barValue = [100, 200, 50, 400];
int allOutcome = 1500;

class _BarWidgetState extends State<BarWidget> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: _getBarGroups(),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                Icon icon;
                double iconSize = 30.0;
                Color iconColor = const Color(0xffFFDDCC);
                switch (value.toInt()) {
                  case 0:
                    icon = Icon(
                      Icons.coffee,
                      size: iconSize,
                      color: iconColor,
                    );
                    break;
                  case 1:
                    icon = Icon(
                      Icons.rice_bowl_rounded,
                      size: iconSize,
                      color: iconColor,
                    );
                    break;
                  case 2:
                    icon = Icon(
                      Icons.subway_rounded,
                      size: iconSize,
                      color: iconColor,
                    );
                    break;
                  case 3:
                    icon = Icon(
                      Icons.fitness_center_rounded,
                      size: iconSize,
                      color: iconColor,
                    );
                    break;
                  default:
                    icon = Icon(
                      Icons.error_outline_rounded,
                      size: iconSize,
                      color: iconColor,
                    );
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 5,
                  child: icon,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 200,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                );
                Widget text;
                switch (value.toInt()) {
                  case 200:
                    text = const Text('200', style: style);
                    break;
                  case 400:
                    text = const Text('400', style: style);
                    break;
                  case 600:
                    text = const Text('600', style: style);
                    break;
                  case 800:
                    text = const Text('800', style: style);
                    break;
                  case 1000:
                    text = const Text('1k', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 0,
                  child: text,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        gridData: const FlGridData(
          show: false,
        ),
        barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.transparent,
              tooltipHorizontalAlignment: FLHorizontalAlignment.center,
              //maxContentWidth: 50,
              tooltipPadding: EdgeInsets.zero,
              tooltipMargin: -15,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String top4Percent;
                switch (group.x) {
                  case 0:
                    top4Percent = '${(barValue[0] / allOutcome * 100).toInt()}';
                    break;
                  case 1:
                    top4Percent = '${(barValue[1] / allOutcome * 100).toInt()}';
                    break;
                  case 2:
                    top4Percent = '${(barValue[2] / allOutcome * 100).toInt()}';
                    break;
                  case 3:
                    top4Percent = '${(barValue[3] / allOutcome * 100).toInt()}';
                    break;
                  default:
                    throw Error();
                }
                return BarTooltipItem(
                  '$top4Percent%\n',
                  const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                  // children: <TextSpan>[
                  //   TextSpan(
                  //     text: barValue[rodIndex].toString(),
                  //     style: const TextStyle(
                  //       color: Colors.blue, //widget.touchedBarColor,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ],
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {}
            // touchCallback: (FlTouchEvent event, barTouchResponse) {
            //   setState(() {
            //     if (!event.isInterestedForInteractions ||
            //         barTouchResponse == null ||
            //         barTouchResponse.spot == null) {
            //       touchedIndex = -1;
            //       return;
            //     }
            //     touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            //   });
            // },
            ),
        minY: 0,
        maxY: 1000,
      ),
    );
  }

  // List<BarChartGroupData> _getBarGroups() {
  //   return List.generate(4, (index) {
  //     return BarChartGroupData(
  //       x: index,
  //       barRods: [
  //         BarChartRodData(
  //           toY: barValue[index], //(index + 1) * 2,
  //           width: 60,
  //           color: const Color.fromARGB(255, 253, 180, 167), // 기본 색상
  //           borderRadius: BorderRadius.zero,
  //           backDrawRodData: BackgroundBarChartRodData(
  //             show: true,
  //             toY: 1000,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ],
  //       showingTooltipIndicators: [],
  //     );
  //   });
  // }
  List<BarChartGroupData> _getBarGroups() {
    return List.generate(4, (groupIndex) {
      return BarChartGroupData(
        x: groupIndex,
        barRods: List.generate(1, (rodIndex) {
          return BarChartRodData(
            toY: barValue[groupIndex],
            width: 60,
            color: const Color.fromARGB(255, 253, 180, 167),
            borderRadius: BorderRadius.zero,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 1000,
              color: Colors.white,
            ),
          );
        }),
        showingTooltipIndicators: [0],
      );
    });
  }
}
