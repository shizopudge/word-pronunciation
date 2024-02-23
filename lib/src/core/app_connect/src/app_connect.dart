import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

/// {@template app_connect}
/// Класс проверяющий подключение к интернету
/// {@endtemplate}
@immutable
abstract interface class IAppConnect {
  /// Слушает изменение интернет соединения
  Stream<bool> get onConnectChanged;

  /// Проверяет подключение к сети
  ///
  /// Возвращает *true* если доступ в интернет присутствует
  /// иначе *false*
  Future<bool> hasConnect();
}

/// {@macro app_connect}
@immutable
class AppConnect implements IAppConnect {
  /// {@macro app_connect}
  const AppConnect();

  @override
  Stream<bool> get onConnectChanged => Connectivity().onConnectivityChanged.map(
        (event) => event != ConnectivityResult.none,
      );

  @override
  Future<bool> hasConnect() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
