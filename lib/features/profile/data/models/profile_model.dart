import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    super.gender,
    super.dateOfBirth,
    super.nationality,
  });

  factory ProfileModel.fromEntity(Profile p) => ProfileModel(
    firstName: p.firstName,
    lastName: p.lastName,
    email: p.email,
    gender: p.gender,
    dateOfBirth: p.dateOfBirth,
    nationality: p.nationality,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final genderName = json['gender'] as String?;
    final dob = json['date_of_birth'] as String?;
    return ProfileModel(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      gender: Gender.values.where((g) => g.name == genderName).firstOrNull,
      dateOfBirth: dob == null ? null : DateTime.tryParse(dob),
      nationality: json['nationality'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'gender': gender?.name,
    'date_of_birth': dateOfBirth?.toIso8601String(),
    'nationality': nationality,
  };
}
