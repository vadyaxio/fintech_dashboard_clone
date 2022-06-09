import 'package:flutter/material.dart';

class ModalBottomSheetLayout extends StatelessWidget {
  final Widget content;
  final double heightFactor;

  const ModalBottomSheetLayout(
      {Key? key, required this.content, required this.heightFactor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: heightFactor,
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
