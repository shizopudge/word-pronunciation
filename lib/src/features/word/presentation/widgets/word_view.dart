import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/toaster/src/toaster_config.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/di/word_scope.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';

/// [WordPage] view
@immutable
class WordView extends StatelessWidget {
  /// Создает [WordPage] view
  const WordView({
    super.key,
  });

  @override
  Widget build(BuildContext context) => BlocListener<WordBloc, WordState>(
        bloc: WordScope.of(context).wordBloc,
        listenWhen: (previous, current) => current.isError,
        listener: (context, state) => state.mapOrNull(
          error: (e) => context.showToaster(
            message: e.errorHandler.message(context),
            type: ToasterType.error,
          ),
        ),
        child: Scaffold(
          // TODO: Blured app bar
          appBar: AppBar(
            title: const Text('Word'),
          ),
          body: const WordBody(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: const MicButton(),
        ),
      );
}
