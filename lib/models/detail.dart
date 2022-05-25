class Detail {
  int key;
  String dKey;
  DateTime dateStart;
  DateTime dateEnd;
  double? value;

  Detail(this.key, this.dKey, this.dateStart, this.dateEnd);

  Detail.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        dKey = json['dKey'],
        dateStart = DateTime.parse(json['dateStart']),
        dateEnd = DateTime.parse(json['dateEnd']),
        value = (json['value'] as num).toDouble();
}
