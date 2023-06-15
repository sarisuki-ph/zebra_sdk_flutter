import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zebra_sdk_platform_interface/zebra_sdk_platform_interface.dart';

/// MethodChannelZebraSdk
class MethodChannelZebraSdk extends ZebraSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zebra_emsdk');

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
  Stream<ZebraScanData?> get scannerData => throw UnimplementedError();

  @override
  Stream<String> get scannerStatus => throw UnimplementedError();
}
