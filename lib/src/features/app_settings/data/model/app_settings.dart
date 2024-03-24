import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool autoNextWord,
  }) = _AppSettings;

  /// Generate Class from Map<String, Object?>
  factory AppSettings.fromJson(Map<String, Object?> json) =>
      _$AppSettingsFromJson(json);

  /// Обычные настройки
  static const common = AppSettings(autoNextWord: false);
}
