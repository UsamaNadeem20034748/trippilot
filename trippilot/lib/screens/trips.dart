import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'plan_trip.dart';
import 'tracking.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  bool _upcoming = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(children: [Text('Your trips', style: T.h1)]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                child: Row(
                  children: [
                    TpChip(
                      label: 'Upcoming',
                      selected: _upcoming,
                      onTap: () => setState(() => _upcoming = true),
                    ),
                    const SizedBox(width: 10),
                    TpChip(
                      label: 'Past',
                      selected: !_upcoming,
                      onTap: () => setState(() => _upcoming = false),
                    ),
                  ],
                ),
              ),
              Expanded(child: _upcoming ? _upcomingList(context) : _pastList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upcomingList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        Row(
          children: [
            const VerifiedBadge(label: 'Confirmed'),
            const Spacer(),
            Text('Sat, 22 Aug', style: T.small),
          ],
        ),
        const SizedBox(height: 10),
        TpCard(
          onTap: () {
            final draft = TripDraft()..driver = drivers[0];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TrackingScreen(draft: draft)),
            );
          },
          child: Row(
            children: [
              const Avatar(initials: 'RM', gradient: 0, size: 50, verified: true),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full day in Sydney', style: T.title),
                    SizedBox(height: 3),
                    Text(
                      'Rahul M.  .  Lexus ES  .  8:00 AM',
                      style: T.small,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: SizedBox(
            width: 240,
            child: SecondaryButton(
              label: 'Plan another trip',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlanTripScreen(draft: TripDraft())),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pastList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: pastTrips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final t = pastTrips[i];
        return TpCard(
          child: Row(
            children: [
              Avatar(initials: t.initials, gradient: t.gradient, size: 48),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.title, style: T.title),
                    const SizedBox(height: 3),
                    Text(t.detail, style: T.small),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 15, color: AppColors.star),
                  const SizedBox(width: 3),
                  Text('${t.rating}', style: T.value),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
