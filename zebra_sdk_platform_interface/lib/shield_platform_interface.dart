// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shield_platform_interface/src/method_channel_shield.dart';

/// The interface that implementations of shield must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `Shield`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [ShieldPlatform] methods.
abstract class ShieldPlatform extends PlatformInterface {
  /// Constructs a ShieldPlatform.
  ShieldPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShieldPlatform _instance = MethodChannelShield();

  /// The default instance of [ShieldPlatform] to use.
  ///
  /// Defaults to [MethodChannelShield].
  static ShieldPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ShieldPlatform] when they register themselves.
  static set instance(ShieldPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();

  /// Initializes Shield Fraud SDK
  Future<void> init({
    required String siteId,
    required String key,
  });

  /// Checks if the SDK is initialized
  Future<bool> isInitialized();

  /// Returns the current
  Future<String> getSessionId();

  /// The sendAttributes callback returns simple boolean to let the client
  /// knows SHIELD has received the attributes or not.
  Future<bool> sendAttributes(String screenName, Map<String, String> data);
}
