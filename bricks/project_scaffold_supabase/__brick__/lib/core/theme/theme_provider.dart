import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

class ThemeState {
  final AppThemeMode themeMode;
  final bool isLoading;

  const ThemeState({
    this.themeMode = AppThemeMode.system,
    this.isLoading = false,
  });

  ThemeMode get flutterThemeMode => themeMode == AppThemeMode.dark
      ? ThemeMode.dark
      : themeMode == AppThemeMode.light
      ? ThemeMode.light
      : ThemeMode.system;

  ThemeState copyWith({AppThemeMode? themeMode, bool? isLoading}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;

  ThemeNotifier() : super(const ThemeState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final themeMode = _loadThemeMode();
    state = state.copyWith(themeMode: themeMode);
    
    // Listen to system theme changes
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (state.themeMode == AppThemeMode.system) {
        // Notify listeners when system theme changes
        state = state.copyWith();
      }
    };
  }

  bool get isDarkMode {
    final currentTheme = state.themeMode;
    if (currentTheme == AppThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return currentTheme == AppThemeMode.dark;
  }

  AppThemeMode _loadThemeMode() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      return AppThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => AppThemeMode.system,
      );
    }
    return AppThemeMode.system;
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (state.themeMode == mode) return;

    state = state.copyWith(isLoading: true);

    try {
      await _prefs.setString(_themeKey, mode.toString());

      // Update system UI overlay style
      _updateSystemUIOverlayStyle(mode);

      state = ThemeState(themeMode: mode, isLoading: false);
    } catch (e) {
      // Handle error appropriately
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  void _updateSystemUIOverlayStyle(AppThemeMode themeMode) {
    bool isDark;
    if (themeMode == AppThemeMode.system) {
      isDark =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    } else {
      isDark = themeMode == AppThemeMode.dark;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  void toggleTheme() {
    final currentTheme = state.themeMode;
    switch (currentTheme) {
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
    final currentTheme = state.themeMode;
    switch (currentTheme) {
      case AppThemeMode.system:
        return '시스템';
      case AppThemeMode.light:
        return '라이트';
      case AppThemeMode.dark:
        return '다크';
    }
  }

  IconData get themeModeIcon {
    final currentTheme = state.themeMode;
    switch (currentTheme) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.brightness_7;
      case AppThemeMode.dark:
        return Icons.brightness_4;
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
