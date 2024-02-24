import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/app_kit/app_kit.dart';

@immutable
class PermissionsAlert extends StatelessWidget {
  /// Описание
  final String description;

  /// Диалог с разрешениями
  const PermissionsAlert._({
    required this.description,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
  }) =>
      PrimaryAlert.show<bool?>(
        context: context,
        title: title,
        child: PermissionsAlert._(
          description: description,
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.theme.isDark
                  ? context.theme.colors.white
                  : context.theme.colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 12,
              right: 12,
              bottom: 16,
            ),
            child: PrimaryElevatedButton(
              onTap: () => Navigator.of(context).pop<bool>(true),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                maximumSize: const Size.fromHeight(54),
              ),
              child: Text(
                context.localization.openAppSettings,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodySmall?.copyWith(
                    color: context.theme.isDark
                        ? context.theme.colors.black
                        : context.theme.colors.white),
              ),
            ),
          ),
        ],
      );
}
