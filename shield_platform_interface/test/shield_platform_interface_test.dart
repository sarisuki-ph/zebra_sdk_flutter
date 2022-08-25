// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:shield_platform_interface/shield_platform_interface.dart';

class ShieldMock extends ShieldPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;

  @override
  Future<String> getSessionId() {
    // TODO: implement getSessionId
    throw UnimplementedError();
  }

  @override
  Future<void> init({required String siteId, required String key}) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<bool> isInitialized() {
    // TODO: implement isInitialized
    throw UnimplementedError();
  }

  @override
  Future<bool> sendAttributes(String screenName, Map<String, String> data) {
    // TODO: implement sendAttributes
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ShieldPlatformInterface', () {
    late ShieldPlatform shieldPlatform;

    setUp(() {
      shieldPlatform = ShieldMock();
      ShieldPlatform.instance = shieldPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await ShieldPlatform.instance.getPlatformName(),
          equals(ShieldMock.mockPlatformName),
        );
      });
    });
  });
}
