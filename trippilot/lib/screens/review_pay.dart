import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'payment.dart';

class ReviewPayScreen extends StatefulWidget {
  final TripDraft draft;
  const ReviewPayScreen({super.key, required this.draft});

  @override
  State<ReviewPayScreen> createState() => _ReviewPayScreenState();
}

class _ReviewPayScreenState extends State<ReviewPayScreen> {
  final _promo = TextEditingController();
  String? _promoMessage;

  @override
  void initState() {
    super.initState();
    _promo.text = widget.draft.promo;
  }

  @override
  void dispose() {
    _promo.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promo.text.trim().toUpperCase();
    setState(() {
      widget.draft.promo = code;
      if (code.isEmpty) {
        _promoMessage = null;
      } else if (widget.draft.discount > 0) {
        _promoMessage = 'TRIP15 applied, 15 per cent off this trip.';
      } else {
        _promoMessage = '$code is not a code we recognise.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
    final driver = d.driver!;
    return Scaffold(
      appBar: AppBar(leading: const BackChip(), title: const Text('Review & pay')),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
              children: [
                TpCard(
                  child: Row(
                    children: [
                      Avatar(
                        initials: driver.initials,
                        gradient: driver.gradient,
                        size: 52,
                        verified: true,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driver.name, style: T.title),
                            const SizedBox(height: 3),
                            Text(
                              '${driver.car}  .  ${d.type.name}  .  ${d.hours} hours',
                              style: T.small,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 15, color: AppColors.star),
                          const SizedBox(width: 3),
                          Text('${driver.rating}', style: T.value),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TpCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${d.pickup}  to  ${d.dropoff}', style: T.value),
                      const SizedBox(height: 6),
                      Text(
                        '${d.dateLabel}  .  ${d.timeLabel}  .  ${d.passengers} passengers',
                        style: T.small,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Fare summary'),
                const SizedBox(height: 4),
                TpCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      MoneyRow(
                        label: '${d.type.name}, ${d.hours} hours',
                        amount: 'AUD ${d.baseFare}',
                      ),
                      for (final e in extrasCatalogue)
                        if (d.extras.contains(e.name))
                          MoneyRow(label: e.name, amount: e.price == 0 ? 'Free' : 'AUD ${e.price}'),
                      if (d.passengerFare > 0)
                        MoneyRow(label: '7 seat car', amount: 'AUD ${d.passengerFare}'),
                      if (d.driverFare > d.estimateLow)
                        MoneyRow(
                          label: 'Driver rate, ${driver.name}',
                          amount: 'AUD ${d.driverFare - d.estimateLow}',
                        ),
                      if (d.driverFare < d.estimateLow)
                        MoneyRow(
                          label: 'Driver discount, ${driver.name}',
                          amount: '- AUD ${d.estimateLow - d.driverFare}',
                          colour: AppColors.verified,
                        ),
                      if (d.discount > 0)
                        MoneyRow(
                          label: 'Promo ${d.promo}',
                          amount: '- AUD ${d.discount}',
                          colour: AppColors.verified,
                        ),
                      const Divider(color: AppColors.line, height: 20),
                      MoneyRow(label: 'Total', amount: 'AUD ${d.total}', bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TpCard(
                        radius: AppRadius.field,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        child: TextField(
                          controller: _promo,
                          textCapitalization: TextCapitalization.characters,
                          style: T.value,
                          onSubmitted: (_) => _applyPromo(),
                          decoration: const InputDecoration(
                            hintText: 'Promo code',
                            hintStyle: T.small,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _applyPromo,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.card,
                          foregroundColor: AppColors.ink,
                          side: const BorderSide(color: AppColors.line, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.field),
                          ),
                        ),
                        child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                if (_promoMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Icon(
                          d.discount > 0
                              ? Icons.check_circle_outline_rounded
                              : Icons.error_outline_rounded,
                          size: 16,
                          color: d.discount > 0 ? AppColors.verified : AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _promoMessage!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: d.discount > 0 ? AppColors.verified : AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Pay with'),
                const SizedBox(height: 4),
                TpCard(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentScreen(draft: d)),
                    );
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card_rounded, color: AppColors.ink),
                      const SizedBox(width: 12),
                      Expanded(child: Text(d.payMethod, style: T.value)),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
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
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Confirm and pay AUD ${d.total}',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentScreen(draft: d, checkout: true)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
