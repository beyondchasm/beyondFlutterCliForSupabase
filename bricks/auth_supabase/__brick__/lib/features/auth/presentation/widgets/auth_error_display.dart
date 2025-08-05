import 'package:flutter/material.dart';
import '../../domain/entities/auth_result.dart';

class AuthErrorDisplay extends StatelessWidget {
  final String errorMessage;
  final AuthErrorType errorType;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const AuthErrorDisplay({
    super.key,
    required this.errorMessage,
    required this.errorType,
    this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getErrorIcon(errorType),
                color: Theme.of(context).colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getErrorTitle(errorType),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, size: 20),
                  color: Theme.of(context).colorScheme.error,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _getActionSuggestion(errorType),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer.withOpacity(0.8),
            ),
          ),
          if (onRetry != null && _shouldShowRetryButton(errorType)) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Try Again'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getErrorIcon(AuthErrorType errorType) {
    switch (errorType) {
      case AuthErrorType.networkError:
        return Icons.wifi_off;
      case AuthErrorType.invalidCredentials:
        return Icons.lock_outline;
      case AuthErrorType.emailNotVerified:
        return Icons.email_outlined;
      case AuthErrorType.weakPassword:
        return Icons.security;
      case AuthErrorType.emailAlreadyInUse:
        return Icons.person_outline;
      case AuthErrorType.tooManyRequests:
        return Icons.access_time;
      case AuthErrorType.userNotFound:
        return Icons.person_off_outlined;
      case AuthErrorType.serverError:
        return Icons.error_outline;
      default:
        return Icons.warning_outlined;
    }
  }

  String _getErrorTitle(AuthErrorType errorType) {
    switch (errorType) {
      case AuthErrorType.networkError:
        return 'Network Error';
      case AuthErrorType.invalidCredentials:
        return 'Invalid Credentials';
      case AuthErrorType.emailNotVerified:
        return 'Email Not Verified';
      case AuthErrorType.weakPassword:
        return 'Weak Password';
      case AuthErrorType.emailAlreadyInUse:
        return 'Email Already In Use';
      case AuthErrorType.tooManyRequests:
        return 'Too Many Requests';
      case AuthErrorType.userNotFound:
        return 'User Not Found';
      case AuthErrorType.serverError:
        return 'Server Error';
      default:
        return 'Error';
    }
  }

  String _getActionSuggestion(AuthErrorType errorType) {
    switch (errorType) {
      case AuthErrorType.networkError:
        return 'Check your internet connection and try again.';
      case AuthErrorType.invalidCredentials:
        return 'Please check your email and password.';
      case AuthErrorType.emailNotVerified:
        return 'Check your email and click the verification link.';
      case AuthErrorType.weakPassword:
        return 'Use a stronger password with uppercase, lowercase, numbers, and special characters.';
      case AuthErrorType.emailAlreadyInUse:
        return 'This email is already registered. Try signing in instead.';
      case AuthErrorType.tooManyRequests:
        return 'Please wait a moment before trying again.';
      case AuthErrorType.userNotFound:
        return 'This account doesn\'t exist. Try creating a new account.';
      case AuthErrorType.serverError:
        return 'Our servers are experiencing issues. Please try again later.';
      default:
        return 'If the problem persists, please contact support.';
    }
  }

  bool _shouldShowRetryButton(AuthErrorType errorType) {
    switch (errorType) {
      case AuthErrorType.networkError:
      case AuthErrorType.serverError:
      case AuthErrorType.tooManyRequests:
        return true;
      default:
        return false;
    }
  }
}