import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeProvider extends _$ThemeProvider {
  @override
  bool build(){
    return false; // isDark = false
  }
  void setDarkTheme(){
    state = true;
  }
  void setLightTheme(){
    state = false;
  }
}