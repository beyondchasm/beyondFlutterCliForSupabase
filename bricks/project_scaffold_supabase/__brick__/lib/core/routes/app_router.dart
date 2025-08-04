import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route_names.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Route
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: RouteNames.forgotPassword,  
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home Tab
          GoRoute(
            path: RouteNames.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'details/:id',
                name: 'homeDetails',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return HomeDetailsScreen(id: id);
                },
              ),
            ],
          ),

          // Profile Tab
          GoRoute(
            path: RouteNames.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'editProfile',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Modal Routes (Full Screen)
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],

    // Error Handler
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Authentication-based Redirect Logic
    redirect: (context, state) async {
      final currentPath = state.uri.path;
      
      // 스플래시 화면은 항상 허용 (앱 시작 시 진입점)
      if (currentPath == RouteNames.splash) {
        return null;
      }
      
      // 현재 사용자 인증 상태 확인
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      
      // 온보딩 완료 여부 확인 (첫 사용자 경험)
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
      
      // 온보딩을 완료하지 않은 경우 온보딩 페이지로 리디렉션
      if (!hasCompletedOnboarding && currentPath != RouteNames.onboarding) {
        return RouteNames.onboarding;
      }
      
      // 인증 관련 페이지들 정의
      final authPages = [
        RouteNames.login,
        RouteNames.register,
        RouteNames.forgotPassword,
      ];
      
      final isAuthPage = authPages.contains(currentPath);
      
      // 인증되지 않은 사용자의 경우
      if (!isLoggedIn) {
        // 온보딩 페이지나 인증 페이지에 있다면 그대로 진행
        if (currentPath == RouteNames.onboarding || isAuthPage) {
          return null;
        }
        // 그 외의 모든 페이지는 로그인 페이지로 리디렉션
        return RouteNames.login;
      }
      
      // 인증된 사용자가 인증 페이지에 접근하려는 경우 홈으로 리디렉션
      if (isLoggedIn && isAuthPage) {
        return RouteNames.home;
      }
      
      // 그 외의 경우는 정상 진행
      return null;
    },
  );

  // Navigation Helper Methods
  static void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  static Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    return _router.push<T>(location, extra: extra);
  }

  static void pop<T extends Object?>([T? result]) {
    _router.pop(result);
  }

  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    _router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return _router.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static void pushReplacement(String location, {Object? extra}) {
    _router.pushReplacement(location, extra: extra);
  }

  static void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    _router.pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  // Convenience Methods
  static void goHome() => go(RouteNames.home);
  static void goLogin() => go(RouteNames.login);
  static void goProfile() => go(RouteNames.profile);
  static void goSettings() => goNamed('settings');
  
  static Future<void> pushNotifications() => push('/notifications');
  static Future<void> pushEditProfile() => pushNamed('editProfile');

  // Current Location
  static String get currentLocation => _router.routerDelegate.currentConfiguration.uri.path;
  
  // Can Pop
  static bool canPop() => _router.canPop();
}

// Placeholder Screens - These will be replaced by actual implementations when auth/onboarding features are added

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login, size: 64, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Login Screen',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Auth feature를 추가하면 실제 로그인 화면으로 교체됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 48),
              
              // 데모용 테스트 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _handleTestLogin(context),
                  icon: const Icon(Icons.person),
                  label: const Text(
                    '테스트 로그인 (데모용)',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => AppRouter.go(RouteNames.register),
                    child: const Text('회원가입'),
                  ),
                  const Text(' | '),
                  TextButton(
                    onPressed: () => AppRouter.go(RouteNames.forgotPassword),
                    child: const Text('비밀번호 찾기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 데모용 테스트 로그인 - Auth feature가 추가되면 실제 구현으로 교체됩니다
  Future<void> _handleTestLogin(BuildContext context) async {
    // 데모용으로 바로 홈 화면으로 이동
    // 실제로는 Supabase auth를 통한 로그인 처리가 들어갑니다
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    // 로그인 시뮬레이션
    await Future.delayed(const Duration(seconds: 1));
    
    if (context.mounted) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      AppRouter.go(RouteNames.home);
    }
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Register Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Auth feature를 추가하면 실제 회원가입 화면으로 교체됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 재설정'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Forgot Password Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Auth feature를 추가하면 실제 비밀번호 재설정 화면으로 교체됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class MainShell extends StatelessWidget {
  final Widget child;
  
  const MainShell({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              AppRouter.goHome();
              break;
            case 1:
              AppRouter.goProfile();
              break;
          }
        },
      ),
    );
  }
}


class HomeDetailsScreen extends StatelessWidget {
  final String id;
  
  const HomeDetailsScreen({super.key, required this.id});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details $id')),
      body: Center(child: Text('Home Details Screen - ID: $id')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Screen')),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.rocket_launch, size: 80, color: Colors.purple),
              const SizedBox(height: 24),
              const Text(
                '앱에 오신 것을 환영합니다!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Onboarding feature를 추가하면 실제 온보딩 슬라이드로 교체됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () async {
                  // 온보딩 완료 표시
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('onboarding_completed', true);
                  
                  // 로그인 페이지로 이동
                  if (context.mounted) {
                    AppRouter.goLogin();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  '시작하기',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Screen')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;
  
  const ErrorScreen({super.key, this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${error?.toString() ?? 'Unknown error'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => AppRouter.goHome(),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}