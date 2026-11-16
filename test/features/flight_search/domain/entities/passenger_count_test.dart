import 'package:flight_app/features/flight_search/domain/entities/passenger_count.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PassengerCount', () {
    test('starts with 1 adult, 0 children and 0 infants', () {
      const passengers = PassengerCount();

      // One test can check more than one thing
      expect(passengers.adults, 1);
      expect(passengers.children, 0);
      expect(passengers.infants, 0);
    });

    test('cannot go below 1 adult', () {
      // Arrange
      const passengers = PassengerCount();

      // Act: try to remove the only adult
      final result = passengers.decrement(PassengerType.adult);

      // Assert: still 1 adult
      expect(result.adults, 1);
    });
    test('cannot go above 9 seats', () {
      // Arrange
      const passengers = PassengerCount(adults: 9);

      // Act: try to remove the only adult
      final result = passengers.increment(PassengerType.adult);

      // Assert: still 1 adult
      expect(result.adults, 9);
    });

    test('cannot have more infants than adults', () {
      // Arrange
      const passengers = PassengerCount();


      // Act: try to remove the only adult
      final result = passengers.increment(PassengerType.infant)
          .increment(PassengerType.infant);

      // Assert: still 1 adult
      expect(result.infants, 1);
    });
    test('cannot remove an adult when every adult holds an infant', () {
      // Arrange: 2 adults, 2 infants
      const passengers = PassengerCount(adults: 2, infants: 2);

      // Act
      final result = passengers.canDecrement(PassengerType.adult);

      // Assert
      expect(result, isFalse);
    });

    test('label shows plural and singular correctly', () {
      // Arrange: 2 adults, 2 infants
      const passengers = PassengerCount(adults: 2, children: 1, infants: 1);

      // Act
      final result = passengers.label;

      // Assert
      expect(result, '2 Adults, 1 Child, 1 Infant');
    });
  });

}