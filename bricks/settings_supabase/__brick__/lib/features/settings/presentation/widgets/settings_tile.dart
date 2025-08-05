import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  factory SettingsTile.switchTile({
    Key? key,
    required String title,
    String? subtitle,
    Widget? leading,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool enabled = true,
  }) {
    return SettingsTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      enabled: enabled,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      onTap: enabled && onChanged != null 
          ? () => onChanged(!value)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: enabled 
              ? colorScheme.onSurface 
              : colorScheme.onSurface.withOpacity(0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: enabled 
                    ? colorScheme.onSurfaceVariant 
                    : colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            )
          : null,
      leading: leading != null
          ? IconTheme(
              data: IconThemeData(
                color: enabled 
                    ? colorScheme.onSurfaceVariant 
                    : colorScheme.onSurfaceVariant.withOpacity(0.6),
                size: 24,
              ),
              child: leading!,
            )
          : null,
      trailing: trailing ?? (onTap != null 
          ? Icon(
              Icons.chevron_right,
              color: enabled 
                  ? colorScheme.onSurfaceVariant 
                  : colorScheme.onSurfaceVariant.withOpacity(0.6),
            )
          : null),
      onTap: enabled ? onTap : null,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}