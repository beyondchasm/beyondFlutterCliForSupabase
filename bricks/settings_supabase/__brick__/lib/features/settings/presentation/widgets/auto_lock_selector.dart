import 'package:flutter/material.dart';
import '../../domain/entities/app_settings.dart';

class AutoLockSelector extends StatelessWidget {  
  final AutoLockDuration currentDuration;
  final ValueChanged<AutoLockDuration> onDurationChanged;

  const AutoLockSelector({
    super.key,
    required this.currentDuration,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Auto Lock',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Automatically lock the app after inactivity',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...AutoLockDuration.values.map((duration) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildDurationOption(context, duration),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDurationOption(BuildContext context, AutoLockDuration duration) {
    final isSelected = currentDuration == duration;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          _getDurationIcon(duration),
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(
          duration.displayName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: duration == AutoLockDuration.never
            ? Text(
                'App will never lock automatically',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () => onDurationChanged(duration),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  IconData _getDurationIcon(AutoLockDuration duration) {
    switch (duration) {
      case AutoLockDuration.never:
        return Icons.lock_open_outlined;
      case AutoLockDuration.oneMinute:
        return Icons.timer_outlined;
      case AutoLockDuration.fiveMinutes:
        return Icons.timer_outlined;
      case AutoLockDuration.fifteenMinutes:
        return Icons.schedule_outlined;
      case AutoLockDuration.thirtyMinutes:
        return Icons.schedule_outlined;
      case AutoLockDuration.oneHour:
        return Icons.access_time_outlined;
    }
  }
}