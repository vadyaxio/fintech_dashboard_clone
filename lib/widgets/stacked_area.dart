import 'package:flutter/material.dart';
import 'package:maxbonus_index/models/detail.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:maxbonus_index/models/linar_chart.dart';
import 'package:maxbonus_index/models/localization.dart';

class StackedArea extends StatelessWidget {
  final List<Detail> currentDetails;
  final List<Detail> prevDetails;
  const StackedArea({
    Key? key,
    required this.currentDetails,
    required this.prevDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<LinearChart, DateTime>> _createSampleData() {
      final current = currentDetails
          .map((e) =>
              LinearChart(e.key, e.dKey, e.dateStart, e.dateEnd, e.value))
          .toList();
      final prev = prevDetails
          .map((e) =>
              LinearChart(e.key, e.dKey, e.dateStart, e.dateEnd, e.value))
          .toList();

      return [
        charts.Series<LinearChart, DateTime>(
          id: 'Current',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
              const Color.fromARGB(255, 24, 186, 245)),
          strokeWidthPxFn: (LinearChart data, _) => 5,
          domainFn: (LinearChart data, _) => DateTime.parse(data.dKey),
          measureFn: (LinearChart data, _) => data.value,
          data: current,
        ),
        charts.Series<LinearChart, DateTime>(
          id: 'Prev',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.black12),
          strokeWidthPxFn: (LinearChart data, _) => 5,
          domainFn: (LinearChart data, _) => DateTime.parse(data.dKey),
          measureFn: (LinearChart data, _) => data.value,
          data: prev,
        ),
      ];
    }

    //return Container(child: Text(detail.date ?? ''));
    return SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        child: charts.TimeSeriesChart(_createSampleData(),
            domainAxis: const charts.DateTimeAxisSpec(
              tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                day: charts.TimeFormatterSpec(
                  format: 'MMM',
                  transitionFormat: 'MMM',
                ),
              ),
            ),
            dateTimeFactory:
                LocalizedDateTimeFactory(Localizations.localeOf(context)),
            defaultRenderer:
                charts.LineRendererConfig(includeArea: true, stacked: false),
            behaviors: [charts.SlidingViewport(), charts.PanAndZoomBehavior()],
            animate: true));
  }
}
