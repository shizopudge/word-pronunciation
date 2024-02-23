import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/definition_sheet.dart';

/// Плитка с определением
@immutable
class DefinitionTile extends StatelessWidget {
  /// Данные
  final Definition definition;

  /// Создает плитку с определением
  const DefinitionTile({
    required this.definition,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => _onTap(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              definition.data,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: context.theme.isDark
                    ? context.theme.colors.white
                    : context.theme.colors.black,
              ),
            ),
          ),
        ),
      );

  /// Обработчик нажатия
  Future<void> _onTap(BuildContext context) =>
      DefinitionSheet.show(context, definition: definition);
}
