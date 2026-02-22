import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
