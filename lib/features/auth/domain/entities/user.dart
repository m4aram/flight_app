import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.email, this.name});

  final String id;
  final String email;
  final String? name;

  /// Name if available, otherwise the part of the email before `@`.
  String get displayName =>
      (name != null && name!.trim().isNotEmpty)
          ? name!
          : email.split('@').first;

  @override
  List<Object?> get props => [id, email, name];
}
