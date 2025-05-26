class UserProfile {
  final String fullname;
  final String phone;

  UserProfile({required this.fullname, required this.phone});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(fullname: json['fullname'], phone: json['phone']);
  }
}
