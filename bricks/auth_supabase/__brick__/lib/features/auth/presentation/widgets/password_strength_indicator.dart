import 'package:flutter/material.dart';
import '../../domain/value_objects/password.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final Password password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final strength = password.strength;
    final strengthText = password.strengthText;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password Strength: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              strengthText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getStrengthColor(context, strength),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < 4 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: index < strength 
                      ? _getStrengthColor(context, strength)
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        _buildRequirements(context),
      ],
    );
  }

  Color _getStrengthColor(BuildContext context, int strength) {
    switch (strength) {
      case 1:
      case 2:
        return Theme.of(context).colorScheme.error;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }

  Widget _buildRequirements(BuildContext context) {
    final value = password.value;
    
    final requirements = [
      _RequirementItem(
        text: 'At least 8 characters',
        isMet: value.length >= 8,
      ),
      _RequirementItem(
        text: 'Uppercase letter',
        isMet: value.contains(RegExp(r'[A-Z]')),
      ),
      _RequirementItem(
        text: 'Lowercase letter',
        isMet: value.contains(RegExp(r'[a-z]')),
      ),
      _RequirementItem(
        text: 'Number',
        isMet: value.contains(RegExp(r'\d')),
      ),
      _RequirementItem(
        text: 'Special character',
        isMet: value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(
                req.isMet ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 16,
                color: req.isMet 
                    ? Colors.green 
                    : Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Text(
                req.text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: req.isMet 
                      ? Colors.green 
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RequirementItem {
  final String text;
  final bool isMet;

  _RequirementItem({
    required this.text,
    required this.isMet,
  });
}