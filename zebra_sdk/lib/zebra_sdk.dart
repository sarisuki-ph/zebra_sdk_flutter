// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:zebra_sdk_platform_interface/zebra_sdk_platform_interface.dart';

ZebraSdkPlatform get _platform => ZebraSdkPlatform.instance;

/// ZebraSdk
class ZebraSdk {
  /// Returns the name of the current platform.
  static Future<String?> get platformName async {
    return _platform.getPlatformName();
  }

  /// Initializes the platform
  static Future<bool> init() async {
    return _platform.init();
  }

  /// Returns a stream of scanner data events
  static Stream<String> get scannerData => _platform.scannerData;

  /// Returns a stream of scanner status events
  static Stream<String> get scannerStatus => _platform.scannerStatus;
}
