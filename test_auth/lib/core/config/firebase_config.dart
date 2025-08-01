import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const String appName = 'Flutter Clean Architecture';
  
  // Firebase 프로젝트 설정
  // TODO: Firebase 콘솔에서 생성한 프로젝트 정보로 교체하세요
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your-android-api-key',
    appId: 'your-android-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosBundleId: 'com.example.flutter_clean_architecture_app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'your-web-api-key',
    appId: 'your-web-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
  );

  /// Firebase 초기화
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: _getFirebaseOptions(),
    );
  }

  /// 플랫폼별 Firebase 옵션 반환
  static FirebaseOptions _getFirebaseOptions() {
    // Platform에 따라 적절한 옵션 반환
    // 실제 구현에서는 Platform.isAndroid, Platform.isIOS 등을 사용
    return android; // 기본값
  }
}