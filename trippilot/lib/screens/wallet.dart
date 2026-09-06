import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _history = <List<String>>[
    ['Full day in Sydney', 'Sat, 22 Aug', '- AUD 433'],
    ['Promo TRIP15', 'Sat, 22 Aug', '+ AUD 76'],
    ['Sydney Airport drop off', '10 Aug', '- AUD 130'],
    ['Wallet top up', '2 Aug', '+ AUD 300'],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            children: [
              const Text('Wallet', style: T.h1),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF12153A), Color(0xFF3A3F70)]),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TripPilot balance',
                      style: TextStyle(
                        color: Color(0xFFB9BCD8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'AUD 120.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.credit_card_rounded, color: Color(0xFFB9BCD8), size: 17),
                        const SizedBox(width: 8),
                        const Text(
                          'Visa ending 4471',
                          style: TextStyle(color: Color(0xFFB9BCD8), fontSize: 13),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Top up needs a payment provider, not built here.'),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Top up',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Recent activity'),
              const SizedBox(height: 4),
              TpCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  children: [
                    for (var i = 0; i < _history.length; i++) ...[
                      if (i > 0) const Divider(height: 1, color: AppColors.line),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_history[i][0], style: T.value),
                                  const SizedBox(height: 3),
                                  Text(_history[i][1], style: T.small),
                                ],
                              ),
                            ),
                            Text(
                              _history[i][2],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _history[i][2].startsWith('+')
                                    ? AppColors.verified
                                    : AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
