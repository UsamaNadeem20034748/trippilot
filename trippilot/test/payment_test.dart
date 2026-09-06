// The wallet holds AUD 120. A trip that costs more than that must not be
// payable from it, so the button is disabled and the reason is written out.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trippilot/data.dart';
import 'package:trippilot/screens/payment.dart';
import 'package:trippilot/widgets.dart';

void main() {
  testWidgets('the wallet is refused when it cannot cover the trip', (tester) async {
    final draft = TripDraft()..driver = drivers[0]; // total AUD 509
    await tester.pumpWidget(MaterialApp(home: PaymentScreen(draft: draft, checkout: true)));

    expect(draft.total, 509);
    expect(find.textContaining('not enough for this trip'), findsNothing);

    await tester.tap(find.text('TripPilot wallet'));
    await tester.pump();

    expect(find.textContaining('not enough for this trip'), findsOneWidget);
    final button = tester.widget<TextButton>(
      find.descendant(of: find.byType(PrimaryButton), matching: find.byType(TextButton)),
    );
    expect(button.onPressed, isNull, reason: 'paying from an empty wallet must be blocked');
  });

  testWidgets('the card is accepted for the same trip', (tester) async {
    final draft = TripDraft()..driver = drivers[0];
    await tester.pumpWidget(MaterialApp(home: PaymentScreen(draft: draft, checkout: true)));

    final button = tester.widget<TextButton>(
      find.descendant(of: find.byType(PrimaryButton), matching: find.byType(TextButton)),
    );
    expect(button.onPressed, isNotNull);
  });
}
