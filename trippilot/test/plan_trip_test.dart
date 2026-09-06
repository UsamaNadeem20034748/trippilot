// Opening the place picker and choosing a place used to throw a
// "_dependents.isEmpty" assertion, because the search field's controller was
// disposed while the sheet was still closing. This test walks that path.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trippilot/data.dart';
import 'package:trippilot/screens/plan_trip.dart';

void main() {
  testWidgets('choosing a saved place updates the pickup field', (tester) async {
    final draft = TripDraft();
    await tester.pumpWidget(MaterialApp(home: PlanTripScreen(draft: draft)));

    await tester.tap(find.text('175 Pitt Street, Sydney NSW 2000'));
    await tester.pumpAndSettle();
    expect(find.text('Pickup point'), findsOneWidget);

    // Scroll the saved place list down to the Australian addresses, then
    // choose one and let the sheet close.
    await tester.dragUntilVisible(
      find.text('Circular Quay, Sydney NSW 2000'),
      find.descendant(of: find.byType(BottomSheet), matching: find.byType(ListView)),
      const Offset(0, -80),
    );
    await tester.tap(find.text('Circular Quay, Sydney NSW 2000').last);
    await tester.pumpAndSettle();

    expect(draft.pickup, 'Circular Quay, Sydney NSW 2000');
    expect(tester.takeException(), isNull);
  });

  testWidgets('the fare in the footer follows the extras that are selected', (tester) async {
    final draft = TripDraft();
    await tester.pumpWidget(MaterialApp(home: PlanTripScreen(draft: draft)));

    expect(find.text('AUD 480 to 590'), findsOneWidget);

    // The extras sit below the fold in the test window, so scroll to them.
    await tester.dragUntilVisible(
      find.text('Child seat  +AUD 20'),
      find.byType(ListView),
      const Offset(0, -120),
    );
    // Scroll a little further so the chip is clear of the sticky footer.
    await tester.drag(find.byType(ListView), const Offset(0, -140));
    await tester.pump();

    await tester.tap(find.text('Child seat  +AUD 20'));
    await tester.pump();

    expect(draft.extras.contains('Child seat'), isTrue);
    expect(draft.estimateLow, 500);
    expect(find.text('AUD 500 to 610'), findsOneWidget);
  });
}
