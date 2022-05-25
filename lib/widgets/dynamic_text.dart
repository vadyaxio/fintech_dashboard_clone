import 'package:flutter/material.dart';

class DynamicText extends StatelessWidget {
  final double dynamic;
  final double fontSize;
  final String? unit;
  const DynamicText({
    Key? key,
    this.fontSize = 20,
    this.unit,
    required this.dynamic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: dynamic > 0
              ? const Color.fromARGB(255, 231, 250, 212)
              : const Color.fromARGB(255, 250, 230, 212),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                  child: dynamic > 0
                      ? const Icon(
                          Icons.arrow_upward,
                          color: Color.fromARGB(255, 19, 193, 4),
                        )
                      : const Icon(Icons.arrow_downward,
                          color: Color.fromARGB(255, 255, 0, 1)),
                  alignment: PlaceholderAlignment.middle),
              TextSpan(
                text: dynamic > 0
                    ? dynamic.toStringAsFixed(2)
                    : dynamic.abs().toStringAsFixed(2),
                style: TextStyle(
                  color: dynamic > 0
                      ? const Color.fromARGB(255, 19, 193, 4)
                      : const Color.fromARGB(255, 255, 0, 1),
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: unit,
                style: TextStyle(
                  fontSize: fontSize,
                  color: dynamic > 0
                      ? const Color.fromARGB(255, 19, 193, 4)
                      : const Color.fromARGB(255, 255, 0, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ));
  }
}
