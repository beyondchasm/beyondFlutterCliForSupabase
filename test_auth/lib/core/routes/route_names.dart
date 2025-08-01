class RouteNames {
  // Auth Routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  
  // Main App Routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // Onboarding
  static const String onboarding = '/onboarding';
  
  // Common Routes
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  
  // Error Routes
  static const String notFound = '/404';
  static const String error = '/error';
  
  // Route Parameters
  static const String idParam = 'id';
  static const String typeParam = 'type';
  static const String categoryParam = 'category';
  
  // Query Parameters
  static const String searchQuery = 'q';
  static const String pageQuery = 'page';
  static const String limitQuery = 'limit';
  static const String sortQuery = 'sort';
  static const String filterQuery = 'filter';
  
  // Route Paths with Parameters
  static String homeDetails(String id) => '/home/details/$id';
  static String profileEdit() => '/profile/edit';
  static String profileSettings() => '/profile/settings';
  
  // Helper Methods
  static bool isAuthRoute(String route) {
    return [
      splash,
      login,
      register,
      forgotPassword,
      resetPassword,
    ].contains(route);
  }
  
  static bool isPublicRoute(String route) {
    return [
      splash,
      login,
      register,
      forgotPassword,
      resetPassword,
      about,
      privacy,
      terms,
      notFound,
      error,
    ].contains(route);
  }
  
  static bool isProtectedRoute(String route) {
    return !isPublicRoute(route);
  }
  
  static String getRouteDisplayName(String route) {
    switch (route) {
      case splash:
        return 'Splash';
      case login:
        return 'Login';
      case register:
        return 'Register';
      case forgotPassword:
        return 'Forgot Password';
      case resetPassword:
        return 'Reset Password';
      case home:
        return 'Home';
      case profile:
        return 'Profile';
      case settings:
        return 'Settings';
      case onboarding:
        return 'Onboarding';
      case notifications:
        return 'Notifications';
      case search:
        return 'Search';
      case about:
        return 'About';
      case privacy:
        return 'Privacy Policy';
      case terms:
        return 'Terms of Service';
      case notFound:
        return 'Page Not Found';
      case error:
        return 'Error';
      default:
        return route.replaceAll('/', '').replaceAll('-', ' ').toUpperCase();
    }
  }
}