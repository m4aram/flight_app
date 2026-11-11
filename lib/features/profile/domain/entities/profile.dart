import 'package:equatable/equatable.dart';

enum Gender { male, female }

class Profile extends Equatable {
  const Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender,
    this.dateOfBirth,
    this.nationality,
  });

  final String firstName;
  final String lastName;
  final String email;
  final Gender? gender;
  final DateTime? dateOfBirth;
  final String? nationality;

  String get fullName => '$firstName $lastName'.trim();

  bool get isComplete =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      email.isNotEmpty &&
      gender != null &&
      dateOfBirth != null &&
      nationality != null;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    gender,
    dateOfBirth,
    nationality,
  ];
}
