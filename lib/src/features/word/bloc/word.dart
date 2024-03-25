import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/translation/domain/service/translation_service.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';
import 'package:word_pronunciation/src/features/word/domain/repository/i_word_repository.dart';

part 'word.freezed.dart';

@freezed
class WordEvent with _$WordEvent {
  const factory WordEvent.read() = _ReadWordEvent;

  const factory WordEvent.readFromDictionary({
    required final String word,
  }) = _ReadFromDictionaryWordEvent;
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
  final ITranslationService _translationService;
  final ValueGetter<bool> _needTranslation;

  /// {@macro word_bloc}
  WordBloc({
    required final IWordRepository repository,
    required final ITranslationService translationService,
    required final ValueGetter<bool> needTranslation,
  })  : _repository = repository,
        _translationService = translationService,
        _needTranslation = needTranslation,
        super(const WordState.progress()) {
    on<WordEvent>(
      (event, emit) => event.map(
        read: (event) => _read(event, emit),
        readFromDictionary: (event) => _readFromDictionary(event, emit),
      ),
    );
  }

  Future<void> _read(_ReadWordEvent event, Emitter<WordState> emit) async {
    final previousWord = state.word;
    try {
      emit(WordState.progress(word: previousWord));
      final newWord = await _repository
          .readWordFromNetwork()
          .timeout(const Duration(seconds: 15));
      Word? translatedWord;
      if (_needTranslation()) {
        final isInitialized = await _initializeTranslationServiceOr();
        if (isInitialized && newWord != null) {
          translatedWord = await _translateWord(newWord);
        }
      }
      emit(WordState.progress(word: translatedWord ?? newWord));
    } on Object catch (error) {
      emit(
        WordState.error(
          errorHandler: ErrorHandler(error),
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
              ErrorMessage.wordWasNotReceived,
            ),
            word: null,
          ),
        );
      }
    }
  }

  Future<void> _readFromDictionary(
      _ReadFromDictionaryWordEvent event, Emitter<WordState> emit) async {
    final previousWord = state.word;
    try {
      emit(WordState.progress(word: previousWord));
      final newWord = await _repository
          .readWordFromNetworkDictionary(word: event.word)
          .timeout(const Duration(seconds: 15));
      Word? translatedWord;
      if (_needTranslation()) {
        final isInitialized = await _initializeTranslationServiceOr();
        if (isInitialized) translatedWord = await _translateWord(newWord);
      }
      emit(WordState.progress(word: translatedWord ?? newWord));
    } on Object catch (error) {
      emit(
        WordState.error(
          errorHandler: ErrorHandler(error),
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
              ErrorMessage.wordWasNotReceived,
            ),
            word: null,
          ),
        );
      }
    }
  }

  /// Возвращает true, если сервис перевода текста инициализирован.
  Future<bool> _initializeTranslationServiceOr() async {
    final isInitialized = _translationService.isInitialized;
    if (!isInitialized) {
      try {
        await _translationService
            .initialize(
              sourceLanguage: TranslateLanguage.english,
              targetLanguage: TranslateLanguage.russian,
            )
            .timeout(const Duration(seconds: 90));
      } on Object catch (error, stackTrace) {
        // ignore.
        L.error(
          '[WordBloc] Error: $error. StackTrace: $stackTrace.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    return _translationService.isInitialized;
  }

  /// Возвращает переведенное слово или изначальное в случае ошибки.
  Future<Word> _translateWord(Word source) async {
    try {
      final meanings = source.meanings;
      final translatedMeanings = await Stream.fromIterable(meanings).asyncMap(
        (meaning) async {
          final definitions = meaning.definitions;
          final translatedDefinitions =
              await Stream.fromIterable(definitions).asyncMap(
            (definition) async {
              final translatedDefinitionData =
                  await _translationService.translate(definition.data);
              final example = definition.example;
              String? translatedExample;
              if (example.isNotEmpty) {
                translatedExample =
                    await _translationService.translate(example);
              }
              return definition.copyWith(
                data: translatedDefinitionData,
                example: translatedExample ?? example,
              );
            },
          ).toList();
          return meaning.copyWith(definitions: translatedDefinitions);
        },
      ).toList();
      return source.copyWith(meanings: translatedMeanings);
    } on Object catch (error, stackTrace) {
      // ignore.
      L.error(
        '[WordBloc] Error: $error. StackTrace: $stackTrace.',
        error: error,
        stackTrace: stackTrace,
      );
      return source;
    }
  }

  @override
  Future<void> close() async {
    await _translationService.dispose();
    return super.close();
  }
}
