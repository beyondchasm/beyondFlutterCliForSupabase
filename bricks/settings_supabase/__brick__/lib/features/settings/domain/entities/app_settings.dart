import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // Theme Settings
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(false) bool useMaterialYou,
    @Default('system') String accentColor,
    
    // Language & Localization
    @Default('system') String language,
    @Default('system') String country,
    @Default(false) bool use24HourFormat,
    @Default('system') String dateFormat,
    
    // Notifications
    @Default(true) bool pushNotificationsEnabled,
    @Default(true) bool emailNotificationsEnabled,
    @Default(true) bool inAppNotificationsEnabled,
    @Default(true) bool soundEnabled,
    @Default(true) bool vibrationEnabled,
    @Default('default') String notificationSound,
    
    // Privacy & Security
    @Default(false) bool biometricAuthEnabled,
    @Default(true) bool analyticsEnabled,
    @Default(false) bool crashReportingEnabled,
    @Default(AutoLockDuration.fiveMinutes) AutoLockDuration autoLockDuration,
    @Default(false) bool requireAuthForSensitiveActions,
    
    // Data & Storage
    @Default(true) bool autoBackupEnabled,
    @Default(DataSyncFrequency.realTime) DataSyncFrequency dataSyncFrequency,
    @Default(false) bool wifiOnlySync,
    @Default(CacheSize.medium) CacheSize cacheSize,
    @Default(false) bool offlineModeEnabled,
    
    // App Behavior
    @Default(false) bool autoStartEnabled,
    @Default(true) bool confirmBeforeDelete,
    @Default(false) bool showOnboardingOnStart,
    @Default(DefaultScreen.home) DefaultScreen defaultStartScreen,
    @Default(false) bool enableExperimentalFeatures,
    
    // Accessibility
    @Default(1.0) double textScale,
    @Default(false) bool highContrastEnabled,
    @Default(false) bool reduceAnimationsEnabled,
    @Default(false) bool screenReaderEnabled,
    
    // Developer Settings (only shown in debug mode)
    @Default(false) bool debugModeEnabled,
    @Default(false) bool showPerformanceOverlay,
    @Default(LogLevel.info) LogLevel logLevel,
    
    // Metadata
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(1) int version,
  }) = _AppSettings;

  const AppSettings._();

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// Create default settings
  factory AppSettings.defaults() {
    return AppSettings(
      createdAt: DateTime.now(),
    );
  }

  /// Get current theme brightness
  Brightness get effectiveBrightness {
    switch (themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        // This would need to be determined by the system
        return Brightness.light;
    }
  }

  /// Check if notifications are enabled
  bool get hasAnyNotificationsEnabled {
    return pushNotificationsEnabled || 
           emailNotificationsEnabled || 
           inAppNotificationsEnabled;
  }

  /// Check if privacy features are enabled
  bool get hasPrivacyFeaturesEnabled {
    return !analyticsEnabled || !crashReportingEnabled;
  }

  /// Check if accessibility features are enabled
  bool get hasAccessibilityFeaturesEnabled {
    return textScale != 1.0 || 
           highContrastEnabled || 
           reduceAnimationsEnabled || 
           screenReaderEnabled;
  }

  /// Validate settings
  List<String> validate() {
    final errors = <String>[];
    
    if (textScale < 0.5 || textScale > 3.0) {
      errors.add('Text scale must be between 0.5 and 3.0');
    }
    
    return errors;
  }

  /// Copy with updated timestamp
  AppSettings copyWithTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }
}

enum ThemeMode {
  system,
  light,
  dark,
}

enum AutoLockDuration {
  never,
  oneMinute,
  fiveMinutes,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
}

enum DataSyncFrequency {
  realTime,
  hourly,
  daily,
  weekly,
  manual,
}

enum CacheSize {
  small,
  medium,
  large,
  unlimited,
}

enum DefaultScreen {
  home,
  profile,
  settings,
  lastUsed,
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
  none,
}

// Extension methods for better UX
extension AutoLockDurationX on AutoLockDuration {
  Duration get duration {
    switch (this) {
      case AutoLockDuration.never:
        return Duration.zero;
      case AutoLockDuration.oneMinute:
        return const Duration(minutes: 1);
      case AutoLockDuration.fiveMinutes:
        return const Duration(minutes: 5);
      case AutoLockDuration.fifteenMinutes:
        return const Duration(minutes: 15);
      case AutoLockDuration.thirtyMinutes:
        return const Duration(minutes: 30);
      case AutoLockDuration.oneHour:
        return const Duration(hours: 1);
    }
  }

  String get displayName {
    switch (this) {
      case AutoLockDuration.never:
        return 'Never';
      case AutoLockDuration.oneMinute:
        return '1 minute';
      case AutoLockDuration.fiveMinutes:
        return '5 minutes';
      case AutoLockDuration.fifteenMinutes:
        return '15 minutes';
      case AutoLockDuration.thirtyMinutes:
        return '30 minutes';
      case AutoLockDuration.oneHour:
        return '1 hour';
    }
  }
}

extension DataSyncFrequencyX on DataSyncFrequency {
  String get displayName {
    switch (this) {
      case DataSyncFrequency.realTime:
        return 'Real-time';
      case DataSyncFrequency.hourly:
        return 'Every hour';
      case DataSyncFrequency.daily:
        return 'Daily';
      case DataSyncFrequency.weekly:
        return 'Weekly';
      case DataSyncFrequency.manual:
        return 'Manual only';
    }
  }
}

extension CacheSizeX on CacheSize {
  String get displayName {
    switch (this) {
      case CacheSize.small:
        return 'Small (50MB)';
      case CacheSize.medium:
        return 'Medium (200MB)';
      case CacheSize.large:
        return 'Large (500MB)';
      case CacheSize.unlimited:
        return 'Unlimited';
    }
  }

  int get sizeInMB {
    switch (this) {
      case CacheSize.small:
        return 50;
      case CacheSize.medium:
        return 200;
      case CacheSize.large:
        return 500;
      case CacheSize.unlimited:
        return -1;
    }
  }
}