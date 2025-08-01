import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 진화된 Riverpod 옵저버
class Observer extends ProviderObserver {
  final bool logAdd;
  final bool logUpdate;
  final bool logDispose;
  final Map<ProviderBase, DateTime> _timestamps = {};

  /// 각 이벤트 로깅을 켜고 끌 수 있어요.
  Observer({this.logAdd = true, this.logUpdate = true, this.logDispose = true});

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (!logAdd) return;
    _timestamps[provider] = DateTime.now();
    _log('add', provider, current: value);
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (!logUpdate) return;

    final start = _timestamps[provider];
    final elapsedMs = start != null
        ? DateTime.now().difference(start).inMilliseconds
        : null;
    _timestamps[provider] = DateTime.now();

    if (newValue is AsyncValue) {
      // AsyncValue 전용 로깅
      final status = newValue.when(
        data: (_) => 'data',
        loading: () => 'loading',
        error: (_, __) => 'error',
      );
      _log(
        'update',
        provider,
        status: status,
        previous: previousValue,
        current: newValue.asData?.value,
        error: newValue.asError?.error,
        extra: {'elapsedMs': elapsedMs},
      );
    } else {
      _log(
        'update',
        provider,
        previous: previousValue,
        current: newValue,
        extra: {'elapsedMs': elapsedMs},
      );
    }
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    if (!logDispose) return;
    _log('dispose', provider, current: 'disposed');
    _timestamps.remove(provider);
    super.didDisposeProvider(provider, container);
  }

  void _log(
    String eventType,
    ProviderBase provider, {
    Object? previous,
    Object? current,
    String? status,
    Object? error,
    Map<String, dynamic>? extra,
  }) {
    final message = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'event': eventType,
      'provider': provider.name ?? provider.runtimeType.toString(),
      if (status != null) 'status': status,
      if (previous != null) 'previous': previous,
      if (current != null) 'current': current,
      if (error != null) 'error': error.toString(),
      if (extra != null) 'extra': extra,
    };
    log(jsonEncode(message), name: 'RiverpodObserver');
  }
}
