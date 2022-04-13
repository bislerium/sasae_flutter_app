import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sasae_flutter_app/ui/post/post_type/post_dependent_widgets/request_radial_visualization.dart';
import 'package:sasae_flutter_app/widgets/misc/custom_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RequestCard extends StatefulWidget {
  final int min;
  final int target;
  final int? max;
  final int numReaction;
  final DateTime endsOn;
  final String requestType;
  final double? animationDuration;

  const RequestCard({
    Key? key,
    required this.min,
    required this.target,
    this.max,
    required this.numReaction,
    required this.endsOn,
    required this.requestType,
    this.animationDuration,
  }) : super(key: key);

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
        LinearCounts('Minimum', widget.min),
        LinearCounts('Target', widget.target),
        if (widget.max != null) LinearCounts('Maximum', widget.max!),
        LinearCounts('Participation', widget.numReaction),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.zero,
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
                  backgroundColor: DateTime.now().isAfter(widget.endsOn)
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  label: Text(DateFormat.yMMMEd().format(widget.endsOn),
                      style: Theme.of(context).textTheme.caption?.copyWith(
                          color: DateTime.now().isAfter(widget.endsOn)
                              ? Theme.of(context).colorScheme.onError
                              : Theme.of(context).colorScheme.onSecondary)),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 400,
              child: RequestRadialVisualization(
                chartData: _chartData,
                tooltipBehavior: _tooltipBehavior,
                animationDuration: widget.animationDuration,
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