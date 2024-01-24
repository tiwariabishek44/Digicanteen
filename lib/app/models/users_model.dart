class UserModel {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String groupid;
  final String classes;

  UserModel({
    required this.classes,
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.groupid,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      userid:
          json['userid'] ?? '', // Provide a default value if 'userid' is null
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ??
          '', // Convert to String and provide default value
      groupid: json['groupid'] ?? '',
      classes: json['classes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'phone': phone,
      'groupid': groupid,
      'classes': classes,
    };
  }
}
