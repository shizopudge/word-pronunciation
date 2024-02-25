import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/app_kit/app_kit.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';

/// Шит фильтра истории слов
@immutable
class WordHistoryFilterSheet extends StatefulWidget {
  /// Начальное значение
  final WordHistoryFilter? initialValue;

  /// Создает шит фильтра истории слов
  const WordHistoryFilterSheet._({
    required this.initialValue,
  });

  static Future<WordHistoryFilter?> show(
    BuildContext context, {
    required WordHistoryFilter? initialValue,
  }) =>
      showPrimaryBottomSheet<WordHistoryFilter?>(
        context: context,
        title: context.localization.historyFilter,
        builder: (context) =>
            WordHistoryFilterSheet._(initialValue: initialValue),
      );

  @override
  State<WordHistoryFilterSheet> createState() => _WordHistoryFilterSheetState();
}

class _WordHistoryFilterSheetState extends State<WordHistoryFilterSheet> {
  /// Контроллер
  late final ValueNotifier<WordHistoryFilter?> _controller;

  @override
  void initState() {
    super.initState();
    _controller = ValueNotifier<WordHistoryFilter?>(widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Padding(
          padding: EdgeInsets.only(
              top: 20, bottom: context.mediaQuery.padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _FilterTile(
                        onTap: _onFilterTap,
                        isSelected: _isSelected,
                        filter: WordHistoryFilter.all,
                      ),
                      _FilterTile(
                        onTap: _onFilterTap,
                        isSelected: _isSelected,
                        filter: WordHistoryFilter.pronounced,
                      ),
                      _FilterTile(
                        onTap: _onFilterTap,
                        isSelected: _isSelected,
                        filter: WordHistoryFilter.incorrect,
                      ),
                    ],
                  ),
                ),
              ),
              _ApplyFilterButton(onTap: _onApplyFilter),
            ],
          ),
        ),
      );

  /// Обработчик нажатия на фильтр
  void _onFilterTap(WordHistoryFilter newFilter) {
    if (_controller.value != newFilter) {
      _controller.value = newFilter;
    }
  }

  /// Возвращает true, если фильтр выбран
  bool _isSelected(WordHistoryFilter filter) => _controller.value == filter;

  /// Обработчик нажатия на кнопку "Применить фильтр"
  void _onApplyFilter() =>
      Navigator.of(context).pop<WordHistoryFilter?>(_controller.value);
}

/// Плитка фильтра
@immutable
class _FilterTile extends StatelessWidget {
  /// Обработчик нажатия
  final ValueSetter<WordHistoryFilter> onTap;

  /// Если true, значит опция выбрана
  final bool Function(WordHistoryFilter filter) isSelected;

  /// Фильтр
  final WordHistoryFilter filter;

  /// Создает плитку фильтра
  const _FilterTile({
    required this.onTap,
    required this.isSelected,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTap(filter),
        highlightColor: context.theme.colors.blue.withOpacity(.2),
        splashColor: context.theme.colors.blue.withOpacity(.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  filter.toText(context),
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Checkbox(
                value: isSelected(filter),
                shape: const CircleBorder(),
                onChanged: null,
              ),
            ],
          ),
        ),
      );
}

/// Кнопка "Применить фильтр"
@immutable
class _ApplyFilterButton extends StatelessWidget {
  /// Обработчик нажатия
  final VoidCallback onTap;

  /// Создает кнопку "Применить фильтр"
  const _ApplyFilterButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryElevatedButton(
          onTap: onTap,
          child: Text(
            context.localization.applyFilter,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
}
