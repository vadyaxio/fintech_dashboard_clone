import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/layout/common_layout.dart';
import 'package:maxbonus_index/responsive.dart';
import 'package:maxbonus_index/styles/styles.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int activeTab = 0;

  void checkJWT() async {
    API().homeApi().then((result) => {
          print(result),
          Future(() {
            Navigator.of(context).popAndPushNamed('login');
          })
        });
  }

  void getUser() {
    dynamic qqq = Hive.box("common").get("user");
    print(qqq);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CommonLayout(
          content: Row(
            children: [
              // Main Panel
              Expanded(
                child: Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      onPressed: checkJWT,
                      child: Text('Разлогиниться'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      onPressed: getUser,
                      child: Text('Инфа'),
                    )
                  ],
                ),
                flex: 5,
              ),
              // Right Panel
              Visibility(
                visible: Responsive.isDesktop(context),
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: Styles.defaultPadding),
                    child: Column(
                      children: [
                        Text('123'),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
