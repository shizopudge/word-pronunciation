import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/theme/theme.dart';

// TODO: Прописать темную тему
/// {@macro app_theme}
@immutable
class DarkAppTheme implements IAppTheme {
  /// {@macro app_colors}
  final IAppColors appColors;

  /// {@macro app_theme}
  const DarkAppTheme({
    required this.appColors,
  });

  @override
  IAppColors get colors => appColors;

  @override
  TextTheme get textTheme => _textTheme;

  @override
  bool get isDark => true;

  @override
  ThemeData get data => ThemeData(
        useMaterial3: true,
        fontFamily: 'Plus Jakarta Sans',
        textTheme: _textTheme,
        scaffoldBackgroundColor: colors.black,
        dividerTheme: _dividerThemeData,
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonThemeData,
        colorSchemeSeed: colors.black,
        outlinedButtonTheme: _outlinedButtonThemeData,
        textButtonTheme: _textButtonThemeData,
        iconButtonTheme: _iconButtonThemeData,
        checkboxTheme: _checkboxThemeData,
        switchTheme: _switchThemeData,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        bottomSheetTheme: _bottomSheetThemeData,
      );

  /// AppBar Theme
  AppBarTheme get _appBarTheme => AppBarTheme(
        titleTextStyle: _textTheme.headlineLarge?.copyWith(
          color: colors.black,
        ),
        toolbarHeight: 80,
        foregroundColor: colors.black,
        shadowColor: colors.grey,
        surfaceTintColor: colors.white,
        scrolledUnderElevation: 0.5,
        elevation: 0,
        centerTitle: false,
        backgroundColor: colors.white,
      );

  /// Text Style
  TextTheme get _textTheme => const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.5,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.2,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.5,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.2,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.6,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.63,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.3,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.4,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.6,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.63,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.86,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.3,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      );

  /// Тема нижненго всплывающего окна
  BottomSheetThemeData get _bottomSheetThemeData => BottomSheetThemeData(
        backgroundColor: colors.white,
        dragHandleColor: colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      );

  /// Button style
  ElevatedButtonThemeData get _elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: _textTheme.titleSmall,
          backgroundColor: colors.black,
          foregroundColor: colors.white,
          minimumSize: const Size.fromHeight(64),
          maximumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Outlined button style
  OutlinedButtonThemeData get _outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: _textTheme.titleMedium,
          foregroundColor: colors.black,
          backgroundColor: colors.white,
          minimumSize: const Size.fromHeight(64),
          maximumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          side: BorderSide(color: colors.black),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Text button style
  TextButtonThemeData get _textButtonThemeData => TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: _textTheme.titleMedium,
          foregroundColor: colors.black,
          backgroundColor: colors.white,
          minimumSize: const Size.fromHeight(64),
          maximumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Icon button style
  IconButtonThemeData get _iconButtonThemeData => IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colors.black,
          backgroundColor: colors.white,
          minimumSize: const Size.square(40),
          maximumSize: const Size.square(40),
          padding: const EdgeInsets.all(8),
          iconSize: 24,
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Checkbox style
  CheckboxThemeData get _checkboxThemeData => CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? colors.black
              : colors.white,
        ),
        checkColor: MaterialStateProperty.all(colors.white),
        splashRadius: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: MaterialStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: states.contains(MaterialState.selected)
                ? colors.black
                : colors.grey,
          ),
        ),
      );

  /// Switch style
  SwitchThemeData get _switchThemeData => SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => colors.white,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? colors.black
              : colors.grey,
        ),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
        trackOutlineWidth: MaterialStateProperty.all(0),
        splashRadius: 0,
      );

  /// Divider style
  DividerThemeData get _dividerThemeData => DividerThemeData(
        color: colors.grey,
        thickness: 1,
        indent: 0,
        space: 0,
      );

  @override
  SystemUiOverlayStyle get systemUiOverlayStyle => SystemUiOverlayStyle.light;
}
