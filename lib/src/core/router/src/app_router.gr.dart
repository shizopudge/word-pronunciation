// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    WordRoute.name: (routeData) {
      return AutoRoutePage<void>(
        routeData: routeData,
        child: const WordPage(),
      );
    }
  };
}

/// generated route for
/// [WordPage]
class WordRoute extends PageRouteInfo<void> {
  const WordRoute({List<PageRouteInfo>? children})
      : super(
          WordRoute.name,
          initialChildren: children,
        );

  static const String name = 'WordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
