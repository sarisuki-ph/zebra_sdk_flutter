// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shield_platform_interface/shield_platform_interface.dart';

/// The Android implementation of [ShieldPlatform].
class ShieldAndroid extends ShieldPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shield_android');

  /// Registers this class as the default instance of [ShieldPlatform]
  static void registerWith() {
    ShieldPlatform.instance = ShieldAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Future<void> init({required String siteId, required String key}) {
    return methodChannel.invokeMethod('init', {
      'siteId': siteId,
      'key': key,
    });
  }

  @override
  Future<bool> isInitialized() async {
    return await methodChannel.invokeMethod<bool>('isInitialized') ?? false;
  }

  @override
  Future<String> getSessionId() async {
    final sessionId = await methodChannel.invokeMethod<String>('getSessionId');
    if (sessionId == null || sessionId.isEmpty) {
      throw PlatformException(
        code: 'shield_android_session_id_not_found',
        message: 'Session id not found',
      );
    }

    return sessionId;
  }

  @override
  Future<bool> sendAttributes(
    String screenName,
    Map<String, String> data,
  ) async {
    return await methodChannel.invokeMethod<bool?>('sendAttributes', {
          'screenName': screenName,
          'data': data,
        }) ??
        false;
  }
}
