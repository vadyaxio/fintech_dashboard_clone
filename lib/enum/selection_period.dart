import 'package:maxbonus_index/models/dropdown_period.dart';

class SelectionPeriod {
  List<DropdownPeriod> getOptions() {
    final List<DropdownPeriod> _dropdownOptions = [
      DropdownPeriod(
          1,
          'Текущий день',
          DateTime.now().subtract(Duration(
              days: 1,
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second,
              milliseconds: DateTime.now().millisecond)),
          DateTime.now().subtract(Duration(
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second,
              milliseconds: DateTime.now().millisecond))),
      DropdownPeriod(
          2,
          'Предыдущий день',
          DateTime.now().subtract(Duration(
              days: 2,
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second,
              milliseconds: DateTime.now().millisecond)),
          DateTime.now().subtract(Duration(
              days: 1,
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second,
              milliseconds: DateTime.now().millisecond))),
      DropdownPeriod(
          3,
          'Текущая неделя',
          DateTime.now().subtract(Duration(
              days: DateTime.now().weekday - 1,
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second,
              milliseconds: DateTime.now().millisecond)),
          DateTime.now().add(
              Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))),
      DropdownPeriod(
          4,
          'Предыдущая неделя',
          DateTime.now().subtract(Duration(
              days: 7 + (DateTime.now().weekday - 1),
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second,
              milliseconds: DateTime.now().millisecond)),
          DateTime.now().subtract(Duration(
              days: DateTime.now().weekday,
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second,
              milliseconds: DateTime.now().millisecond))),
      DropdownPeriod(
          5,
          'Текущий месяц',
          DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
          DateTime.utc(
            DateTime.now().year,
            DateTime.now().month + 1,
          ).subtract(const Duration(days: 1))),
      DropdownPeriod(
          6,
          'Предыдущий месяц',
          DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 1),
          DateTime.utc(
            DateTime.now().year,
            DateTime.now().month,
          ).subtract(const Duration(days: 1)))
    ];

    return _dropdownOptions;
  }
}
