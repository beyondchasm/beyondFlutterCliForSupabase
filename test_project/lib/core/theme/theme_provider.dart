import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.system;
  late SharedPreferences _prefs;
  
  AppThemeMode get themeMode => _themeMode;
  
  ThemeMode get flutterThemeMode => _themeMode == AppThemeMode.dark 
      ? ThemeMode.dark 
      : _themeMode == AppThemeMode.light 
          ? ThemeMode.light 
          : ThemeMode.system;
  
  bool get isDarkMode {
    if (_themeMode == AppThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == AppThemeMode.dark;
  }
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadThemeMode();
    
    // Listen to system theme changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (_themeMode == AppThemeMode.system) {
        notifyListeners();
      }
    };
  }
  
  void _loadThemeMode() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => AppThemeMode.system,
      );
    }
    notifyListeners();
  }
  
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.toString());
    
    // Update system UI overlay style
    _updateSystemUIOverlayStyle();
    
    notifyListeners();
  }
  
  void _updateSystemUIOverlayStyle() {
    final isDark = isDarkMode;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
  
  void toggleTheme() {
    switch (_themeMode) {
      case AppThemeMode.system:
        setThemeMode(AppThemeMode.light);
        break;
      case AppThemeMode.light:
        setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        setThemeMode(AppThemeMode.system);
        break;
    }
  }
  
  String get themeModeText {
    switch (_themeMode) {
      case AppThemeMode.system:
        return '시스템';
      case AppThemeMode.light:
        return '라이트';
      case AppThemeMode.dark:
        return '다크';
    }
  }
  
  IconData get themeModeIcon {
    switch (_themeMode) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.brightness_7;
      case AppThemeMode.dark:
        return Icons.brightness_4;
    }
  }
}