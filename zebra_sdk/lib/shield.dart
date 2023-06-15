// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shield_platform_interface/shield_platform_interface.dart';

ShieldPlatform get _platform => ShieldPlatform.instance;

/// Shield
class Shield {
  /// Returns the current session id
  static Future<String> getSessionId() async {
    return _platform.getSessionId();
  }

  /// Is initialized
  static Future<bool> isInitialized() async {
    return _platform.isInitialized();
  }

  /// Initializes Shield SDK
  static Future<void> init({
    required String siteId,
    required String key,
  }) async {
    await _platform.init(siteId: siteId, key: key);
  }

  /// Fetches the current platform name
  static Future<String?> getPlatformName() async {
    return _platform.getPlatformName();
  }

  /// Sends attributes to Shield
  static Future<bool> sendAttributes(
    String screenName,
    Map<String, String> data,
  ) async {
    return _platform.sendAttributes(screenName, data);
  }
}

// /// Returns the name of the current platform.
// Future<String> getPlatformName() async {
//   final platformName = await _platform.getPlatformName();
//   if (platformName == null) throw Exception('Unable to get platform name.');
//   return platformName;
// }
