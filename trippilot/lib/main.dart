import 'package:flutter/material.dart';

import 'theme.dart';
import 'screens/onboarding.dart';

void main() {
  runApp(const TripPilotApp());
}

class TripPilotApp extends StatelessWidget {
  const TripPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripPilot',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const OnboardingScreen(),
    );
  }
}
