// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shield/shield.dart';
import 'package:shield_platform_interface/shield_platform_interface.dart';

class MockShieldPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ShieldPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Shield', () {
    late ShieldPlatform shieldPlatform;

    setUp(() {
      shieldPlatform = MockShieldPlatform();
      ShieldPlatform.instance = shieldPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => shieldPlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await Shield.getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => shieldPlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(Shield.getPlatformName, throwsException);
      });
    });
  });
}
