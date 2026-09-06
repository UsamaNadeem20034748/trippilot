import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'plan_trip.dart';
import 'tracking.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPlanner(BuildContext context, {TripType? type}) {
    final draft = TripDraft();
    if (type != null) draft.type = type;
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlanTripScreen(draft: draft)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, box) {
          final columns = box.maxWidth > 700 ? 3 : 2;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning',
                          style: TextStyle(fontSize: 15, color: AppColors.muted),
                        ),
                        SizedBox(height: 2),
                        Text('Ayesha', style: T.h1),
                      ],
                    ),
                  ),
                  const Avatar(initials: 'AK', gradient: 4, size: 52),
                ],
              ),
              const SizedBox(height: 20),
              TpCard(
                onTap: () => _openPlanner(context),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.accent, size: 26),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Where are you going?', style: T.h3),
                          SizedBox(height: 3),
                          Text('Plan a trip and pick your driver', style: T.small),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Choose a trip type',
                action: 'See all',
                onAction: () => _openPlanner(context),
              ),
              const SizedBox(height: 4),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tripTypes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 148,
                ),
                itemBuilder: (context, i) {
                  final t = tripTypes[i];
                  return TpCard(
                    onTap: () => _openPlanner(context, type: t),
                    border: i == 0 ? AppColors.ink : null,
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.tileGradients[i % AppColors.tileGradients.length],
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(t.icon, color: Colors.white, size: 22),
                        ),
                        const Spacer(),
                        Text(t.name, style: T.title),
                        const SizedBox(height: 3),
                        Text(t.blurb, style: T.small, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Upcoming trip'),
              const SizedBox(height: 4),
              TpCard(
                child: Row(
                  children: [
                    const Avatar(initials: 'RM', gradient: 0, size: 48, verified: true),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sydney Airport T1 pickup', style: T.title),
                          SizedBox(height: 3),
                          Text(
                            'Today, 2:30 PM  .  Rahul M.  .  Lexus ES',
                            style: T.small,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        final draft = TripDraft()
                          ..driver = drivers[0]
                          ..type = tripTypes[1]
                          ..pickup = 'Sydney Airport T1, Mascot NSW 2020'
                          ..dropoff = '175 Pitt Street, Sydney NSW 2000'
                          ..startTime = const TimeOfDay(hour: 14, minute: 30);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TrackingScreen(draft: draft)),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.verifiedBg,
                        minimumSize: const Size(64, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Track',
                        style: TextStyle(
                          color: AppColors.verified,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
