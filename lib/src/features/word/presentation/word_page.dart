import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Экран с словом
@immutable
@RoutePage<void>()
class WordPage extends StatelessWidget {
  /// Создает экран с словом
  const WordPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.theme.systemUiOverlayStyle
            .copyWith(statusBarColor: Colors.transparent),
        child: const Scaffold(
          body: SafeArea(
            child: Center(
              child: Text('WORD PAGE'),
            ),
          ),
        ),
      );
}
