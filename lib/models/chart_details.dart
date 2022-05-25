import 'package:maxbonus_index/models/chart.dart';
import 'package:maxbonus_index/models/detail.dart';

class ChartDetails {
  Chart chart;
  int periodType;
  List<Detail>? currentDetails;
  List<Detail>? prevDetails;
  Map<String, DateTime?> periodDate = {
    "begin": null,
    "end": null,
  };
  Map<String, DateTime?> compareDate = {
    "begin": null,
    "end": null,
  };

  ChartDetails(this.chart, this.periodType, this.periodDate, this.compareDate);

  ChartDetails.fromJson(Map<String, dynamic> json)
      : chart = Chart.fromJson(json['factor']),
        periodType = json['period_type'],
        currentDetails = (json['details']['current'] as List)
            .map((detailJson) => Detail.fromJson(detailJson))
            .toList(),
        prevDetails = (json['details']['prev'] as List)
            .map((detailJson) => Detail.fromJson(detailJson))
            .toList();

  Map<String, dynamic> toJsonDate() => {
        'period_type': periodType,
        'current_date': {
          'begin': periodDate['begin']?.toIso8601String(),
          'end': periodDate['end']?.toIso8601String(),
        },
        'prev_date': {
          'begin': compareDate['begin']?.toIso8601String(),
          'end': compareDate['end']?.toIso8601String(),
        }
      };
}
