import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'shell.dart';
import 'tracking.dart';

class ConfirmScreen extends StatelessWidget {
  final TripDraft draft;
  const ConfirmScreen({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    final driver = draft.driver!;
    const code = '4192';
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.verifiedBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.check_rounded, size: 38, color: AppColors.verified),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text('You are all set', style: T.h1, textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    '${driver.name.split(" ").first} arrives at ${draft.pickup} on '
                    '${draft.dateLabel}, ${draft.timeLabel}.',
                    style: T.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Share this code with your driver',
                    style: T.label,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final digit in code.split(''))
                        Container(
                          width: 54,
                          height: 62,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(AppRadius.field),
                            border: Border.all(color: AppColors.line),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            digit,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  TpCard(
                    child: Row(
                      children: [
                        Avatar(
                          initials: driver.initials,
                          gradient: driver.gradient,
                          size: 50,
                          verified: true,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(driver.name, style: T.title),
                              const SizedBox(height: 3),
                              Text('${driver.car}  .  ${driver.colour}', style: T.small),
                            ],
                          ),
                        ),
                        Text('AUD ${draft.total}', style: T.h3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  PrimaryButton(
                    label: 'Track your driver',
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => TrackingScreen(draft: draft)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Back to home',
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeShell()),
                      (route) => false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
