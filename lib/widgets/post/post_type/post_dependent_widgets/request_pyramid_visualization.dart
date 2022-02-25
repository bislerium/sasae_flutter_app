import 'package:flutter/material.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/request_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RequestPyramidVisualization extends StatelessWidget {
  final List<LinearCounts> chartData;
  final TooltipBehavior tooltipBehavior;

  const RequestPyramidVisualization(
      {Key? key, required this.chartData, required this.tooltipBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfPyramidChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        isResponsive: true,
      ),
      tooltipBehavior: tooltipBehavior,
      series: PyramidSeries<LinearCounts, String>(
        dataSource: chartData,
        xValueMapper: (LinearCounts data, _) => data.title,
        yValueMapper: (LinearCounts data, _) => data.count,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          overflowMode: OverflowMode.shift,
          useSeriesColor: true,
        ),
      ),
    );
  }
}
