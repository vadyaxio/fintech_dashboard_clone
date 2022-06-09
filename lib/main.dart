import 'package:maxbonus_index/screen/home.dart';
import 'package:maxbonus_index/screen/login.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';

bool hasJwt = false;

/// Used for Background Updates using Workmanager Plugin
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    final now = DateTime.now();
    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        'Updated from Background',
      ),
      HomeWidget.saveWidgetData(
        'message',
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      ),
      HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider',
          androidName: 'HomeWidgetExampleProvider',
          qualifiedAndroidName:
              'com.example.maxbonus_index.HomeWidgetExampleProvider'
          //iOSName: 'HomeWidgetExample',
          ),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

// Called when Doing Background Work initiated from Widget
Future<void> backgroundCallback(Uri? uri) async {
  if (uri!.host == 'updatecounter') {
    int _counter;
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0)
        .then((value) {
      _counter = value!;
      _counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', 1);
    await HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider',
        androidName: 'HomeWidgetExampleProvider',
        qualifiedAndroidName:
            'com.example.maxbonus_index.HomeWidgetExampleProvider'
        //iOSName: 'HomeWidgetExample'
        );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //HomeWidget.registerBackgroundCallback(backgroundCallback);
  //Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  hasJwt = await API().getJwt();
  await Hive.initFlutter();
  try {
    await Hive.openBox('common');
    await Hive.openBox('chart');
  } catch (e) {
    //print('Failed to open Hive');
  }
  runApp(const MaxbonusKPIApp());
}

class MaxbonusKPIApp extends StatelessWidget {
  const MaxbonusKPIApp({Key? key}) : super(key: key);

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
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 250, 102, 28)),
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
