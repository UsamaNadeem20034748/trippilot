// The fare calculator is the only real logic in the front end, so it gets a
// test. If these numbers change, the plan screen, the driver list and the
// review screen would all start disagreeing with each other.
import 'package:flutter_test/flutter_test.dart';
import 'package:trippilot/data.dart';

void main() {
  test('a default full day trip is priced the same as the prototype', () {
    final d = TripDraft();
    expect(d.type.name, 'Full day');
    expect(d.hours, 10);
    expect(d.baseFare, 480); // 48 AUD per hour x 10 hours
    expect(d.estimateLow, 480);
    expect(d.estimateHigh, 590); // the range shown in the footer of the plan screen
  });

  test('each driver is priced from the same base fare', () {
    final d = TripDraft();
    expect(d.fareFor(drivers[0]), 509); // Rahul Menon
    expect(d.fareFor(drivers[1]), 480); // Ahmed Zubair
    expect(d.fareFor(drivers[2]), 586); // Marta Nowak
  });

  test('extras and a seventh seat are added to the fare', () {
    final d = TripDraft()
      ..extras.add('Child seat')
      ..extras.add('Extra luggage')
      ..passengers = 6;
    expect(d.extrasFare, 35);
    expect(d.passengerFare, 45);
    expect(d.estimateLow, 560);
  });

  test('TRIP15 takes 15 per cent off and anything else takes nothing', () {
    final d = TripDraft()..driver = drivers[0];
    expect(d.driverFare, 509);

    d.promo = 'TRIP15';
    expect(d.discount, 76);
    expect(d.total, 433);

    d.promo = 'NOTACODE';
    expect(d.discount, 0);
    expect(d.total, 509);
  });

  test('the date and time labels are formatted for the screen', () {
    final d = TripDraft();
    expect(d.dateLabel, 'Sat, 22 Aug');
    expect(d.timeLabel, '8:00 AM');
  });

  test('a cheaper driver is a discount, not a negative charge', () {
    final d = TripDraft()..driver = drivers[3]; // Sana Iqbal, rateFactor 0.94
    expect(d.driverFare, 451);
    // The review screen shows this difference as a discount line, so it must be
    // read as a positive amount rather than printed as a negative charge.
    expect(d.estimateLow - d.driverFare, 29);
    expect(d.driverFare < d.estimateLow, isTrue);
  });

  test('a driver charging the base fare adds no line at all', () {
    final d = TripDraft()..driver = drivers[1]; // Ahmed Zubair, rateFactor 1.00
    expect(d.driverFare, d.estimateLow);
  });
}
