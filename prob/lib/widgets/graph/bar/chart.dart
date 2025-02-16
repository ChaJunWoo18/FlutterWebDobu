import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AspectRatio(
        aspectRatio: 2.0,
        // child: Container(
        //   color: Colors.red,
        //   margin: const EdgeInsets.all(24),
        //   child: BarChart(
        //     BarChartData(backgroundColor: Colors.amber),
        //   ),
        // ),
      ),
    );
  }
}
