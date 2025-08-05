import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/app_settings.dart';

part 'app_settings_local_model.freezed.dart';
part 'app_settings_local_model.g.dart';

@freezed
class AppSettingsLocalModel with _$AppSettingsLocalModel {
  const factory AppSettingsLocalModel({
    // Theme Settings
    @Default('system') String themeMode,
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
    @Default('fiveMinutes') String autoLockDuration,
    @Default(false) bool requireAuthForSensitiveActions,
    
    // Data & Storage
    @Default(true) bool autoBackupEnabled,
    @Default('realTime') String dataSyncFrequency,
    @Default(false) bool wifiOnlySync,
    @Default('medium') String cacheSize,
    @Default(false) bool offlineModeEnabled,
    
    // App Behavior
    @Default(false) bool autoStartEnabled,
    @Default(true) bool confirmBeforeDelete,
    @Default(false) bool showOnboardingOnStart,
    @Default('home') String defaultStartScreen,
    @Default(false) bool enableExperimentalFeatures,
    
    // Accessibility
    @Default(1.0) double textScale,
    @Default(false) bool highContrastEnabled,
    @Default(false) bool reduceAnimationsEnabled,
    @Default(false) bool screenReaderEnabled,
    
    // Developer Settings
    @Default(false) bool debugModeEnabled,
    @Default(false) bool showPerformanceOverlay,
    @Default('info') String logLevel,
    
    // Metadata
    required String createdAt,
    String? updatedAt,
    @Default(1) int version,
  }) = _AppSettingsLocalModel;

  const AppSettingsLocalModel._();

  factory AppSettingsLocalModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsLocalModelFromJson(json);

  /// Convert to domain entity
  AppSettings toEntity() {
    return AppSettings(
      themeMode: _parseThemeMode(themeMode),
      useMaterialYou: useMaterialYou,
      accentColor: accentColor,
      language: language,
      country: country,
      use24HourFormat: use24HourFormat,
      dateFormat: dateFormat,
      pushNotificationsEnabled: pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled,
      inAppNotificationsEnabled: inAppNotificationsEnabled,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      notificationSound: notificationSound,
      biometricAuthEnabled: biometricAuthEnabled,
      analyticsEnabled: analyticsEnabled,
      crashReportingEnabled: crashReportingEnabled,
      autoLockDuration: _parseAutoLockDuration(autoLockDuration),
      requireAuthForSensitiveActions: requireAuthForSensitiveActions,
      autoBackupEnabled: autoBackupEnabled,
      dataSyncFrequency: _parseDataSyncFrequency(dataSyncFrequency),
      wifiOnlySync: wifiOnlySync,
      cacheSize: _parseCacheSize(cacheSize),
      offlineModeEnabled: offlineModeEnabled,
      autoStartEnabled: autoStartEnabled,
      confirmBeforeDelete: confirmBeforeDelete,
      showOnboardingOnStart: showOnboardingOnStart,
      defaultStartScreen: _parseDefaultScreen(defaultStartScreen),
      enableExperimentalFeatures: enableExperimentalFeatures,
      textScale: textScale,
      highContrastEnabled: highContrastEnabled,
      reduceAnimationsEnabled: reduceAnimationsEnabled,
      screenReaderEnabled: screenReaderEnabled,
      debugModeEnabled: debugModeEnabled,
      showPerformanceOverlay: showPerformanceOverlay,
      logLevel: _parseLogLevel(logLevel),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      version: version,
    );
  }

  /// Create from domain entity
  factory AppSettingsLocalModel.fromEntity(AppSettings entity) {
    return AppSettingsLocalModel(
      themeMode: entity.themeMode.name,
      useMaterialYou: entity.useMaterialYou,
      accentColor: entity.accentColor,
      language: entity.language,
      country: entity.country,
      use24HourFormat: entity.use24HourFormat,
      dateFormat: entity.dateFormat,
      pushNotificationsEnabled: entity.pushNotificationsEnabled,
      emailNotificationsEnabled: entity.emailNotificationsEnabled,
      inAppNotificationsEnabled: entity.inAppNotificationsEnabled,
      soundEnabled: entity.soundEnabled,
      vibrationEnabled: entity.vibrationEnabled,
      notificationSound: entity.notificationSound,
      biometricAuthEnabled: entity.biometricAuthEnabled,
      analyticsEnabled: entity.analyticsEnabled,
      crashReportingEnabled: entity.crashReportingEnabled,
      autoLockDuration: entity.autoLockDuration.name,
      requireAuthForSensitiveActions: entity.requireAuthForSensitiveActions,
      autoBackupEnabled: entity.autoBackupEnabled,
      dataSyncFrequency: entity.dataSyncFrequency.name,
      wifiOnlySync: entity.wifiOnlySync,
      cacheSize: entity.cacheSize.name,
      offlineModeEnabled: entity.offlineModeEnabled,
      autoStartEnabled: entity.autoStartEnabled,
      confirmBeforeDelete: entity.confirmBeforeDelete,
      showOnboardingOnStart: entity.showOnboardingOnStart,
      defaultStartScreen: entity.defaultStartScreen.name,
      enableExperimentalFeatures: entity.enableExperimentalFeatures,
      textScale: entity.textScale,
      highContrastEnabled: entity.highContrastEnabled,
      reduceAnimationsEnabled: entity.reduceAnimationsEnabled,
      screenReaderEnabled: entity.screenReaderEnabled,
      debugModeEnabled: entity.debugModeEnabled,
      showPerformanceOverlay: entity.showPerformanceOverlay,
      logLevel: entity.logLevel.name,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
      version: entity.version,
    );
  }

  // Parsing methods
  AppThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  AutoLockDuration _parseAutoLockDuration(String value) {
    switch (value) {
      case 'never':
        return AutoLockDuration.never;
      case 'oneMinute':
        return AutoLockDuration.oneMinute;
      case 'fifteenMinutes':
        return AutoLockDuration.fifteenMinutes;
      case 'thirtyMinutes':
        return AutoLockDuration.thirtyMinutes;
      case 'oneHour':
        return AutoLockDuration.oneHour;
      default:
        return AutoLockDuration.fiveMinutes;
    }
  }

  DataSyncFrequency _parseDataSyncFrequency(String value) {
    switch (value) {
      case 'hourly':
        return DataSyncFrequency.hourly;
      case 'daily':
        return DataSyncFrequency.daily;
      case 'weekly':
        return DataSyncFrequency.weekly;
      case 'manual':
        return DataSyncFrequency.manual;
      default:
        return DataSyncFrequency.realTime;
    }
  }

  CacheSize _parseCacheSize(String value) {
    switch (value) {
      case 'small':
        return CacheSize.small;
      case 'large':
        return CacheSize.large;
      case 'unlimited':
        return CacheSize.unlimited;
      default:
        return CacheSize.medium;
    }
  }

  DefaultScreen _parseDefaultScreen(String value) {
    switch (value) {
      case 'profile':
        return DefaultScreen.profile;
      case 'settings':
        return DefaultScreen.settings;
      case 'lastUsed':
        return DefaultScreen.lastUsed;
      default:
        return DefaultScreen.home;
    }
  }

  LogLevel _parseLogLevel(String value) {
    switch (value) {
      case 'debug':
        return LogLevel.debug;
      case 'warning':
        return LogLevel.warning;
      case 'error':
        return LogLevel.error;
      case 'none':
        return LogLevel.none;
      default:
        return LogLevel.info;
    }
  }
}