class Button {
  int index;
  String name;
  bool? disable;
  String? position;

  Button(this.index, this.name);

  Button.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        name = json['name'],
        disable = json['disable'],
        position = json['position'];
}
