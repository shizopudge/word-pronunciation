import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app_locale/data/datasource/app_locale_datasource.dart';
import 'package:word_pronunciation/src/features/app_locale/domain/repository/i_app_locale_repository.dart';

/// {@macro app_locale_repository}
@immutable
class AppLocaleRepository implements IAppLocaleRepository {
  /// {@macro app_locale_datasource}
  final IAppLocaleDatasource _datasource;

  /// {@macro app_locale_repository}
  const AppLocaleRepository({
    required IAppLocaleDatasource datasource,
  }) : _datasource = datasource;

  @override
  String readLanguageCodeFromStorage() =>
      _datasource.readLanguageCodeFromStorage();

  @override
  Future<void> writeLanguageCodeToStorage(String languageCode) =>
      _datasource.writeLanguageCodeToStorage(languageCode);

  @override
  String get defaultLanguageCode => _datasource.defaultLanguageCode;
}
