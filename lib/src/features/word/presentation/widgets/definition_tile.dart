import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';

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
        onTap: _onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                definition.data,
                maxLines: definition.example.isNotEmpty ? 1 : 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: context.theme.isDark
                      ? context.theme.colors.white
                      : context.theme.colors.black,
                ),
              ),
              if (definition.example.isNotEmpty) ...[
                const Divider(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Example:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.theme.isDark
                          ? context.theme.colors.white
                          : context.theme.colors.black,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      definition.example,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: context.theme.isDark
                            ? context.theme.colors.white
                            : context.theme.colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  /// Обработчик нажатия
  Future<void> _onTap() => Future<void>.value();
}
