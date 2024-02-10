/// Енум режима темы приложения
enum AppThemeMode {
  dark,
  light,
  system;

  bool get isDark => this == AppThemeMode.dark;

  bool get isLight => this == AppThemeMode.light;

  bool get isSystem => this == AppThemeMode.system;

  @override
  String toString() => switch (this) {
        AppThemeMode.dark => 'dark',
        AppThemeMode.light => 'light',
        AppThemeMode.system => 'system',
      };

  factory AppThemeMode.fromString(String? str) {
    if (str == 'dark') return AppThemeMode.dark;
    if (str == 'light') return AppThemeMode.light;
    return AppThemeMode.system;
  }
}
