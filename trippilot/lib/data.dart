import 'package:flutter/material.dart';

class TripType {
  final String name;
  final String blurb;
  final IconData icon;
  final int ratePerHour;
  const TripType(this.name, this.blurb, this.icon, this.ratePerHour);
}

const tripTypes = <TripType>[
  TripType('Full day', 'Driver for 8 to 12 hours', Icons.schedule_rounded, 48),
  TripType('Airport', 'Pickup or drop off', Icons.flight_takeoff_rounded, 55),
  TripType('Outstation', 'Long distance trip', Icons.alt_route_rounded, 62),
  TripType('Business', 'Meetings and events', Icons.work_outline_rounded, 58),
  TripType('Family', '7 seats, child seat', Icons.family_restroom_rounded, 52),
  TripType('Custom', 'Build your itinerary', Icons.tune_rounded, 50),
];

class Extra {
  final String name;
  final int price;
  const Extra(this.name, this.price);
}

const extrasCatalogue = <Extra>[
  Extra('Child seat', 20),
  Extra('Extra luggage', 15),
  Extra('English speaking', 0),
  Extra('Non smoking', 0),
];

class Driver {
  final String name;
  final String initials;
  final double rating;
  final int trips;
  final int years;
  final String car;
  final String colour;
  final String year;
  final int seats;
  final String plate;
  final double rateFactor;
  final int gradient;
  const Driver({
    required this.name,
    required this.initials,
    required this.rating,
    required this.trips,
    required this.years,
    required this.car,
    required this.colour,
    required this.year,
    required this.seats,
    required this.plate,
    required this.rateFactor,
    required this.gradient,
  });
}

const drivers = <Driver>[
  Driver(
    name: 'Rahul Menon',
    initials: 'RM',
    rating: 4.9,
    trips: 1208,
    years: 6,
    car: 'Lexus ES',
    colour: 'Pearl white',
    year: '2023',
    seats: 4,
    plate: 'BXK 42B',
    rateFactor: 1.06,
    gradient: 0,
  ),
  Driver(
    name: 'Ahmed Zubair',
    initials: 'AZ',
    rating: 4.8,
    trips: 946,
    years: 4,
    car: 'Toyota Camry',
    colour: 'Silver',
    year: '2022',
    seats: 4,
    plate: 'CQA 88J',
    rateFactor: 1.00,
    gradient: 1,
  ),
  Driver(
    name: 'Marta Nowak',
    initials: 'MN',
    rating: 5.0,
    trips: 512,
    years: 3,
    car: 'Kia Carnival',
    colour: 'Graphite',
    year: '2023',
    seats: 7,
    plate: 'DTR 15L',
    rateFactor: 1.22,
    gradient: 4,
  ),
  Driver(
    name: 'Sana Iqbal',
    initials: 'SI',
    rating: 4.7,
    trips: 388,
    years: 2,
    car: 'Hyundai Sonata',
    colour: 'Midnight blue',
    year: '2022',
    seats: 4,
    plate: 'EJP 60N',
    rateFactor: 0.94,
    gradient: 2,
  ),
];

const verificationChecks = <List<String>>[
  ['Government ID', 'Australian photo ID confirmed'],
  ['Driving licence', 'Valid until 2029'],
  ['Background check', 'National police check on file'],
  ['Car inspection', 'Checked 4 days ago'],
];

class PastTrip {
  final String initials;
  final String title;
  final String detail;
  final double rating;
  final int gradient;
  const PastTrip(this.initials, this.title, this.detail, this.rating, this.gradient);
}

const pastTrips = <PastTrip>[
  PastTrip('AZ', 'Sydney Airport T1 drop off', '10 Aug  .  AUD 130', 5.0, 1),
  PastTrip('MN', 'Canberra outstation', '28 Jul  .  AUD 640', 4.9, 4),
  PastTrip('SI', 'Melbourne CBD pickup', '19 Jul  .  AUD 295', 4.7, 2),
  PastTrip('RM', 'Full day, business', '14 Jul  .  AUD 509', 4.8, 0),
];

class TripDraft {
  TripType type = tripTypes[0];
  String pickup = '175 Pitt Street, Sydney NSW 2000';
  String dropoff = 'Sydney Airport T1, Mascot NSW 2020';
  DateTime date = DateTime(2026, 8, 22);
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  int hours = 10;
  int passengers = 3;
  Set<String> extras = <String>{};
  String notes = '';
  Driver? driver;
  String promo = '';
  String payMethod = 'Visa ending 4471';

  int get baseFare => type.ratePerHour * hours;

  int get extrasFare {
    var total = 0;
    for (final e in extrasCatalogue) {
      if (extras.contains(e.name)) total += e.price;
    }
    return total;
  }

  int get passengerFare => passengers > 4 ? 45 : 0;

  int get estimateLow => baseFare + extrasFare + passengerFare;
  int get estimateHigh => estimateLow + 110;

  int fareFor(Driver d) => (estimateLow * d.rateFactor).round();

  int get driverFare => driver == null ? estimateLow : fareFor(driver!);

  int get discount => promo.toUpperCase() == 'TRIP15' ? (driverFare * 0.15).round() : 0;

  int get total => driverFare - discount;

  String get dateLabel {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  String get timeLabel {
    final h = startTime.hourOfPeriod == 0 ? 12 : startTime.hourOfPeriod;
    final m = startTime.minute.toString().padLeft(2, '0');
    final period = startTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }
}
