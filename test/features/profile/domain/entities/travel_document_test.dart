import 'package:flight_app/features/profile/domain/entities/travel_document.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a passport with the given number. Other fields don't matter here.
TravelDocument passportWith(String number) {
  return TravelDocument(
    type: DocumentType.passport,
    number: number,
    issuingCountry: 'Yemen',
    expiryDate: DateTime(2030),
  );
}

void main() {
  group('TravelDocument.maskedNumber', () {
    test('hides everything except the last 4 characters', () {
      final document = passportWith('A12345678');

      final result = document.maskedNumber;

      expect(result, '*****5678');
    });
    test('masks a 5-character number', () {
      final document = passportWith('12345');

      final result = document.maskedNumber;

      expect(result, '*2345');
    });
    test('shows a 4-character number as it is',() {
      final document = passportWith('1234');

      final result = document.maskedNumber;

      expect(result, '1234');
    });
    });

}
