import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'confirm.dart';

class PaymentScreen extends StatefulWidget {
  final TripDraft draft;
  final bool checkout;
  const PaymentScreen({super.key, required this.draft, this.checkout = false});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String _selected = widget.draft.payMethod;

  static const _walletBalance = 120;

  static const _methods = <List<String>>[
    ['Visa ending 4471', 'Expires 08/27'],
    ['TripPilot wallet', 'AUD $_walletBalance available'],
    ['Cash to driver', 'Pay at the end of the trip'],
  ];

  static const _icons = <IconData>[
    Icons.credit_card_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.payments_rounded,
  ];

  bool get _walletTooLow => _selected == 'TripPilot wallet' && widget.draft.total > _walletBalance;

  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
    return Scaffold(
      appBar: AppBar(leading: const BackChip(), title: const Text('Payment')),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
              children: [
                const Text(
                  'Choose how to pay. You are only charged after the trip ends.',
                  style: T.body,
                ),
                const SizedBox(height: 18),
                for (var i = 0; i < _methods.length; i++) ...[
                  TpCard(
                    onTap: () => setState(() => _selected = _methods[i][0]),
                    border: _selected == _methods[i][0] ? AppColors.ink : null,
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: AppColors.tileGradients[i]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_icons[i], color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_methods[i][0], style: T.title),
                              const SizedBox(height: 3),
                              Text(_methods[i][1], style: T.small),
                            ],
                          ),
                        ),
                        Icon(
                          _selected == _methods[i][0]
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: _selected == _methods[i][0] ? AppColors.accent : AppColors.line,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TpCard(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adding a card is part of the back end, not built here.'),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_rounded, color: AppColors.accent),
                      SizedBox(width: 12),
                      Text('Add a new card', style: T.value),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.verifiedBg,
                    borderRadius: BorderRadius.circular(AppRadius.field),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_rounded, size: 18, color: AppColors.verified),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Protected payment',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.verified,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Card details are encrypted, never shared.',
                              style: TextStyle(fontSize: 12.5, color: AppColors.verified),
                            ),
                          ],
                        ),
                      ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Total due', style: T.label)),
                Text('AUD ${d.total}', style: T.h3),
              ],
            ),
            if (_walletTooLow)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'The wallet holds AUD $_walletBalance, which is not enough for '
                        'this trip. Choose the card or pay cash.',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: widget.checkout ? 'Pay AUD ${d.total}' : 'Use $_selected',
              onPressed: _walletTooLow
                  ? null
                  : () {
                      d.payMethod = _selected;
                      if (widget.checkout) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ConfirmScreen(draft: d)),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
