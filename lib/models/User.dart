import 'dart:convert';

class User {
  final String userId;
  late final bool isRegistered;

  User({required this.userId, required this.isRegistered});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'isRegistered': isRegistered,
      };

 factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      isRegistered: json['isRegistered'],
    );
  }
  
}