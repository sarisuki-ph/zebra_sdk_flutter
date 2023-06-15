import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shield_platform_interface/shield_platform_interface.dart';

/// MethodChannelShield
class MethodChannelShield extends ShieldPlatform {
  /// methodChannel
  @visibleForTesting
  final methodChannel = const MethodChannel('shield');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod('getPlatformName');
  }

  @override
  Future<String> getSessionId() {
    throw UnimplementedError();
  }

  @override
  Future<void> init({required String siteId, required String key}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isInitialized() {
    throw UnimplementedError();
  }

  @override
  Future<bool> sendAttributes(String screenName, Map<String, String> data) {
    throw UnimplementedError();
  }
}
