import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';
import 'package:word_pronunciation/src/features/word/domain/repository/i_word_repository.dart';

part 'word.freezed.dart';

@freezed
class WordEvent with _$WordEvent {
  const factory WordEvent.read() = _ReadWordEvent;
}

@freezed
class WordState with _$WordState {
  const WordState._();

  bool get isIdle => maybeMap(
        orElse: () => false,
        idle: (_) => true,
      );

  bool get isProgress => maybeMap(
        orElse: () => false,
        progress: (_) => true,
      );

  bool get isError => maybeMap(
        orElse: () => false,
        error: (e) => e.word != null,
      );

  bool get isFatalError => maybeMap(
        orElse: () => false,
        error: (e) => e.word == null,
      );

  const factory WordState.idle({
    required final Word word,
  }) = _IdleWordState;

  const factory WordState.progress({
    final Word? word,
  }) = _ProgressWordState;

  const factory WordState.error({
    required final IErrorHandler errorHandler,
    final Word? word,
  }) = _ErrorWordState;
}

/// {@template word_bloc}
/// Блок слова
/// {@endtemplate}
class WordBloc extends Bloc<WordEvent, WordState> {
  final IWordRepository _repository;

  /// {@macro word_bloc}
  WordBloc({
    required IWordRepository repository,
  })  : _repository = repository,
        super(const WordState.progress()) {
    on<WordEvent>(
      (event, emit) => event.map(
        read: (event) => _read(event, emit),
      ),
    );
  }

  Future<void> _read(WordEvent event, Emitter<WordState> emit) async {
    final previousWord = state.word;
    try {
      emit(WordState.progress(word: previousWord));
      final newWord = await _repository
          .readWordFromNetwork()
          .timeout(const Duration(seconds: 15));
      emit(WordState.progress(word: newWord));
    } on Object catch (error) {
      emit(
        WordState.error(
          errorHandler: ErrorHandler(error: error),
          word: previousWord,
        ),
      );
      rethrow;
    } finally {
      final word = state.word;
      if (word != null) {
        emit(WordState.idle(word: word));
      } else if (previousWord != null) {
        emit(WordState.idle(word: previousWord));
      } else if (!state.isError && !state.isFatalError) {
        emit(
          const WordState.error(
            errorHandler: ErrorHandler(
              error: ErrorMessage.wordWasNotReceived,
            ),
            word: null,
          ),
        );
      }
    }
  }
}
