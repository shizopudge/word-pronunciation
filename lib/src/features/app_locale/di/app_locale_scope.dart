import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/features/app_locale/bloc/app_locale.dart';

/// Область видимости локали приложения
@immutable
class AppLocaleScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости локали приложения
  const AppLocaleScope({
    required this.child,
    super.key,
  });

  /// Возвращает [AppLocaleScope] или завершается с [ArgumentError] - Out
  /// of scope
  static InheritedAppLocale of(BuildContext context, {bool listen = true}) {
    late final InheritedAppLocale? inheritedAppLocale;

    if (listen) {
      inheritedAppLocale =
          context.dependOnInheritedWidgetOfExactType<InheritedAppLocale>();
    } else {
      inheritedAppLocale =
          context.getInheritedWidgetOfExactType<InheritedAppLocale>();
    }

    if (inheritedAppLocale == null) {
      throw ArgumentError(
        'Out of scope, not found AppLocaleScope',
        'out_of_scope',
      );
    }

    return inheritedAppLocale;
  }

  @override
  State<AppLocaleScope> createState() => _AppLocaleScopeState();
}

class _AppLocaleScopeState extends State<AppLocaleScope> {
  /// {@macro app_theme_bloc}
  late final AppLocaleBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AppLocaleBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AppLocaleBloc, Locale?>(
        bloc: _bloc,
        builder: (context, locale) => InheritedAppLocale(
          locale: locale,
          child: widget.child,
        ),
      );
}

/// Виджет хранящий в себе локаль приложения
@immutable
class InheritedAppLocale extends InheritedWidget {
  /// Локаль
  final Locale? locale;

  /// Создает хранящий в себе локаль приложения
  const InheritedAppLocale({
    required this.locale,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedAppLocale oldWidget) =>
      oldWidget.locale != locale;
}
