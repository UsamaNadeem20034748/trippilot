import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'driver_detail.dart';

class DriversScreen extends StatefulWidget {
  final TripDraft draft;
  const DriversScreen({super.key, required this.draft});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

enum _Sort { bestMatch, topRated, lowestFare }

class _DriversScreenState extends State<DriversScreen> {
  _Sort _sort = _Sort.bestMatch;
  bool _sevenSeatsOnly = false;

  List<Driver> get _visible {
    final list = drivers.where((d) => !_sevenSeatsOnly || d.seats >= 7).toList();
    switch (_sort) {
      case _Sort.bestMatch:
        list.sort((a, b) => matchScore(b).compareTo(matchScore(a)));
      case _Sort.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _Sort.lowestFare:
        list.sort((a, b) => widget.draft.fareFor(a).compareTo(widget.draft.fareFor(b)));
    }
    return list;
  }

  double matchScore(Driver d) {
    return (d.rating * 100) + (d.trips * 0.02) - (widget.draft.fareFor(d) * 0.25);
  }

  @override
  Widget build(BuildContext context) {
    final list = _visible;
    return Scaffold(
      appBar: AppBar(
        leading: const BackChip(),
        title: Text('${list.length} ${list.length == 1 ? "driver" : "drivers"} near you'),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      TpChip(
                        label: 'Best match',
                        selected: _sort == _Sort.bestMatch,
                        onTap: () => setState(() => _sort = _Sort.bestMatch),
                      ),
                      TpChip(
                        label: 'Top rated',
                        selected: _sort == _Sort.topRated,
                        onTap: () => setState(() => _sort = _Sort.topRated),
                      ),
                      TpChip(
                        label: 'Lowest fare',
                        selected: _sort == _Sort.lowestFare,
                        onTap: () => setState(() => _sort = _Sort.lowestFare),
                      ),
                      TpChip(
                        label: '7 seats only',
                        selected: _sevenSeatsOnly,
                        onTap: () => setState(() => _sevenSeatsOnly = !_sevenSeatsOnly),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: list.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) => _DriverRow(
                            driver: list[i],
                            fare: widget.draft.fareFor(list[i]),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DriverDetailScreen(draft: widget.draft, driver: list[i]),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  final Driver driver;
  final int fare;
  final VoidCallback onTap;
  const _DriverRow({required this.driver, required this.fare, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TpCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(initials: driver.initials, gradient: driver.gradient, size: 54, verified: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(driver.name, style: T.title)),
                    const SizedBox(width: 8),
                    Text(
                      'AUD $fare',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Stars(
                  rating: driver.rating,
                  trailing: '${driver.rating}  .  ${driver.trips} trips',
                ),
                const SizedBox(height: 5),
                Text(
                  '${driver.car}  .  ${driver.colour}  .  ${driver.year}',
                  style: T.small,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    const VerifiedBadge(),
                    if (driver.seats >= 7) const VerifiedBadge(label: '7 seats'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 44, color: AppColors.muted),
          const SizedBox(height: 14),
          const Text('No driver matches that filter', style: T.h3, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Turn the seat filter off, or change the date and time on the trip you planned.',
            style: T.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
