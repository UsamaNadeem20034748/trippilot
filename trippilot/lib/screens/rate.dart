import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'shell.dart';

class RateScreen extends StatefulWidget {
  final TripDraft draft;
  const RateScreen({super.key, required this.draft});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int _stars = 0;
  int? _tip;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.draft.driver ?? drivers[0];
    return Scaffold(
      appBar: AppBar(leading: const BackChip(), title: const Text('')),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Avatar(
                      initials: driver.initials,
                      gradient: driver.gradient,
                      size: 78,
                      verified: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'How was your trip\nwith ${driver.name.split(" ").first}?',
                    style: T.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your rating keeps the network trusted for everyone.',
                    style: T.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 1; i <= 5; i++)
                        IconButton(
                          tooltip: '$i star${i == 1 ? "" : "s"}',
                          onPressed: () => setState(() => _stars = i),
                          iconSize: 40,
                          icon: Icon(
                            i <= _stars ? Icons.star_rounded : Icons.star_border_rounded,
                            color: AppColors.star,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Add a tip'),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      for (final amount in [10, 20, 30])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TpCard(
                              onTap: () => setState(() => _tip = _tip == amount ? null : amount),
                              border: _tip == amount ? AppColors.ink : null,
                              radius: AppRadius.field,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(child: Text('AUD $amount', style: T.value)),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'Leave a note'),
                  const SizedBox(height: 4),
                  TpCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: TextField(
                      controller: _note,
                      minLines: 2,
                      maxLines: 4,
                      style: T.value,
                      decoration: const InputDecoration(
                        hintText: 'Smooth drive and very polite. Thank you.',
                        hintStyle: T.small,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _tip == null ? 'Submit rating' : 'Submit rating and AUD $_tip tip',
                    onPressed: _stars == 0
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Thank you. $_stars stars sent to ${driver.name}.'),
                              ),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeShell(startTab: 1)),
                              (route) => false,
                            );
                          },
                  ),
                  if (_stars == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Choose a star rating to continue.',
                        style: T.small,
                        textAlign: TextAlign.center,
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
