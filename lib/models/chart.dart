class Chart {
  int id;
  String factorName;
  String? description;
  double? factCurrent;
  double? factPrev;
  double? factDynamic;
  Map<String, DateTime?> periodDate = {
    "begin": null,
    "end": null,
  };
  Map<String, DateTime?> compareDate = {
    "begin": null,
    "end": null,
  };

  Chart(this.id, this.factorName, this.periodDate, this.compareDate);

  Chart.fromJson(Map<String, dynamic> json)
      : id = json['id_factor'],
        factorName = json['factor_name'],
        factCurrent = (json['fact_current'] as num).toDouble(),
        factPrev = (json['fact_prev'] as num).toDouble(),
        factDynamic = (json['dynamic'] as num).toDouble(),
        description = json['description'];

  Map<String, dynamic> toJsonDate() => {
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
