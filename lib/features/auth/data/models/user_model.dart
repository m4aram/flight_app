import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.email, super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
}

/// What the login API returns.
class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final UserModel user;
}
