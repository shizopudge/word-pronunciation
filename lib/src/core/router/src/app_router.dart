import 'package:auto_route/auto_route.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';

part 'app_router.gr.dart';

/// {@template app_router}
/// Роутер
/// {@endtemplate}
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  /// {@macro app_router}
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    /// Экран с словом
    AdaptiveRoute(
      page: WordRoute.page,
      path: '/',
      initial: true,
    ),
  ];
}
