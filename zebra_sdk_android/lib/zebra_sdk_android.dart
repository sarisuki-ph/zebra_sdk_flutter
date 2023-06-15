// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zebra_sdk_platform_interface/zebra_sdk_platform_interface.dart';

/// The Android implementation of [ZebraSdkPlatform].
class ZebraSdkAndroid extends ZebraSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zebra_emsdk_android');
  final _scannerStatusEventChannel =
      const EventChannel('zebra_emsdk_android_scanner_status');
  final _scannerDataEventChannel =
      const EventChannel('zebra_emsdk_android_scanner_data');

  /// Registers this class as the default instance of [ZebraSdkPlatform]
  static void registerWith() {
    ZebraSdkPlatform.instance = ZebraSdkAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Future<bool> init() async {
    final result = await methodChannel.invokeMethod<bool>('init');
    return result ?? false;
  }

  @override
  Stream<String> get scannerData => _scannerDataEventChannel
      .receiveBroadcastStream()
      .map((event) => event.toString());

  @override
  Stream<String> get scannerStatus => _scannerStatusEventChannel
      .receiveBroadcastStream()
      .map((event) => event.toString());
}
