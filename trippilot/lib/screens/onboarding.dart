import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets.dart';
import 'login.dart';
import 'shell.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF12153A), Color(0xFF2C2F63)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, box) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: box.maxHeight - 40, maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 26),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.accent2],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Every journey,\nwith a driver you trust',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.22,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Book a background checked driver and a clean, '
                        'inspected car for full days, airport runs, long trips and more.',
                        style: TextStyle(fontSize: 15, color: Color(0xFFB9BCD8), height: 1.5),
                      ),
                      const SizedBox(height: 26),
                      const Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _Pill('ID verified'),
                          _Pill('Fixed fares'),
                          _Pill('Live tracking'),
                        ],
                      ),
                      const SizedBox(height: 34),
                      PrimaryButton(
                        label: 'Get started',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeShell()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          ),
                          child: const Text(
                            'I already have an account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 14, color: AppColors.verified),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
