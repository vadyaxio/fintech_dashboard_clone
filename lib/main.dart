import 'package:maxbonus_index/screen/home.dart';
import 'package:maxbonus_index/screen/login.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

bool hasJwt = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  hasJwt = await API().getJwt();
  await Hive.initFlutter();
  try {
    await Hive.openBox('common');
  } catch (e) {
    print('Failed to open Hive');
  }
  runApp(const FintechDasboardApp());
}

class FintechDasboardApp extends StatelessWidget {
  const FintechDasboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''),
      ],
      locale: const Locale('ru'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
        scrollbarTheme: Styles.scrollbarTheme,
        primaryColor: const Color.fromARGB(255, 250, 102, 28),
        dialogBackgroundColor: const Color.fromARGB(31, 156, 156, 156),
        hintColor: Colors.black54,
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(8)),
          // ),
          floatingLabelStyle: TextStyle(color: Colors.black54),
          fillColor: Color.fromARGB(31, 156, 156, 156),
          filled: true,
        ),
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: const Color.fromARGB(255, 250, 102, 28)),
      ),
      initialRoute: hasJwt ? "/" : "login",
      routes: {
        '/': (context) => const HomePage(),
        "login": (context) => const LoginPage(),
      },
      //home: hasJwt ? const HomePage() : const LoginApp(),
      // home: const HomePage(),
    );
  }
}
