import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enhanced_auth_provider.dart';

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Social login buttons
        Consumer<EnhancedAuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              children: [
                // Google Sign In
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: authProvider.isLoading 
                        ? null 
                        : () => _signInWithGoogle(context, authProvider),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/google.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: authProvider.isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : null,
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Apple Sign In (iOS only or when available)
                if (Theme.of(context).platform == TargetPlatform.iOS)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: authProvider.isLoading 
                          ? null 
                          : () => _signInWithApple(context, authProvider),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.apple,
                        size: 24,
                      ),
                      label: const Text(
                        'Continue with Apple',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _signInWithGoogle(BuildContext context, EnhancedAuthProvider authProvider) async {
    try {
      // TODO: Implement Google Sign In
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign In - Coming Soon!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign In failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _signInWithApple(BuildContext context, EnhancedAuthProvider authProvider) async {
    try {
      // TODO: Implement Apple Sign In
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apple Sign In - Coming Soon!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Apple Sign In failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}