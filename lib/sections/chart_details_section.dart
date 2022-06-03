import 'package:flutter/material.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/models/chart.dart';
import 'package:maxbonus_index/models/chart_details.dart';
import 'package:maxbonus_index/models/detail.dart';
import 'package:maxbonus_index/styles/styles.dart';
import 'package:maxbonus_index/widgets/bar_area.dart';
import 'package:maxbonus_index/widgets/circular_chart.dart';
import 'package:maxbonus_index/widgets/group_button.dart';
import 'package:maxbonus_index/widgets/range_picker.dart';
import 'package:maxbonus_index/widgets/stacked_area.dart';

class ChartDetailsSection extends StatefulWidget {
  final Chart item;
  final Function refresh;
  final Map<String, DateTime?> periodDate;
  final Map<String, DateTime?> compareDate;
  const ChartDetailsSection(
      {Key? key,
      required this.item,
      required this.refresh,
      required this.periodDate,
      required this.compareDate})
      : super(key: key);

  @override
  State<ChartDetailsSection> createState() => _ChartDetailsSectionState();
}

class _ChartDetailsSectionState extends State<ChartDetailsSection> {
  late int _periodType = 3;
  late Chart _chart = widget.item;
  late List<Detail> _currentDetailList = [];
  late List<Detail> _prevDetailList = [
    Detail(0, "0", DateTime.parse('2020-01-02 03:04:05'),
        DateTime.parse('2020-01-02 03:04:05'))
  ];
  late Map<String, DateTime?> _periodDate = widget.periodDate;
  late Map<String, DateTime?> _compareDate = widget.compareDate;

  @override
  void initState() {
    super.initState();
    requestApi();
  }

  requestApi() {
    API()
        .chartDetailsApi(context,
            ChartDetails(_chart, _periodType, _periodDate, _compareDate))
        .then((result) => {
              setState(() {
                _chart = result.chart;
                _currentDetailList = result.currentDetails!;
                _prevDetailList = result.prevDetails!;
              }),
            });
  }

  refresh(date, type) {
    widget.refresh(date, type);

    type == 'period' ? _periodDate = date : _compareDate = date;
    requestApi();
  }

  updatePeriod(int type) {
    _periodType = type;
    requestApi();
  }

  updateType(int type) {}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RangePicker(
                      type: 'period',
                      date: _periodDate,
                      dynamic: _chart.factDynamic,
                      updateDate: refresh),
                  RangePicker(
                      type: 'compare',
                      date: _compareDate,
                      dynamic: 0,
                      updateDate: refresh)
                ]),
            CircularChart(
              title: _chart.factorName,
              description: _chart.description,
              amount: _chart.factCurrent,
              amountPrev: _chart.factPrev,
              dynamic: _chart.factDynamic,
              barColor: Styles.defaultBlueColor,
              withTitle: false,
            ),
            GroupButtonVertical(
              activeButton: 1,
              updateState: updateType,
              type: 'common',
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            GroupButtonVertical(
              activeButton: _periodType,
              updateState: updatePeriod,
              type: 'periodUnit',
            ),
            SizedBox(
                height: 220,
                child: _currentDetailList.isNotEmpty
                    ? _periodType == 3
                        ? StackedArea(
                            currentDetails: _currentDetailList,
                            prevDetails: _prevDetailList)
                        : BarArea(
                            periodType: _periodType,
                            currentDetails: _currentDetailList,
                            prevDetails: _prevDetailList)
                    : const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Нет данных',
                            style: TextStyle(fontStyle: FontStyle.italic))))
          ],
        ),
      ],
    );
  }
}
