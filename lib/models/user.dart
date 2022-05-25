class User {
  final String username;
  final String? password;
  String? name;
  String? email;
  int? partnerID;

  User(this.username, this.password);

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        email = json['email'],
        name = json['name'],
        partnerID = json['partner_id_partner'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
