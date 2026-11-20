import 'package:flight_app/features/flight_search/presentation/pages/passengers_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildPage() => const MaterialApp(home: PassengersPage());

  group('PassengersPage', () {
    testWidgets('adds an adult when + is tapped', (tester) async {
      // Arrange
      await tester.pumpWidget(buildPage());
      expect(find.text('1 Adult'), findsOneWidget);

      // Act
      await tester.tap(find.byTooltip('Increase 1 Adult'));
      await tester.pump();

      // Assert
      expect(find.text('2 Adults'), findsOneWidget);
      expect(find.text('1 Adult'), findsNothing);
    });

    testWidgets('disables - when there is only 1 adult', (tester) async {
      // Arrange
      await tester.pumpWidget(buildPage());

      // Assert
      final button = tester.widget<InkWell>(
        find.descendant(
          of: find.byTooltip('Decrease 1 Adult'),
          matching: find.byType(InkWell),
        ),
      );
      expect(button.onTap, isNull);
    });
  });
}