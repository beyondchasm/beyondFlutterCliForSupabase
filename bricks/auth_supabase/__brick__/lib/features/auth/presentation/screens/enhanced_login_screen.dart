import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import '../providers/enhanced_auth_provider.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/auth_error_display.dart';
import '../widgets/social_auth_buttons.dart';

class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({super.key});

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late TabController _tabController;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  Email? _validatedEmail;
  Password? _validatedPassword;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Consumer<EnhancedAuthProvider>(
          builder: (context, authProvider, child) {
            return CustomScrollView(
              slivers: [
                // 헤더
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        // 로고 또는 앱 아이콘
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Welcome Back',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue to your account',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 탭 바
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      tabs: const [
                        Tab(text: 'Sign In'),
                        Tab(text: 'Sign Up'),
                      ],
                    ),
                  ),
                ),
                
                // 에러 표시
                if (authProvider.hasError)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      child: AuthErrorDisplay(
                        errorMessage: authProvider.errorMessage!,
                        errorType: authProvider.lastErrorType!,
                        onRetry: () => _handleRetry(authProvider),
                        onDismiss: () => authProvider.clearError(),
                      ),
                    ),
                  ),
                
                // 폼 내용
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSignInForm(authProvider),
                        _buildSignUpForm(authProvider),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSignInForm(EnhancedAuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          
          // 이메일 필드
          AuthFormField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) => _validateEmail(value),
            onChanged: (value) => _onEmailChanged(value),
          ),
          
          const SizedBox(height: 16),
          
          // 비밀번호 필드
          AuthFormField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) => _validatePasswordForLogin(value),
          ),
          
          const SizedBox(height: 16),
          
          // Remember Me & Forgot Password
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const Text('Remember me'),
              const Spacer(),
              TextButton(
                onPressed: () => _showForgotPasswordDialog(),
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // 로그인 버튼
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: authProvider.isLoading ? null : () => _signIn(authProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 소셜 로그인
          const SocialAuthButtons(),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(EnhancedAuthProvider authProvider) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          
          // 이메일 필드
          AuthFormField(
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) => _validateEmail(value),
            onChanged: (value) => _onEmailChanged(value),
          ),
          
          const SizedBox(height: 16),
          
          // 비밀번호 필드
          AuthFormField(
            controller: _passwordController,
            label: 'Password',
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) => _validatePasswordForSignUp(value),
            onChanged: (value) => _onPasswordChanged(value),
          ),
          
          const SizedBox(height: 8),
          
          // 비밀번호 강도 표시기
          if (_validatedPassword != null)
            PasswordStrengthIndicator(password: _validatedPassword!),
          
          const SizedBox(height: 32),
          
          // 회원가입 버튼
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: authProvider.isLoading ? null : () => _signUp(authProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  // 검증 메서드들
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    try {
      _validatedEmail = Email(value);
      return null;
    } on EmailValidationException catch (e) {
      return e.when(
        empty: () => 'Email is required',
        invalid: () => 'Please enter a valid email address',
      );
    }
  }

  String? _validatePasswordForLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? _validatePasswordForSignUp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    try {
      _validatedPassword = Password(value);
      return null;
    } on PasswordValidationException catch (e) {
      return e.when(
        empty: () => 'Password is required',
        tooShort: () => 'Password must be at least 8 characters',
        tooLong: () => 'Password must be less than 128 characters',
        noUpperCase: () => 'Password must contain uppercase letter',
        noLowerCase: () => 'Password must contain lowercase letter',
        noDigit: () => 'Password must contain a number',
        noSpecialChar: () => 'Password must contain special character',
      );
    }
  }

  // 이벤트 핸들러들
  void _onEmailChanged(String value) {
    try {
      _validatedEmail = Email(value);
    } catch (e) {
      _validatedEmail = null;
    }
  }

  void _onPasswordChanged(String value) {
    try {
      _validatedPassword = Password(value);
    } catch (e) {
      _validatedPassword = null;
    }
    setState(() {});
  }

  Future<void> _signIn(EnhancedAuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final result = await authProvider.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    result.when(
      success: (user) {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      failure: (message, errorType, code, details) {
        // 에러는 Provider에서 처리됨
      },
      loading: () {
        // 로딩 상태는 Provider에서 처리됨
      },
      emailVerificationRequired: (email, message) {
        _showEmailVerificationDialog(email, message);
      },
    );
  }

  Future<void> _signUp(EnhancedAuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final result = await authProvider.signUp(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    result.when(
      success: (user) {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      failure: (message, errorType, code, details) {
        // 에러는 Provider에서 처리됨
      },
      loading: () {
        // 로딩 상태는 Provider에서 처리됨
      },
      emailVerificationRequired: (email, message) {
        _showEmailVerificationDialog(email, message);
      },
    );
  }

  void _handleRetry(EnhancedAuthProvider authProvider) {
    if (_tabController.index == 0) {
      _signIn(authProvider);
    } else {
      _signUp(authProvider);
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email address to reset your password:'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password reset
              Navigator.of(context).pop();
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  void _showEmailVerificationDialog(String email, String? message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Verification Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message ?? 'Please check your email and verify your account.'),
            const SizedBox(height: 16),
            Text('Verification email sent to: $email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Resend verification email
              Navigator.of(context).pop();
            },
            child: const Text('Resend Email'),
          ),
        ],
      ),
    );
  }
}