import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';

@immutable
class DefinitionsView extends StatefulWidget {
  /// Заголовок
  final String title;

  /// Определения
  final List<Definition> definitions;

  DefinitionsView({
    required this.title,
    required this.definitions,
    super.key,
  }) : assert(definitions.isNotEmpty, 'Definitions should never be empty');

  @override
  State<DefinitionsView> createState() => _DefinitionsViewState();
}

class _DefinitionsViewState extends State<DefinitionsView> {
  /// {@template page_controller}
  /// Контроллер страниц в [PageView]
  /// {@endtemplate}
  late final PageController _pageController;

  /// {@template current_page_controller}
  /// Контроллер текущей страницы
  /// {@endtemplate}
  late final ValueNotifier<int> _currentPageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: .8);
    _currentPageController = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _currentPageController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WordTitle(widget.title),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox.fromSize(
              size: const Size.fromHeight(120),
              child: AnimatedBuilder(
                animation: _currentPageController,
                builder: (context, child) => PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.definitions.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AnimatedScale(
                      scale: _isCurrent(index) ? 1.0 : 0.95,
                      duration: Durations.short4,
                      child: AnimatedOpacity(
                        opacity: _isCurrent(index) ? 1.0 : 0.5,
                        duration: Durations.short4,
                        child: DefinitionTile(
                          definition: widget.definitions[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.definitions.length > 1) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController, // PageController
                  count: widget.definitions.length,
                  effect: ScrollingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    dotColor: context.theme.colors.grey,
                    activeDotColor: context.theme.colors.blue,
                  ), // your preferred effect
                  onDotClicked: _onDotClicked,
                ),
              ),
            ),
          ],
        ],
      );

  /// Обрбаотчик нажатия на инидкатор страницы
  Future<void> _onDotClicked(int index) => _pageController.animateToPage(index,
      duration: Durations.short4, curve: Curves.linear);

  /// Обработчик на смену страницы
  void _onPageChanged(int page) {
    if (_currentPageController.value != page) {
      _currentPageController.value = page;
    }
  }

  /// Возвращает true, если индекс равен текущей странице
  bool _isCurrent(int index) => _currentPageController.value == index;
}
