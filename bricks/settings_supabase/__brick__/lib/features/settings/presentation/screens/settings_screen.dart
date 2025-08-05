import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_selector.dart';
import '../widgets/language_selector.dart';
import '../widgets/auto_lock_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SettingsProvider>();
      if (provider.settings == null) {
        provider.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_upload_outlined),
                    SizedBox(width: 12),
                    Text('Export Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_download_outlined),
                    SizedBox(width: 12),
                    Text('Import Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restore, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Reset to Defaults', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading settings',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.initialize(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.settings == null) {
            return const Center(
              child: Text('No settings available'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.initialize(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAppearanceSection(provider),
                  const SizedBox(height: 16),
                  _buildNotificationsSection(provider),
                  const SizedBox(height: 16),
                  _buildPrivacySecuritySection(provider),
                  const SizedBox(height: 16),
                  _buildDataStorageSection(provider),
                  const SizedBox(height: 16),
                  _buildAccessibilitySection(provider),
                  const SizedBox(height: 16),
                  _buildAboutSection(provider),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppearanceSection(SettingsProvider provider) {
    final settings = provider.settings!;
    
    return SettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        SettingsTile(
          title: 'Theme',
          subtitle: _getThemeModeText(settings.themeMode),
          leading: const Icon(Icons.brightness_6_outlined),
          onTap: () => _showThemeSelector(context, provider),
        ),
        SettingsTile(
          title: 'Language',
          subtitle: _getLanguageText(settings.language),
          leading: const Icon(Icons.language_outlined),
          onTap: () => _showLanguageSelector(context, provider),
        ),
        SettingsTile.switchTile(
          title: 'Material You Colors',
          subtitle: 'Use dynamic colors from wallpaper',
          leading: const Icon(Icons.auto_awesome_outlined),
          value: settings.useMaterialYou,
          onChanged: (value) => provider.updateSetting('useMaterialYou', value),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(SettingsProvider provider) {
    final settings = provider.settings!;
    
    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        SettingsTile.switchTile(
          title: 'Push Notifications',
          subtitle: 'Receive notifications on your device',
          leading: const Icon(Icons.notifications_active_outlined),
          value: settings.pushNotificationsEnabled,
          onChanged: (value) => provider.updateSetting('pushNotificationsEnabled', value),
        ),
        SettingsTile.switchTile(
          title: 'Email Notifications',
          subtitle: 'Receive notifications via email',
          leading: const Icon(Icons.email_outlined),
          value: settings.emailNotificationsEnabled,
          onChanged: (value) => provider.updateSetting('emailNotificationsEnabled', value),
        ),
        SettingsTile.switchTile(
          title: 'In-App Notifications',
          subtitle: 'Show notifications within the app',
          leading: const Icon(Icons.app_blocking_outlined),
          value: settings.inAppNotificationsEnabled,
          onChanged: (value) => provider.updateSetting('inAppNotificationsEnabled', value),
        ),
        SettingsTile.switchTile(
          title: 'Sound',
          subtitle: 'Play sound for notifications',
          leading: const Icon(Icons.volume_up_outlined),
          value: settings.soundEnabled,
          onChanged: (value) => provider.updateSetting('soundEnabled', value),
        ),
        SettingsTile.switchTile(
          title: 'Vibration',
          subtitle: 'Vibrate for notifications',
          leading: const Icon(Icons.vibration_outlined),
          value: settings.vibrationEnabled,
          onChanged: (value) => provider.updateSetting('vibrationEnabled', value),
        ),
      ],
    );
  }

  Widget _buildPrivacySecuritySection(SettingsProvider provider) {
    final settings = provider.settings!;
    
    return SettingsSection(
      title: 'Privacy & Security',
      icon: Icons.security_outlined,
      children: [
        SettingsTile.switchTile(
          title: 'Biometric Authentication',
          subtitle: 'Use fingerprint or face unlock',
          leading: const Icon(Icons.fingerprint_outlined),
          value: settings.biometricAuthEnabled,
          onChanged: (value) => provider.toggleBiometricAuth(value),
        ),
        SettingsTile(
          title: 'Auto Lock',
          subtitle: settings.autoLockDuration.displayName,
          leading: const Icon(Icons.lock_clock_outlined),
          onTap: () => _showAutoLockSelector(context, provider),
        ),
        SettingsTile.switchTile(
          title: 'Require Auth for Sensitive Actions',
          subtitle: 'Ask for authentication before sensitive operations',
          leading: const Icon(Icons.security_outlined),
          value: settings.requireAuthForSensitiveActions,
          onChanged: (value) => provider.updateSetting('requireAuthForSensitiveActions', value),
        ),
        SettingsTile.switchTile(
          title: 'Analytics',
          subtitle: 'Help improve the app by sharing usage data',
          leading: const Icon(Icons.analytics_outlined),
          value: settings.analyticsEnabled,
          onChanged: (value) => provider.toggleAnalytics(value),
        ),
        SettingsTile.switchTile(
          title: 'Crash Reporting',
          subtitle: 'Automatically send crash reports',
          leading: const Icon(Icons.bug_report_outlined),
          value: settings.crashReportingEnabled,
          onChanged: (value) => provider.updateSetting('crashReportingEnabled', value),
        ),
      ],
    );
  }

  Widget _buildDataStorageSection(SettingsProvider provider) {
    final settings = provider.settings!;
    
    return SettingsSection(
      title: 'Data & Storage',
      icon: Icons.storage_outlined,
      children: [
        SettingsTile.switchTile(
          title: 'Auto Backup',
          subtitle: 'Automatically backup your data',
          leading: const Icon(Icons.backup_outlined),
          value: settings.autoBackupEnabled,
          onChanged: (value) => provider.updateSetting('autoBackupEnabled', value),
        ),
        SettingsTile(
          title: 'Sync Frequency',
          subtitle: settings.dataSyncFrequency.displayName,
          leading: const Icon(Icons.sync_outlined),
          onTap: () => _showSyncFrequencySelector(context, provider),
        ),
        SettingsTile.switchTile(
          title: 'WiFi Only Sync',
          subtitle: 'Only sync when connected to WiFi',
          leading: const Icon(Icons.wifi_outlined),
          value: settings.wifiOnlySync,
          onChanged: (value) => provider.updateSetting('wifiOnlySync', value),
        ),
        SettingsTile(
          title: 'Cache Size',
          subtitle: settings.cacheSize.displayName,
          leading: const Icon(Icons.folder_outlined),
          onTap: () => _showCacheSizeSelector(context, provider),
        ),
      ],
    );
  }

  Widget _buildAccessibilitySection(SettingsProvider provider) {
    final settings = provider.settings!;
    
    return SettingsSection(
      title: 'Accessibility',
      icon: Icons.accessibility_outlined,
      children: [
        SettingsTile(
          title: 'Text Size',
          subtitle: '${(settings.textScale * 100).round()}%',
          leading: const Icon(Icons.text_fields_outlined),
          onTap: () => _showTextScaleSelector(context, provider),
        ),
        SettingsTile.switchTile(
          title: 'High Contrast',
          subtitle: 'Increase contrast for better visibility',
          leading: const Icon(Icons.contrast_outlined),
          value: settings.highContrastEnabled,
          onChanged: (value) => provider.updateSetting('highContrastEnabled', value),
        ),
        SettingsTile.switchTile(
          title: 'Reduce Animations',
          subtitle: 'Minimize motion for better focus',
          leading: const Icon(Icons.motion_photos_off_outlined),
          value: settings.reduceAnimationsEnabled,
          onChanged: (value) => provider.updateSetting('reduceAnimationsEnabled', value),
        ),
      ],
    );
  }

  Widget _buildAboutSection(SettingsProvider provider) {
    return SettingsSection(
      title: 'About',
      icon: Icons.info_outlined,
      children: [
        SettingsTile(
          title: 'Version',
          subtitle: '1.0.0+1',
          leading: const Icon(Icons.info_outlined),
          onTap: () => _showAboutDialog(),
        ),
        SettingsTile(
          title: 'Privacy Policy',
          leading: const Icon(Icons.privacy_tip_outlined),
          onTap: () => _openPrivacyPolicy(),
        ),
        SettingsTile(
          title: 'Terms of Service',
          leading: const Icon(Icons.article_outlined),
          onTap: () => _openTermsOfService(),
        ),
        SettingsTile(
          title: 'Contact Support',
          leading: const Icon(Icons.support_outlined),
          onTap: () => _contactSupport(),
        ),
      ],
    );
  }

  void _handleMenuAction(String action) async {
    final provider = context.read<SettingsProvider>();
    
    switch (action) {
      case 'export':
        await _exportSettings(provider);
        break;
      case 'import':
        await _importSettings(provider);
        break;
      case 'reset':
        await _showResetConfirmation(provider);
        break;
    }
  }

  void _showThemeSelector(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ThemeSelector(
        currentTheme: provider.settings!.themeMode,
        onThemeChanged: (theme) {
          provider.updateThemeMode(theme);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => LanguageSelector(
        currentLanguage: provider.settings!.language,
        onLanguageChanged: (language) {
          provider.updateLanguage(language);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAutoLockSelector(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AutoLockSelector(
        currentDuration: provider.settings!.autoLockDuration,
        onDurationChanged: (duration) {
          provider.updateAutoLockDuration(duration);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSyncFrequencySelector(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DataSyncFrequency.values.map((frequency) {
            return RadioListTile<DataSyncFrequency>(
              title: Text(frequency.displayName),
              value: frequency,
              groupValue: provider.settings!.dataSyncFrequency,
              onChanged: (value) {
                if (value != null) {
                  provider.updateSetting('dataSyncFrequency', value.name);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCacheSizeSelector(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cache Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CacheSize.values.map((size) {
            return RadioListTile<CacheSize>(
              title: Text(size.displayName),
              value: size,
              groupValue: provider.settings!.cacheSize,
              onChanged: (value) {
                if (value != null) {
                  provider.updateSetting('cacheSize', value.name);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTextScaleSelector(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Preview Text'),
            const SizedBox(height: 16),
            Slider(
              value: provider.settings!.textScale,
              min: 0.5,
              max: 3.0,
              divisions: 10,
              label: '${(provider.settings!.textScale * 100).round()}%',
              onChanged: (value) {
                provider.updateTextScale(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSettings(SettingsProvider provider) async {
    final settings = await provider.exportSettings();
    if (settings != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings exported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _importSettings(SettingsProvider provider) async {
    // TODO: Implement file picker and import logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Import feature coming soon'),
      ),
    );
  }

  Future<void> _showResetConfirmation(SettingsProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.resetToDefaults();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings reset to defaults'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Your App Name',
      applicationVersion: '1.0.0+1',
      applicationLegalese: '© 2024 Your Company Name',
      children: const [
        Text('This app was built with Flutter and Supabase.'),
      ],
    );
  }

  void _openPrivacyPolicy() {
    // TODO: Open privacy policy URL
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Privacy Policy...')),
    );
  }

  void _openTermsOfService() {
    // TODO: Open terms of service URL
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Terms of Service...')),
    );
  }

  void _contactSupport() {
    // TODO: Open email client or support page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Contact Support...')),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  String _getLanguageText(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'ko':
        return '한국어';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      default:
        return 'System';
    }
  }
}