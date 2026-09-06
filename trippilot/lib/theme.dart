import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF12153A);
  static const sub = Color(0xFF565A78);
  static const muted = Color(0xFF8A8FAE);
  static const line = Color(0xFFE9E9F2);
  static const bg = Color(0xFFF6F6FB);
  static const card = Color(0xFFFFFFFF);
  static const accent = Color(0xFFFF6B4A);
  static const accent2 = Color(0xFFFF9E5B);
  static const verified = Color(0xFF12B76A);
  static const verifiedBg = Color(0xFFE7F8F0);
  static const star = Color(0xFFFFB020);

  static const tileGradients = <List<Color>>[
    [Color(0xFF5B6CFF), Color(0xFF8A5BFF)],
    [Color(0xFF3AA0FF), Color(0xFF5BC0FF)],
    [Color(0xFF12B76A), Color(0xFF33C6A0)],
    [Color(0xFFFF7A45), Color(0xFFFF9E5B)],
    [Color(0xFFE0518A), Color(0xFFF07AA6)],
    [Color(0xFF12153A), Color(0xFF3A3F70)],
  ];
}

class AppRadius {
  static const card = 18.0;
  static const field = 14.0;
  static const button = 16.0;
  static const chip = 17.0;
}

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.accent,
      secondary: AppColors.ink,
      surface: AppColors.card,
    ),
    textTheme: base.textTheme.apply(
      fontFamily: 'Inter',
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: AppColors.bg,
      elevation: 0,
      centerTitle: true,
      foregroundColor: AppColors.ink,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    ),
    dividerColor: AppColors.line,
    splashFactory: InkRipple.splashFactory,
  );
}

class T {
  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    height: 1.2,
  );
  static const h2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink);
  static const h3 = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink);
  static const title = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink);
  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.sub,
    height: 1.45,
  );
  static const value = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink);
  static const label = TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.muted);
  static const small = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.muted);
  static const badge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.verified,
  );
}
