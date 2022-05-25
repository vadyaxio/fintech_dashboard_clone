import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class LocalizedDateTimeFactory extends charts.LocalDateTimeFactory {
  final Locale locale;

  @override
  DateFormat createDateFormat(String? pattern) {
    return DateFormat(pattern, locale.languageCode);
  }

  LocalizedDateTimeFactory(this.locale);
}
