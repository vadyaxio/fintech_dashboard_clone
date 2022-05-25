import 'package:flutter/material.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/models/chart.dart';
import 'package:maxbonus_index/screen/chart_details.dart';
import 'package:maxbonus_index/styles/styles.dart';
import 'package:maxbonus_index/widgets/circular_chart.dart';
import 'package:maxbonus_index/widgets/range_picker.dart';

class ChartSection extends StatefulWidget {
  const ChartSection({Key? key}) : super(key: key);

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  late List<Chart> _list = [];
  late Map<String, DateTime?> _periodDate = {
    "begin": DateTime.now().subtract(const Duration(days: 30)),
    "end": DateTime.now(),
  };
  late Map<String, DateTime?> _compareDate = {
    "begin": null,
    "end": null,
  };

  @override
  void initState() {
    API().chartApi(Chart(0, '', _periodDate, _compareDate)).then((result) => {
          setState(() {
            _list = result;
          })
        });
  }

  refresh(date, type) {
    setState(
        () => {type == 'period' ? _periodDate = date : _compareDate = date});
    API().chartApi(Chart(0, '', _periodDate, _compareDate)).then((result) => {
          setState(() {
            _list = result;
          }),
        });
  }

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
                      type: 'period', date: _periodDate, updateDate: refresh),
                  RangePicker(
                      type: 'compare', date: _compareDate, updateDate: refresh)
                ]),
            for (Chart item in _list)
              Flexible(
                  child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChartDetailsPage(
                                    item: item,
                                    refresh: refresh,
                                    periodDate: _periodDate,
                                    compareDate: _compareDate,
                                  ))),
                      child: CircularChart(
                        title: item.factorName,
                        description: item.description,
                        amount: item.factCurrent,
                        amountPrev: item.factPrev,
                        dynamic: item.factDynamic,
                        barColor: Styles.defaultBlueColor,
                        withTitle: true,
                      ))),
          ],
        ),
      ],
    );
  }
}
