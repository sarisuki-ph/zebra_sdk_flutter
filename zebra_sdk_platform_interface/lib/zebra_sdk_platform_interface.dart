// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:zebra_sdk_platform_interface/src/method_channel_zebra_sdk.dart';

/// The interface that implementations of shield must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `Shield`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [ZebraSdkPlatform] methods.
abstract class ZebraSdkPlatform extends PlatformInterface {
  /// Constructs a ZebraEmsdkPlatform.
  ZebraSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZebraSdkPlatform _instance = MethodChannelZebraSdk();

  /// The default instance of [ZebraSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelZebraSdk].
  static ZebraSdkPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ZebraSdkPlatform] when they register themselves.
  static set instance(ZebraSdkPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();

  /// Initializes the scanner
  ///
  /// Returns true if the scanner was successfully initialized
  /// Returns false if the scanner failed to initialize
  Future<bool> init();

  /// Returns a stream of scanner status events
  Stream<String> get scannerStatus;

  /// Returns a stream of scanner data events
  Stream<String> get scannerData;
}
