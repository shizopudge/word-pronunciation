import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app_locale/bloc/app_locale.dart';
import 'package:word_pronunciation/src/features/app_locale/data/datasource/app_locale_datasource.dart';
import 'package:word_pronunciation/src/features/app_locale/data/repository/app_locale_repository.dart';
import 'package:word_pronunciation/src/features/app_theme/di/app_theme_scope.dart';

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

  /// Возвращает виджет хранящий в себе зависимости локали приложения или завершается с [ArgumentError] - Out
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

  /// Возвращает виджет хранящий в себе зависимости локали приложения или null
  static InheritedAppLocale? maybeOf(
    BuildContext context, {
    bool listen = true,
  }) {
    late final InheritedAppLocale? inheritedAppLocale;

    if (listen) {
      inheritedAppLocale =
          context.dependOnInheritedWidgetOfExactType<InheritedAppLocale>();
    } else {
      inheritedAppLocale =
          context.getInheritedWidgetOfExactType<InheritedAppLocale>();
    }

    return inheritedAppLocale;
  }

  @override
  State<AppLocaleScope> createState() => _AppLocaleScopeState();
}

class _AppLocaleScopeState extends State<AppLocaleScope> {
  /// {@macro app_locale_bloc}
  late final AppLocaleBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AppLocaleBloc(
      repository: AppLocaleRepository(
        datasource: AppLocaleDatasource(
          keyLocalStorage: CoreDependencies.of(context).keyLocalStorage,
        ),
      ),
    )..add(const AppLocaleEvent.read());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<AppLocaleBloc, AppLocaleState>(
        bloc: _bloc,
        listener: (context, state) {
          // TODO: add showToaster method
        },
        listenWhen: (previous, current) => current.isError,
        buildWhen: (previous, current) => current.isIdle,
        builder: (context, state) {
          late final Widget child;

          final languageCode = state.languageCode;

          if (languageCode == null) {
            child = AppSplash(appTheme: AppThemeScope.maybeOf(context)?.theme);
          } else {
            child = InheritedAppLocale(
              locale: Locale(languageCode),
              bloc: _bloc,
              child: widget.child,
            );
          }

          return AnimatedSwitcher(
            duration: Durations.short3,
            child: child,
          );
        },
      );
}

/// Виджет хранящий в себе зависимости локали приложения
@immutable
class InheritedAppLocale extends InheritedWidget {
  /// Локаль
  final Locale locale;

  /// {@macro app_locale_bloc}
  final AppLocaleBloc bloc;

  /// Создает хранящий в себе зависимости локали приложения
  const InheritedAppLocale({
    required this.locale,
    required this.bloc,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedAppLocale oldWidget) =>
      oldWidget.locale != locale || oldWidget.bloc != bloc;
}
