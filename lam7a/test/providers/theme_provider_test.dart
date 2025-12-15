import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    test('initial state is false (light theme)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final isDark = container.read(themeProviderProvider);
      expect(isDark, isFalse);
    });

    test('setDarkTheme sets state to true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeProviderProvider.notifier);
      notifier.setDarkTheme();

      final isDark = container.read(themeProviderProvider);
      expect(isDark, isTrue);
    });

    test('setLightTheme sets state to false after dark', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeProviderProvider.notifier);
      notifier.setDarkTheme();
      expect(container.read(themeProviderProvider), isTrue);

      notifier.setLightTheme();
      expect(container.read(themeProviderProvider), isFalse);
    });
  });
}
