import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';
import 'onboarding.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;

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
              const Text('Profile', style: T.h1),
              const SizedBox(height: 18),
              TpCard(
                child: Row(
                  children: [
                    const Avatar(initials: 'AK', gradient: 4, size: 60),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ayesha Khan', style: T.h3),
                          SizedBox(height: 3),
                          Text('+61 412 745 280', style: T.small),
                        ],
                      ),
                    ),
                    const VerifiedBadge(),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader(title: 'Account'),
              const SizedBox(height: 4),
              TpCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    _Row(
                      icon: Icons.place_outlined,
                      title: 'Saved places',
                      trailing: 'Home  .  Work',
                      onTap: () => _soon(context, 'Saved places'),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    _Row(
                      icon: Icons.credit_card_outlined,
                      title: 'Payment methods',
                      trailing: 'Visa  .  Wallet',
                      onTap: () => _soon(context, 'Payment methods'),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    _Row(
                      icon: Icons.shield_outlined,
                      title: 'Safety centre',
                      trailing: 'Trusted contacts',
                      onTap: () => _soon(context, 'Safety centre'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader(title: 'Preferences'),
              const SizedBox(height: 4),
              TpCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _notifications,
                      activeTrackColor: AppColors.accent,
                      onChanged: (v) => setState(() => _notifications = v),
                      title: const Text('Notifications', style: T.value),
                      subtitle: Text(_notifications ? 'On' : 'Off', style: T.small),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    _Row(
                      icon: Icons.language_rounded,
                      title: 'Language',
                      trailing: 'English',
                      onTap: () => _soon(context, 'Language'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SecondaryButton(
                label: 'Sign out',
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _soon(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name is designed in Figma but not built in this front end.')),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  final VoidCallback onTap;
  const _Row({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Icon(icon, color: AppColors.ink, size: 21),
      title: Text(title, style: T.value),
      subtitle: Text(trailing, style: T.small),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
    );
  }
}
