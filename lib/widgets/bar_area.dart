import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maxbonus_index/models/bar_tooltip.dart';
import 'package:maxbonus_index/models/detail.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:maxbonus_index/models/linar_chart.dart';

class BarArea extends StatefulWidget {
  final int periodType;
  final List<Detail> currentDetails;
  final List<Detail> prevDetails;
  const BarArea({
    Key? key,
    required this.periodType,
    required this.currentDetails,
    required this.prevDetails,
  }) : super(key: key);

  @override
  State<BarArea> createState() => _BarAreaState();
}

class _BarAreaState extends State<BarArea> {
  late BarTooltip _tooltip;

  @override
  void initState() {
    super.initState();
    _tooltip = BarTooltip('', '', '', false);
  }

  resetTooltip() {
    setState(() {
      _tooltip = BarTooltip('', '', '', false);
    });
  }

  changeTooltip(model) {
    resetTooltip();
    setState(() {
      if (model.selectedDatum.length > 1) {
        if (model.selectedSeries[0].id == "Current") {
          _tooltip = BarTooltip(
              widget.periodType == 1
                  ? DateFormat('dd.MM.yyyy')
                      .format(model.selectedDatum[0].datum.date)
                      .toString()
                  : DateFormat('dd.MM.yyyy')
                          .format(model.selectedDatum[0].datum.date)
                          .toString() +
                      '-' +
                      DateFormat('dd.MM.yyyy')
                          .format(model.selectedDatum[0].datum.dateEnd)
                          .toString(),
              NumberFormat.compactCurrency(
                decimalDigits: 2,
                symbol:
                    '', // if you want to add currency symbol then pass that in this else leave it empty.
              ).format(model.selectedDatum[0].datum.value),
              NumberFormat.compactCurrency(
                decimalDigits: 2,
                symbol:
                    '', // if you want to add currency symbol then pass that in this else leave it empty.
              ).format(model.selectedDatum[1].datum.value),
              true);
        } else {
          _tooltip = BarTooltip(
              widget.periodType == 1
                  ? DateFormat('dd.MM.yyyy')
                      .format(model.selectedDatum[1].datum.date)
                      .toString()
                  : DateFormat('dd.MM.yyyy')
                          .format(model.selectedDatum[1].datum.date)
                          .toString() +
                      '-' +
                      DateFormat('dd.MM.yyyy')
                          .format(model.selectedDatum[1].datum.dateEnd)
                          .toString(),
              NumberFormat.compactCurrency(
                decimalDigits: 2,
                symbol:
                    '', // if you want to add currency symbol then pass that in this else leave it empty.
              ).format(model.selectedDatum[1].datum.value),
              NumberFormat.compactCurrency(
                decimalDigits: 2,
                symbol:
                    '', // if you want to add currency symbol then pass that in this else leave it empty.
              ).format(model.selectedDatum[0].datum.value),
              true);
        }
      } else {
        _tooltip = BarTooltip(
            widget.periodType == 1
                ? DateFormat('dd.MM.yyyy')
                    .format(model.selectedDatum[0].datum.date)
                    .toString()
                : DateFormat('dd.MM.yyyy')
                        .format(model.selectedDatum[0].datum.date)
                        .toString() +
                    '-' +
                    DateFormat('dd.MM.yyyy')
                        .format(model.selectedDatum[0].datum.dateEnd)
                        .toString(),
            NumberFormat.compactCurrency(
              decimalDigits: 2,
              symbol:
                  '', // if you want to add currency symbol then pass that in this else leave it empty.
            ).format(model.selectedDatum[0].datum.value),
            '',
            true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<LinearChart, String>> _createSampleData() {
      final current = widget.currentDetails
          .map((e) =>
              LinearChart(e.key, e.dKey, e.dateStart, e.dateEnd, e.value))
          .toList();
      final prev = widget.prevDetails
          .map((e) =>
              LinearChart(e.key, e.dKey, e.dateStart, e.dateEnd, e.value))
          .toList();

      return [
        charts.Series<LinearChart, String>(
          id: 'Current',
          colorFn: (LinearChart data, __) => prev.isNotEmpty
              ? ((prev.length - 1 < data.key)
                          ? 0
                          : prev[data.key].value!.toDouble()) >
                      data.value!.toDouble()
                  ? charts.ColorUtil.fromDartColor(
                      const Color.fromARGB(255, 255, 43, 0))
                  : charts.ColorUtil.fromDartColor(
                      const Color.fromARGB(255, 186, 230, 55))
              : charts.ColorUtil.fromDartColor(
                  const Color.fromARGB(255, 24, 186, 245)),
          domainFn: (LinearChart data, _) => data.dKey,
          measureFn: (LinearChart data, _) => data.value,
          data: current,
        ),
        charts.Series<LinearChart, String>(
          id: 'Prev',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.black12),
          //domainFn: (LinearChart data, _) => DateFormat('dd').format(data.date),
          domainFn: (LinearChart data, _) => data.dKey,
          measureFn: (LinearChart data, _) => data.value,
          data: prev,
        ),
      ];
    }

    //return Container(child: Text(detail.date ?? ''));
    return SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        child: Stack(
          children: [
            charts.BarChart(
              _createSampleData(),
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model) {
                    if (model.hasDatumSelection) {
                      changeTooltip(model);
                    }
                  },
                ),
              ],
              behaviors: [
                charts.SlidingViewport(),
                charts.PanAndZoomBehavior()
              ],
              domainAxis: charts.OrdinalAxisSpec(
                  viewport: charts.OrdinalViewport(
                      widget.currentDetails[0].dKey, 10)),
              animate: true,
              barGroupingType: charts.BarGroupingType.grouped,
            ),
            AnimatedOpacity(
                opacity: _tooltip.visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: GestureDetector(
                    onTap: () {
                      resetTooltip();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width -
                              (_tooltip.date.length > 10 ? 240 : 170)),
                      width: _tooltip.date.length > 10 ? 180 : 100,
                      height: 70,
                      decoration: const BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 3)),
                          Text(_tooltip.date,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              )),
                          const Padding(padding: EdgeInsets.only(top: 3)),
                          Text(_tooltip.current.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              )),
                          const Padding(padding: EdgeInsets.only(top: 3)),
                          Text(_tooltip.prev.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ))
                        ],
                      ),
                    )))
          ],
        ));
  }
}
