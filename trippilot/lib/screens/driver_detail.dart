import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'review_pay.dart';

class DriverDetailScreen extends StatelessWidget {
  final TripDraft draft;
  final Driver driver;
  const DriverDetailScreen({super.key, required this.draft, required this.driver});

  @override
  Widget build(BuildContext context) {
    final fare = draft.fareFor(driver);
    return Scaffold(
      appBar: AppBar(leading: const BackChip(), title: const Text('Driver & car')),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
              children: [
                Row(
                  children: [
                    Avatar(
                      initials: driver.initials,
                      gradient: driver.gradient,
                      size: 68,
                      verified: true,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver.name, style: T.h2),
                          const SizedBox(height: 6),
                          Stars(
                            rating: driver.rating,
                            trailing:
                                '${driver.rating}  .  ${driver.trips} trips  .  ${driver.years} yrs',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Verification'),
                const SizedBox(height: 4),
                TpCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Column(
                    children: [
                      for (var i = 0; i < verificationChecks.length; i++) ...[
                        if (i > 0) const Divider(height: 1, color: AppColors.line),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(verificationChecks[i][0], style: T.value),
                                    const SizedBox(height: 3),
                                    Text(verificationChecks[i][1], style: T.small),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              const VerifiedBadge(label: 'Passed'),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'The car'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _Spec(label: 'Model', value: driver.car),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Spec(label: 'Year', value: driver.year),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _Spec(label: 'Seats', value: '${driver.seats} adults'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TpCard(
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.verified),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('${draft.type.name} fare  .  AUD $fare fixed', style: T.value),
                      ),
                      const VerifiedBadge(label: 'No surge'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: StickyFooter(
        child: PrimaryButton(
          label: 'Select this driver',
          onPressed: () {
            draft.driver = driver;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReviewPayScreen(draft: draft)),
            );
          },
        ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  final String label;
  final String value;
  const _Spec({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return TpCard(
      radius: AppRadius.field,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: T.label),
          const SizedBox(height: 3),
          Text(value, style: T.value, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
