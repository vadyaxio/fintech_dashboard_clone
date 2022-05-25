import 'package:flutter/material.dart';
import 'package:maxbonus_index/responsive.dart';

class CommonLayout extends StatelessWidget {
  final Widget content;

  const CommonLayout({Key? key, required this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            )),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0), //child: content
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 100),
                        child: IntrinsicHeight(child: content))),
              ),
            ),
          ],
        ),
      ),
      desktop: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(height: 100, child: TopAppBar()),
                  Expanded(child: content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
