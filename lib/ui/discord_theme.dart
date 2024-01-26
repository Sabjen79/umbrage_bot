import 'package:flutter/material.dart';

class DiscordTheme {
  static const Color primaryColor = Color(0xFF5865f2);
  static const Color primaryColorDarker = Color(0xFF4752c4);
  static const Color primaryColorDarkest = Color(0xFF313998);

  static const Color backgroundColorLight = Color(0xFF313338);
  static const Color backgroundColorDark = Color(0xFF2b2d31);
  static const Color backgroundColorDarker = Color(0xFF232428);
  static const Color backgroundColorDarkest = Color(0xFF1e1f22);

  static const Color white = Color(0xFFFFFFFF);
  static const Color white2 = Color.fromARGB(255, 217, 220, 227);
  static const Color lightGray = Color.fromARGB(255, 147, 150, 162);
  static const Color gray = Color(0xFF404249);
  static const Color darkGray = Color(0xFF1e1f22);
  static const Color black = Color(0xFF111214);

  static const OutlineInputBorder _noBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  static ThemeData get() {
    return ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white
      ),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 12),
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        fillColor: darkGray,
        filled: true,
        border: _noBorder,
        enabledBorder: _noBorder,
        focusedBorder: _noBorder,
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red),
      ),
      dialogBackgroundColor: backgroundColorLight,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: const MaterialStatePropertyAll<Color>(primaryColorDarker),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.focused)) return primaryColorDarker;
              if (states.contains(MaterialState.pressed)) return primaryColorDarkest;
              if (states.contains(MaterialState.disabled)) return backgroundColorLight;
              return primaryColor;
            },
          ),
          foregroundColor: const MaterialStatePropertyAll<Color>(white),
          shape: const MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2)))),
          textStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(
            fontWeight: FontWeight.w500
          ))
        )
      ),
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(black),
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.only(
            top: 13,
            bottom: 13,
            left: 5,
            right: 5,
          ))
        ),
      ),
      menuButtonTheme: const MenuButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll<Color>(primaryColorDarker),
          minimumSize: MaterialStatePropertyAll<Size>(Size(130, 35)),
          maximumSize: MaterialStatePropertyAll<Size>(Size(130, 35)),
          iconSize: MaterialStatePropertyAll<double>(18),
          iconColor: MaterialStatePropertyAll<Color>(Color(0xFFFFFFFF)),
          shape: MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2)))),
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.only(
            left: 5,
            right: 5,
            top: 10,
            bottom: 10
          )),
          textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
            fontSize: 12
          ))
        )
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: Color(0xFF381E72),
        primaryContainer: backgroundColorDarker,
        onPrimaryContainer: Color(0xFFe6e6e6),
        secondary: Color(0xFFCCC2DC),
        onSecondary: Color(0xFF332D41),
        secondaryContainer: backgroundColorDarkest,
        onSecondaryContainer: Color(0xFFE8DEF8),
        tertiary: Color(0xFFEFB8C8),
        onTertiary: Color(0xFF492532),
        tertiaryContainer: black,
        onTertiaryContainer: white,
        error: Color(0xFFF2B8B5),
        onError: Color(0xFF601410),
        errorContainer: Color(0xFF8C1D18),
        onErrorContainer: Color(0xFFF9DEDC),
        background: backgroundColorLight,
        onBackground: Color(0xFFE6E1E5),
        surface: backgroundColorLight,
        onSurface: Color(0xFFE6E1E5),
        surfaceVariant: Color(0xFF49454F),
        onSurfaceVariant: Color(0xFFCAC4D0),
        outline: Color(0xFF938F99),
        outlineVariant: Color(0xFF49454F),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE6E1E5),
        onInverseSurface: Color(0xFF313033),
        inversePrimary: Color(0xFF6750A4),
        // The surfaceTint color is set to the same color as the primary.
        surfaceTint: Colors.transparent,
      )
    );
  }
}