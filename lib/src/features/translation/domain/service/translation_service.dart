import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Интерфейс сервиса перевода текста.
abstract interface class ITranslationService {
  /// Инициализирует сервис перевода текста.
  ///
  /// [sourceLanguage] - язык оригинала,
  /// [targetLanguage] - язык на который будет переведен текст.
  Future<void> initialize({
    required final TranslateLanguage sourceLanguage,
    required final TranslateLanguage targetLanguage,
  });

  /// Переводит строку.
  ///
  /// [source] - оригинальная строка.
  Future<String> translate(String source);

  /// Уничтожает сервис.
  Future<void> dispose();

  /// Возвращает true, если сервис инициализирован.
  bool get isInitialized;
}

/// {@template translation_service}
/// Сервис перевода текста.
/// {@endtemplate}
final class TranslationService implements ITranslationService {
  /// {@macro translation_service}
  TranslationService();

  /// Переводчик.
  late OnDeviceTranslator _translator;

  /// Менеджер моделей.
  late OnDeviceTranslatorModelManager _modelManager;

  @override
  bool isInitialized = false;

  @override
  Future<void> initialize({
    required final TranslateLanguage sourceLanguage,
    required final TranslateLanguage targetLanguage,
  }) async {
    _translator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
    _modelManager = OnDeviceTranslatorModelManager();
    final isSourceModelDownloaded =
        await _modelManager.isModelDownloaded(sourceLanguage.bcpCode);
    final isTargetModelDownloaded =
        await _modelManager.isModelDownloaded(targetLanguage.bcpCode);
    if (!isSourceModelDownloaded) {
      await _modelManager.downloadModel(sourceLanguage.bcpCode);
    }
    if (!isTargetModelDownloaded) {
      await _modelManager.downloadModel(targetLanguage.bcpCode);
    }
    isInitialized = true;
  }

  @override
  Future<String> translate(String source) => _translator.translateText(source);

  @override
  Future<void> dispose() async {
    await _translator.close();
    isInitialized = false;
  }
}
