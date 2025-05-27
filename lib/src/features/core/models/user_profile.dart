// lib/src/models/user_model.dart

class User {
  final String id;
  final String fullname;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullname: json['fullname'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'fullname': fullname, 'email': email, 'phone': phone};
  }
}
