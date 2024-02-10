import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// {@template app_analytics}
/// Аналитика приложения
/// {@endtemplate}
@immutable
abstract interface class IAppAnalytics {
  /// Логирует событие
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  });

  /// Логирует открытие приложения
  Future<void> logAppOpen({
    AnalyticsCallOptions? callOptions,
    Map<String, Object?>? parameters,
  });

  /// Включает/выключает аналитику
  Future<void> setAnalyticsCollectionEnabled();
}

/// {@macro app_analytics}
@immutable
class AppAnalytics implements IAppAnalytics {
  final FirebaseAnalytics _analytics;

  /// {@macro app_analytics}
  const AppAnalytics._({
    required FirebaseAnalytics analytics,
  }) : _analytics = analytics;

  /// Экземпляр класса
  static AppAnalytics? _instance;
  static final instance =
      _instance ??= AppAnalytics._(analytics: FirebaseAnalytics.instance);

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) {
    if (!kReleaseMode) return Future<void>.value();
    return _analytics.logEvent(
        name: name, parameters: parameters, callOptions: callOptions);
  }

  @override
  Future<void> logAppOpen({
    AnalyticsCallOptions? callOptions,
    Map<String, Object?>? parameters,
  }) {
    if (!kReleaseMode) return Future<void>.value();
    return _analytics.logAppOpen();
  }

  @override
  Future<void> setAnalyticsCollectionEnabled() =>
      _analytics.setAnalyticsCollectionEnabled(kReleaseMode);
}
