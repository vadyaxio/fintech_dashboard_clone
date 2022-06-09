class UserFactor {
  int id;
  String factorName;
  bool isVisible;

  UserFactor(this.id, this.factorName, this.isVisible);

  UserFactor.fromJson(Map<String, dynamic> json)
      : id = json['id_factor'],
        factorName = json['factor_name'],
        isVisible = json['is_visible'];

  Map<String, dynamic> toJsonDate() =>
      {'id_factor': id, 'is_visible': isVisible};
}
