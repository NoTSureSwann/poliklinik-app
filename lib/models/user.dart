class User {
  String? id;
  String name;
  String email;
  String password;
  String role;
  String phone;
  String gender;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.phone = '',
    this.gender = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      password: json["password"] ?? "",
      role: json["role"] ?? "pasien",
      phone: json["phone"] ?? "",
      gender: json["gender"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "phone": phone,
      "gender": gender,
    };
  }
}
