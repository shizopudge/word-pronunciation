import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';

/// {@template app_bloc_observer}
/// Custom [BlocObserver] that observes all bloc and cubit state changes.
/// {@endtemplate}
@immutable
class AppBlocObserver extends BlocObserver {
  /// {@macro app_bloc_observer}
  const AppBlocObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    L.log(
        '$bloc changed. Current state: ${change.currentState}. Next state: ${change.nextState}');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    L.log('$bloc closed');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    L.log('$bloc created');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    L.log('Error in $bloc. Error: $error. StackTrace: $stackTrace');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    L.log('Event in $bloc. Event: $event.');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    L.log(
        'Transition in $bloc. Event: ${transition.event}. Current state: ${transition.currentState}. Next state: ${transition.nextState}.');
  }
}
