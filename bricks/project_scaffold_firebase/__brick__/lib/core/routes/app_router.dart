import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

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

    // Redirect Logic
    redirect: (context, state) {
      final isLoggedIn = false; // TODO: Get from auth service
      final isOnboarding = false; // TODO: Get from preferences

      // Handle authentication
      if (!isLoggedIn) {
        if (state.matchedLocation == RouteNames.splash ||
            state.matchedLocation == RouteNames.login ||
            state.matchedLocation == RouteNames.register ||
            state.matchedLocation == RouteNames.forgotPassword) {
          return null; // Allow access to auth screens
        }
        return RouteNames.login;
      }

      // Handle onboarding
      if (isLoggedIn && !isOnboarding) {
        if (state.matchedLocation == RouteNames.onboarding) {
          return null;
        }
        return RouteNames.onboarding;
      }

      // Redirect from auth screens to home if already logged in
      if (isLoggedIn && 
          (state.matchedLocation == RouteNames.splash ||
           state.matchedLocation == RouteNames.login ||
           state.matchedLocation == RouteNames.register)) {
        return RouteNames.home;
      }

      return null; // No redirect needed
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

// Placeholder Screens (these should be replaced with actual implementations)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Login Screen')),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Register Screen')),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Forgot Password Screen')),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Screen')),
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
    return const Scaffold(
      body: Center(child: Text('Onboarding Screen')),
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