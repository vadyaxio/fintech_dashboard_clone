import 'package:flutter/material.dart';
import 'package:maxbonus_index/layout/common_layout.dart';
import 'package:maxbonus_index/sections/chart_section.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Key _key = const Key('');
  Future<void> _pullRefresh() async {
    setState(() {
      _key = Key(DateTime.now().millisecondsSinceEpoch.toString());
    });
  }

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
        title: const Text('Основные показатели'),
      ),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: SafeArea(
            child: CommonLayout(
              content: ChartSection(key: _key),
            ),
          )),
    );
  }
}
