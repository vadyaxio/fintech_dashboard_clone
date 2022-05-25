import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/layout/common_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        title: const Text('Профиль'),
      ),
      body: SafeArea(
        child: CommonLayout(
          content: Column(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
