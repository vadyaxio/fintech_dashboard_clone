import 'package:flutter/material.dart';

class ModalBottomSheetLayout extends StatelessWidget {
  final Widget content;

  const ModalBottomSheetLayout({Key? key, required this.content})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            child: content));
  }
}
