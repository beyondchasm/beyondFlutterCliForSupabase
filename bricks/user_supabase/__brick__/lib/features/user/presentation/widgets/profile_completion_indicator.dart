import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

class ProfileCompletionIndicator extends StatelessWidget {
  final UserProfile userProfile;
  final VoidCallback? onTap;

  const ProfileCompletionIndicator({
    super.key,
    required this.userProfile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completionPercentage = userProfile.completionPercentage;
    final color = _getCompletionColor(context, completionPercentage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  completionPercentage == 100 
                      ? Icons.check_circle 
                      : Icons.account_circle_outlined,
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Completion',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getCompletionMessage(completionPercentage),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$completionPercentage%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
            if (completionPercentage < 100) ...[
              const SizedBox(height: 12),
              Text(
                'Complete your profile to unlock all features',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCompletionColor(BuildContext context, int percentage) {
    if (percentage == 100) {
      return Colors.green;
    } else if (percentage >= 70) {
      return Colors.lightGreen;
    } else if (percentage >= 40) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.error;
    }
  }

  String _getCompletionMessage(int percentage) {
    if (percentage == 100) {
      return 'Your profile is complete!';
    } else if (percentage >= 70) {
      return 'Almost there! Just a few more details.';
    } else if (percentage >= 40) {
      return 'Good start! Add more information.';
    } else {
      return 'Let\'s complete your profile.';
    }
  }
}