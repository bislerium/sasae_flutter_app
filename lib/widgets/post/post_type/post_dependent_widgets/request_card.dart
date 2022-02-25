import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:sasae_flutter_app/widgets/post/post_type/post_dependent_widgets/request_pyramid_visualization.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RequestCard extends StatefulWidget {
  final int min;
  final int target;
  final int? max;
  final int numReaction;
  final DateTime endsOn;
  final String requestType;
  final bool isReacted;

  const RequestCard(
      {Key? key,
      required this.min,
      required this.target,
      this.max,
      required this.numReaction,
      required this.endsOn,
      required this.requestType,
      required this.isReacted})
      : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late List<LinearCounts> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<LinearCounts> getChartData() => [
        LinearCounts('min', widget.min),
        LinearCounts('target', widget.target),
        if (widget.max != null) LinearCounts('max', widget.max!),
        LinearCounts('reactions', widget.numReaction),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.requestType == 'Petition'
                      ? 'Petition Request:'
                      : 'Join Request:',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  label: Text(
                    DateFormat.yMMMEd().format(widget.endsOn),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 500,
              child: RequestPyramidVisualization(
                chartData: _chartData,
                tooltipBehavior: _tooltipBehavior,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinearCounts {
  final String title;
  final int count;

  LinearCounts(this.title, this.count);
}
