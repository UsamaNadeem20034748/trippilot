import 'package:flutter/material.dart';

import 'theme.dart';

class TpCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? border;
  const TpCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = AppRadius.card,
    this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border ?? AppColors.line, width: border == null ? 1 : 2),
      ),
      child: child,
    );
    if (onTap == null) return box;
    return Semantics(
      button: true,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(radius), child: box),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.button),
          gradient: onPressed == null
              ? null
              : const LinearGradient(colors: [AppColors.accent, AppColors.accent2]),
          color: onPressed == null ? AppColors.line : null,
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: AppColors.muted,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const SecondaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.line, width: 1.5),
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class TpChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const TpChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: selected ? AppColors.ink : AppColors.line, width: 1.5),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final String initials;
  final int gradient;
  final double size;
  final bool verified;
  const Avatar({
    super.key,
    required this.initials,
    required this.gradient,
    this.size = 52,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + (verified ? 6 : 0),
      height: size + (verified ? 6 : 0),
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.tileGradients[gradient]),
              borderRadius: BorderRadius.circular(size * 0.28),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                fontSize: size * 0.34,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          if (verified)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.verified,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: const Icon(Icons.check_rounded, size: 11, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  final String label;
  const VerifiedBadge({super.key, this.label = 'Verified'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.verifiedBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 13, color: AppColors.verified),
          const SizedBox(width: 5),
          Text(label, style: T.badge),
        ],
      ),
    );
  }
}

class Stars extends StatelessWidget {
  final double rating;
  final String? trailing;
  const Stars({super.key, required this.rating, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$rating out of 5 stars',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              i <= rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
              size: 15,
              color: AppColors.star,
            ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              trailing ?? rating.toString(),
              style: T.small,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class FieldTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final VoidCallback? onTap;
  const FieldTile({super.key, required this.label, required this.value, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TpCard(
      onTap: onTap,
      radius: AppRadius.field,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: T.label),
                const SizedBox(height: 3),
                Text(value, style: T.value, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (onTap != null) const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class MoneyRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool bold;
  final Color? colour;
  const MoneyRow({
    super.key,
    required this.label,
    required this.amount,
    this.bold = false,
    this.colour,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 17 : 15,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: colour ?? (bold ? AppColors.ink : AppColors.sub),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(amount, style: style.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: T.h3)),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(minimumSize: const Size(48, 44)),
            child: Text(
              action!,
              style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

class BackChip extends StatelessWidget {
  const BackChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: IconButton(
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.chevron_left_rounded, color: AppColors.ink),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.field),
            side: const BorderSide(color: AppColors.line),
          ),
        ),
      ),
    );
  }
}

class StickyFooter extends StatelessWidget {
  final Widget child;
  const StickyFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: child,
    );
  }
}
