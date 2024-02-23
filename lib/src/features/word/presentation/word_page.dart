import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/toaster/toaster.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_audio.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/permissions_alert.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Экран с словом
@immutable
@RoutePage<void>()
class WordPage extends StatelessWidget {
  /// Создает экран с словом
  const WordPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.theme.systemUiOverlayStyle
            .copyWith(statusBarColor: Colors.transparent),
        child: const WordScope(
          child: _WordView(),
        ),
      );
}

/// [WordPage] view
@immutable
class _WordView extends StatelessWidget {
  /// Создает [WordPage] view
  const _WordView();

  @override
  Widget build(BuildContext context) => _Listeners(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: BluredAppBar(
            backgroundColor: (context.theme.isDark
                    ? context.theme.colors.black
                    : context.theme.colors.white)
                .withOpacity(.2),
            title: Text(context.localization.word),
          ),
          body: const _WordBody(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: const WordFloatingButton(),
        ),
      );
}

/// Тело [_WordView]
@immutable
class _WordBody extends StatelessWidget {
  /// Создает тело [_WordView]
  const _WordBody();

  @override
  Widget build(BuildContext context) => BlocBuilder<WordBloc, WordState>(
        bloc: WordScope.of(context).wordBloc,
        buildWhen: (previous, current) => !current.isError,
        builder: (context, state) => AnimatedSwitcher(
          duration: Durations.short4,
          child: state.map(
            idle: (i) => WordIdleLayout(word: i.word),
            progress: (p) => const ProgressLayout(),
            error: (e) => WordErrorLayout(
              message: e.errorHandler.toMessage(context),
            ),
          ),
        ),
      );
}

@immutable
class _Listeners extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Слушатели
  const _Listeners({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: [
          BlocListener<WordBloc, WordState>(
            bloc: WordScope.of(context).wordBloc,
            listenWhen: (previous, current) =>
                current.isError || current.isProgress,
            listener: (context, state) => state.mapOrNull<void>(
              progress: (p) => WordScope.of(context)
                  .wordAudioBloc
                  .add(const WordAudioEvent.stop()),
              error: (e) => context.showToaster(
                message: e.errorHandler.toMessage(context),
                type: ToasterType.error,
              ),
            ),
          ),
          BlocListener<WordAudioBloc, WordAudioState>(
            bloc: WordScope.of(context).wordAudioBloc,
            listenWhen: (previous, current) => current.isError,
            listener: (context, state) => state.mapOrNull<void>(
              error: (e) => context.showToaster(
                message: e.errorHandler.toMessage(context),
                type: ToasterType.error,
              ),
            ),
          ),
          BlocListener<WordPronunciationBloc, WordPronunciationState>(
            bloc: WordScope.of(context).wordPronunciationBloc,
            listener: (context, state) => state.mapOrNull<void>(
              idle: (_) => WordScope.of(context).state.hideResult(),
              pronunciation: (p) => WordScope.of(context).state.showResult(),
              error: (e) {
                final err = e.errorHandler.error;
                if (err is SpeechServicePermissionException) {
                  return unawaited(_showPronunciationPermissionsAlert(context));
                } else if (err is SpeechServiceException) {
                  if (err.exception == '1') {
                  } else if (err.exception == '2') {}
                }
                return context.showToaster(
                  message: e.errorHandler.toMessage(context),
                  type: ToasterType.error,
                );
              },
            ),
          ),
        ],
        child: child,
      );

  /// Показывает алерт с сообщением о разрешениях для произношения слов
  Future<void> _showPronunciationPermissionsAlert(BuildContext context) async {
    final result = await PermissionsAlert.show(
      context,
      title: context.localization.microphonePermissions,
      description: context.localization.youHaventGivenPermissionToUseMic,
    );
    if (result != null && result && context.mounted) {
      final isCanOpen = await openAppSettings();
      if (!isCanOpen && context.mounted) {
        context.showToaster(
          message: context.localization.cantOpenAppSettings,
          type: ToasterType.error,
        );
      }
    }
  }
}
