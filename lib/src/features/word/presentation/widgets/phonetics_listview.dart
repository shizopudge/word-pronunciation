import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_audio.dart';
import 'package:word_pronunciation/src/features/word/data/model/phonetic.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Список аудио
@immutable
class PhoneticsListview extends StatelessWidget {
  /// Фонетика
  final List<Phonetic> phonetics;

  /// Создает список аудио
  PhoneticsListview({
    super.key,
    required this.phonetics,
  }) : assert(phonetics.isNotEmpty, 'Phonetics should never be empty');

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WordTitle(context.localization.phonetics),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              height: 83,
              child: BlocBuilder<WordAudioBloc, WordAudioState>(
                bloc: WordScope.of(context).wordAudioBloc,
                buildWhen: (previous, current) => !current.isError,
                builder: (context, state) => ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: phonetics.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) => AudioTile(
                    state: state,
                    phonetic: phonetics[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
