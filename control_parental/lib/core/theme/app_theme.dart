import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {

  static const Color background    = Color(0xFFF5F0E8); // Crema Suave
  static const Color surfaceColor  = Color(0xFFFFFFFF); // blanco para tarjetas
  static const Color surfaceAlt    = Color(0xFFEFF6FC); // azul muy tenue

  static const Color primaryColor  = Color(0xFF7EB6E3); // Azul Nube
  static const Color primaryDark   = Color(0xFF4A90C4); // azul más saturado (texto/botones)
  static const Color primaryLight  = Color(0xFFB8D9F2); // azul clarísimo

  static const Color accentColor   = Color(0xFFF4E7B2); // Amarillo Paja
  static const Color accentDark    = Color(0xFF9A7E1A); // amarillo oscuro para texto

  static const Color complementary = Color(0xFFD3B5E0); // Violeta Hada
  static const Color compDark      = Color(0xFF6B3FA0); // violeta oscuro para texto

  static const Color successColor  = Color(0xFF7EC8A4); // verde suave
  static const Color errorColor    = Color(0xFFE07D7D);  // rojo suave

  static const Color textPrimary   = Color(0xFF2D3A4A); // azul marino oscuro
  static const Color textSecondary = Color(0xFF7A8FA6); // gris azulado
  static const Color borderColor   = Color(0xFFD8E8F5); // borde azul muy suave

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: complementary,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: compDark,
        onSurface: textPrimary,
        error: errorColor,
      ),
      fontFamily: 'Nunito',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: borderColor),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return const Color(0xFFBDCCDA);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withValues(alpha: 0.35);
          }
          return const Color(0xFFDDE8F0);
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: borderColor,
        thumbColor: primaryColor,
        overlayColor: primaryColor.withValues(alpha: 0.15),
        trackHeight: 4,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: CircleBorder(),
      ),
      dividerColor: borderColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
        bodyLarge:    TextStyle(color: textPrimary),
        bodyMedium:   TextStyle(color: textSecondary),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: textPrimary,
        iconColor: primaryColor,
      ),
    );
  }
}