import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app_locale/bloc/app_locale.dart';
import 'package:word_pronunciation/src/features/app_locale/data/datasource/app_locale_datasource.dart';
import 'package:word_pronunciation/src/features/app_locale/data/repository/app_locale_repository.dart';

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

  /// Возвращает виджет хранящий в себе [AppLocaleScope] или завершается с
  /// [FlutterError] - Out of scope
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
      throw FlutterError('Out of scope, not found AppLocaleScope');
    }

    return inheritedAppLocale;
  }

  /// Возвращает виджет хранящий в себе [AppLocaleScope] или null
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
      BlocBuilder<AppLocaleBloc, AppLocaleState>(
        bloc: _bloc,
        // TODO: Подумать над состояниями ошибки
        buildWhen: (previous, current) => current.isIdle,
        builder: (context, state) {
          late final Widget child;

          final languageCode = state.languageCode;

          if (languageCode == null) {
            child = const AppSplash();
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

/// Виджет хранящий в себе [AppLocaleScope]
@immutable
class InheritedAppLocale extends InheritedWidget {
  /// Локаль
  final Locale locale;

  /// {@macro app_locale_bloc}
  final AppLocaleBloc bloc;

  /// Создает виджет хранящий в себе [AppLocaleScope]
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
