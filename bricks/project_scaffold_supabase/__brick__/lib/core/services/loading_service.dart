import 'package:flutter/material.dart';

/// 글로벌 로딩 상태 관리 서비스
/// 
/// 앱 전체의 로딩 상태를 통합 관리하고 사용자에게 적절한 로딩 UI를 제공합니다.
class LoadingService extends ChangeNotifier {
  static final LoadingService _instance = LoadingService._internal();
  factory LoadingService() => _instance;
  LoadingService._internal();

  static LoadingService get instance => _instance;

  // 로딩 상태들
  final Map<String, bool> _loadingStates = {};
  OverlayEntry? _overlayEntry;
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Navigator Key 설정
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  /// 특정 키의 로딩 상태 확인
  bool isLoading([String key = 'default']) {
    return _loadingStates[key] ?? false;
  }

  /// 전체 로딩 상태 확인 (하나라도 로딩 중이면 true)
  bool get isAnyLoading {
    return _loadingStates.values.any((loading) => loading);
  }

  /// 로딩 시작
  void startLoading([String key = 'default']) {
    _loadingStates[key] = true;
    notifyListeners();
  }

  /// 로딩 종료
  void stopLoading([String key = 'default']) {
    _loadingStates[key] = false;
    notifyListeners();
  }

  /// 모든 로딩 상태 초기화
  void stopAllLoading() {
    _loadingStates.clear();
    notifyListeners();
  }

  /// 글로벌 로딩 오버레이 표시
  void showGlobalLoading({
    String message = '잠시만 기다려주세요...',
    bool barrierDismissible = false,
  }) {
    final context = _navigatorKey?.currentContext;
    if (context == null || _overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => LoadingOverlay(
        message: message,
        barrierDismissible: barrierDismissible,
        onDismiss: hideGlobalLoading,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// 글로벌 로딩 오버레이 숨기기
  void hideGlobalLoading() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 비동기 작업 실행 with 로딩 상태
  Future<T> runWithLoading<T>(
    Future<T> Function() task, {
    String key = 'default',
    bool showGlobalOverlay = false,
    String loadingMessage = '처리 중...',
  }) async {
    try {
      startLoading(key);
      
      if (showGlobalOverlay) {
        showGlobalLoading(message: loadingMessage);
      }

      final result = await task();
      return result;
    } finally {
      stopLoading(key);
      
      if (showGlobalOverlay) {
        hideGlobalLoading();
      }
    }
  }
}

/// 로딩 오버레이 위젯
class LoadingOverlay extends StatelessWidget {
  final String message;
  final bool barrierDismissible;
  final VoidCallback? onDismiss;

  const LoadingOverlay({
    super.key,
    required this.message,
    this.barrierDismissible = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: barrierDismissible ? onDismiss : null,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 로딩 상태를 쉽게 사용할 수 있는 위젯
class LoadingBuilder extends StatelessWidget {
  final String loadingKey;
  final Widget Function(BuildContext context, bool isLoading) builder;

  const LoadingBuilder({
    super.key,
    this.loadingKey = 'default',
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LoadingService.instance,
      builder: (context, _) {
        final isLoading = LoadingService.instance.isLoading(loadingKey);
        return builder(context, isLoading);
      },
    );
  }
}

/// 로딩 상태에 따라 다른 위젯을 표시하는 위젯
class ConditionalLoadingWidget extends StatelessWidget {
  final String loadingKey;
  final Widget loadingWidget;
  final Widget child;

  const ConditionalLoadingWidget({
    super.key,
    this.loadingKey = 'default',
    required this.loadingWidget,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      loadingKey: loadingKey,
      builder: (context, isLoading) {
        return isLoading ? loadingWidget : child;
      },
    );
  }
}

/// 로딩 버튼 위젯
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String loadingKey;
  final String loadingText;
  final ButtonStyle? style;
  final Widget? icon;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loadingKey = 'default',
    this.loadingText = '처리 중...',
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      loadingKey: loadingKey,
      builder: (context, isLoading) {
        if (icon != null) {
          return ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : icon!,
            label: Text(isLoading ? loadingText : text),
            style: style,
          );
        }

        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(loadingText),
                ],
              )
            : Text(text),
        );
      },
    );
  }
}