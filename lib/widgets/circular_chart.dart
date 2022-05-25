import 'package:maxbonus_index/responsive.dart';
import 'package:maxbonus_index/styles/styles.dart';
import 'package:maxbonus_index/widgets/dynamic_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularChart extends StatelessWidget {
  final String title;
  final String? description;
  final Color barColor;
  final double? amount;
  final double? amountPrev;
  final double? dynamic;
  final bool withTitle;

  const CircularChart(
      {Key? key,
      required this.title,
      required this.description,
      required this.amount,
      this.amountPrev,
      this.dynamic,
      required this.barColor,
      required this.withTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasPrevData = (amountPrev != 0);
    return Container(
      decoration: BoxDecoration(
        borderRadius: Styles.defaultBorderRadius,
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          withTitle
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500
                          // FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      color: Colors.black38,
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        print('123');
                      },
                    ),
                  ],
                )
              : const SizedBox(),
          Responsive.isDesktop(context)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DynamicText(
                      fontSize: 16,
                      dynamic: dynamic ?? 0.0,
                      unit: '%',
                    ),
                    const SizedBox(width: 8),
                  ],
                )
              : Column(
                  children: [
                    hasPrevData
                        ? DynamicText(
                            fontSize: 20,
                            dynamic: dynamic ?? 0.0,
                            unit: '%',
                          )
                        : const SizedBox(),
                    const SizedBox(width: 8),
                  ],
                ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  hasPrevData
                      ? Container(
                          margin: const EdgeInsets.only(top: 70),
                          child: Text(
                            amountPrev.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: Colors.black38),
                          ),
                        )
                      : const SizedBox(),
                  hasPrevData
                      ? CircularPercentIndicator(
                          radius: 105.0,
                          lineWidth: 24.0,
                          animation: true,
                          percent: (dynamic ?? 0.0) < 0.0 ||
                                  (amount ?? 0.0) == 0
                              ? 0.67
                              : ((amountPrev ?? 0.0) * 0.67) / (amount ?? 0.0),
                          header: const Text(
                            '',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          startAngle: 240,
                          backgroundColor: Colors.transparent,
                          progressColor: Colors.black12,
                        )
                      : const SizedBox(),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 24.0,
                    animation: true,
                    percent: (dynamic ?? 0.0) > 0.0 || amountPrev == 0
                        ? 0.67
                        : ((amount ?? 0.0) * 0.67) / (amountPrev ?? 0.0),
                    center: Text(
                      amount.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                          fontFamily: 'Montserrat'),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    startAngle: 240,
                    linearGradient: hasPrevData
                        ? (dynamic ?? 0.0) > 0.0
                            ? const LinearGradient(colors: [
                                Color.fromARGB(255, 186, 230, 55),
                                Color.fromARGB(255, 19, 193, 4)
                              ])
                            : const LinearGradient(colors: [
                                Color.fromARGB(255, 255, 0, 0),
                                Color.fromARGB(255, 255, 0, 0)
                              ])
                        : const LinearGradient(colors: [
                            Color.fromARGB(255, 24, 186, 245),
                            Color.fromARGB(255, 10, 127, 245)
                          ]),
                    backgroundColor: Colors.transparent,
                    //progressColor: Colors.purple,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 170),
                    child: Text(
                      description ?? '',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  )
                ],
              )
            ],
          ),
          withTitle
              ? Divider(
                  height: 1,
                  thickness: 0.2,
                  indent: 0,
                  endIndent: 0,
                  color: Theme.of(context).hintColor,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
