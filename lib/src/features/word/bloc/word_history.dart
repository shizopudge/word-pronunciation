import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/word/data/model/local_word.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';
import 'package:word_pronunciation/src/features/word/domain/repository/i_word_repository.dart';

part 'word_history.freezed.dart';

@freezed
class WordHistoryEvent with _$WordHistoryEvent {
  const factory WordHistoryEvent.read({
    required final WordHistoryFilter filter,
    @Default(false) final bool reset,
  }) = _ReadWordHistoryEvent;
}

@freezed
class WordHistoryState with _$WordHistoryState {
  const WordHistoryState._();

  bool get isProgress => maybeMap(
        orElse: () => false,
        progress: (p) => p.words.isNotEmpty,
      );

  bool get isPrimaryProgress => maybeMap(
        orElse: () => false,
        progress: (p) => p.words.isEmpty,
      );

  bool get isError => maybeMap(
        orElse: () => false,
        error: (e) => e.words.isNotEmpty,
      );

  bool get isFatalError => maybeMap(
        orElse: () => false,
        error: (e) => e.words.isEmpty,
      );

  const factory WordHistoryState.idle({
    required final List<LocalWord> words,
    required final bool isEndOfList,
  }) = _IdleWordHistoryState;

  const factory WordHistoryState.progress({
    required final List<LocalWord> words,
    required final bool isEndOfList,
  }) = _ProgressWordHistoryState;

  const factory WordHistoryState.error({
    required final IErrorHandler errorHandler,
    required final List<LocalWord> words,
    required final bool isEndOfList,
  }) = _ErrorWordHistoryState;
}

/// {@template word_history_bloc}
/// Блок истории слов
/// {@endtemplate}
class WordHistoryBloc extends Bloc<WordHistoryEvent, WordHistoryState> {
  final IWordRepository _repository;

  /// {@macro word_history_bloc}
  WordHistoryBloc({
    required final IWordRepository repository,
  })  : _repository = repository,
        super(const WordHistoryState.progress(words: [], isEndOfList: false)) {
    on<WordHistoryEvent>(
      (event, emit) => event.map(
        read: (event) => _read(event, emit),
      ),
    );
  }

  Future<void> _read(
      _ReadWordHistoryEvent event, Emitter<WordHistoryState> emit) async {
    final reset = event.reset;
    emit(
      WordHistoryState.progress(
        words: reset ? [] : state.words,
        isEndOfList: state.isEndOfList,
      ),
    );
    final offset = state.words.length;
    try {
      const limit = 15;
      final result = await _repository
          .readHistoryWordsFromLocal(
            limit: limit,
            offset: offset,
            filter: event.filter,
          )
          .timeout(const Duration(seconds: 15));
      emit(
        WordHistoryState.progress(
          words: List.from([...state.words, ...result]),
          isEndOfList: result.length < limit,
        ),
      );
    } on Object catch (error) {
      emit(
        WordHistoryState.error(
          errorHandler: ErrorHandler(error: error),
          words: state.words,
          isEndOfList: state.isEndOfList,
        ),
      );
      rethrow;
    } finally {
      emit(WordHistoryState.idle(
        words: state.words,
        isEndOfList: state.isEndOfList,
      ));
    }
  }
}
