import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/models/chart.dart';
import 'package:maxbonus_index/screen/chart_details.dart';
import 'package:maxbonus_index/styles/styles.dart';
import 'package:maxbonus_index/widgets/circular_chart.dart';
import 'package:maxbonus_index/widgets/range_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ChartSection extends StatefulWidget {
  const ChartSection({Key? key}) : super(key: key);

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  late bool _loading = false;
  late List<Chart> _list = [];
  late Map<String, DateTime?> _periodDate = {
    "begin": Hive.box("chart").get("periodDate") != null
        ? Hive.box("chart").get("periodDate")['begin']
        : DateTime.now().subtract(const Duration(days: 30)),
    "end": Hive.box("chart").get("periodDate") != null
        ? Hive.box("chart").get("periodDate")['end']
        : DateTime.now(),
  };
  late Map<String, DateTime?> _compareDate = {
    "begin": Hive.box("chart").get("compareDate") != null
        ? Hive.box("chart").get("compareDate")['begin']
        : null,
    "end": Hive.box("chart").get("compareDate") != null
        ? Hive.box("chart").get("compareDate")['end']
        : null,
  };

  @override
  void initState() {
    _loading = true;
    API().chartApi(Chart(0, '', _periodDate, _compareDate)).then((result) => {
          setState(() {
            _list = result;
            _loading = false;
          })
        });
  }

  refresh(date, type) {
    _loading = true;
    setState(
        () => {type == 'period' ? _periodDate = date : _compareDate = date});
    API().chartApi(Chart(0, '', _periodDate, _compareDate)).then((result) => {
          setState(() {
            _list = result;
            _loading = false;
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        isLoading: _loading,
        opacity: 0,
        progressIndicator: Transform.scale(
          scale: 1.5,
          child: const CircularProgressIndicator(),
        ),
        child: Stack(
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
                          updateDate: refresh),
                      RangePicker(
                          type: 'compare',
                          date: _compareDate,
                          updateDate: refresh)
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
        ));
  }
}
