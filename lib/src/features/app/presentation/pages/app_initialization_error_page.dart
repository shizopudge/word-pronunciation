import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/bloc/app_initialization.dart';
import 'package:word_pronunciation/src/features/app/di/app_initialization_scope.dart';
import 'package:word_pronunciation/src/features/app/presentation/widgets/widgets.dart';

/// Виджет отображающий ошибку загрузки приложения
@immutable
class AppInitializationErrorPage extends StatefulWidget {
  /// Сообщение
  final String message;

  /// Создает виджет отображающий ошибку загрузки приложения
  const AppInitializationErrorPage({
    required this.message,
    super.key,
  });

  @override
  State<AppInitializationErrorPage> createState() =>
      _AppInitializationErrorPageState();
}

class _AppInitializationErrorPageState
    extends State<AppInitializationErrorPage> {
  /// {@template scroll_controller}
  /// Контроллер скролла
  /// {@endtemplate}
  late final ScrollController _scrollController;

  /// {@template is_scrollable_controller}
  /// Если true, значит экран скроллится
  /// {@endtemplate}
  late final ValueNotifier<bool> _isScrollableController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _isScrollableController = ValueNotifier<bool>(false);
    _setIsScrollable();
  }

  @override
  void dispose() {
    _isScrollableController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: Colors.transparent),
        child: Scaffold(
          body: SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge(
                [
                  _isScrollableController,
                  _scrollController,
                ],
              ),
              builder: (context, child) => FadeBottomMask(
                startsAt: 0.65,
                isEnabled: _isFadeMaskEnabled,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Заголовок "Ошибка"
                    SliverPersistentHeader(
                      delegate: ErrorTitle(),
                      pinned: true,
                    ),

                    // Текст ошибки
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                                bottom: 96, left: 24, right: 24) +
                            EdgeInsets.only(
                                bottom: context.mediaQuery.padding.bottom),
                        child: Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: RestartButton(onRestart: _restart),
        ),
      );

  /// Перезапускает приложение
  void _restart() => AppInitializationScope.of(context)
      .bloc
      .add(const AppInitializationEvent.initialize());

  /// Устанавливает значение [_isScrollable]
  void _setIsScrollable() => WidgetsBinding.instance.addPostFrameCallback((_) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        _isScrollableController.value = maxScrollExtent > 0.0;
      });

  /// Возвращает true, если [FadeBottomMask] включена
  bool get _isFadeMaskEnabled {
    if (!_scrollController.hasClients) return _isScrollableController.value;
    return _scrollController.offset <
        _scrollController.position.maxScrollExtent * .9;
  }
}
