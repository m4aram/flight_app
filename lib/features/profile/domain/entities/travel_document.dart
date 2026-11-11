import 'package:equatable/equatable.dart';

enum DocumentType {
  passport('Passport'),
  nationalId('National ID');

  const DocumentType(this.label);

  final String label;
}

class TravelDocument extends Equatable {
  const TravelDocument({
    required this.type,
    required this.number,
    required this.issuingCountry,
    required this.expiryDate,
  });

  final DocumentType type;
  final String number;
  final String issuingCountry;
  final DateTime expiryDate;

  bool get isExpired => expiryDate.isBefore(DateTime.now());

  /// `****5678`: shows only the last 4 characters.
  String get maskedNumber {
    if (number.length <= 4) return number;
    return '${'*' * (number.length - 4)}${number.substring(number.length - 4)}';
  }

  @override
  List<Object?> get props => [type, number, issuingCountry, expiryDate];

  // Never print the full document number.
  @override
  String toString() => 'TravelDocument(${type.name}, $maskedNumber)';
}
