import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/request_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RequestRadialVisualization extends StatelessWidget {
  final List<LinearCounts> chartData;
  final TooltipBehavior tooltipBehavior;

  const RequestRadialVisualization(
      {Key? key, required this.chartData, required this.tooltipBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        isResponsive: true,
      ),
      tooltipBehavior: tooltipBehavior,
      series: <CircularSeries>[
        RadialBarSeries<LinearCounts, String>(
          radius: '150',
          innerRadius: '40',
          dataSource: chartData,
          xValueMapper: (LinearCounts data, _) => data.title,
          yValueMapper: (LinearCounts data, _) => data.count,
          legendIconType: LegendIconType.circle,
          cornerStyle: CornerStyle.bothCurve,
          trackColor: Theme.of(context).colorScheme.surfaceVariant,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            overflowMode: OverflowMode.shift,
            useSeriesColor: true,
            textStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
