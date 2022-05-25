import 'package:flutter/material.dart';
import 'package:maxbonus_index/layout/common_layout.dart';
import 'package:maxbonus_index/models/chart.dart';
import 'package:maxbonus_index/sections/chart_details_section.dart';

class ChartDetailsPage extends StatefulWidget {
  final Chart item;
  final Function refresh;
  final Map<String, DateTime?> periodDate;
  final Map<String, DateTime?> compareDate;
  const ChartDetailsPage(
      {Key? key,
      required this.item,
      required this.refresh,
      required this.periodDate,
      required this.compareDate})
      : super(key: key);

  @override
  State<ChartDetailsPage> createState() => _ChartDetailsPageState();
}

class _ChartDetailsPageState extends State<ChartDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromARGB(255, 250, 102, 28),
                  Color.fromARGB(248, 255, 68, 0)
                ]),
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(widget.item.factorName),
      ),
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                Color.fromARGB(255, 250, 102, 28),
                Color.fromARGB(248, 255, 68, 0)
              ])),
          child: SafeArea(
            child: CommonLayout(
              content: ChartDetailsSection(
                item: widget.item,
                refresh: widget.refresh,
                periodDate: widget.periodDate,
                compareDate: widget.compareDate,
              ),
            ),
          )),
    );
  }
}
