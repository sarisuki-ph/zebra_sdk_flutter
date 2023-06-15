import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'zebra_scan_data.freezed.dart';
part 'zebra_scan_data.g.dart';

/// The data returned from the scanner
@freezed
class ZebraScanData with _$ZebraScanData {
  /// {@macro zebra_scan_data}
  const factory ZebraScanData({
    required String data,
    required String labelType,
    required String timestamp,
  }) = _ZebraScanData;

  /// fromJson
  factory ZebraScanData.fromJson(Map<String, dynamic> json) =>
      _$ZebraScanDataFromJson(json);

  /// fromJsonStr
  factory ZebraScanData.fromJsonStr(String jsonStr) {
    return ZebraScanData.fromJson(
      jsonDecode(jsonStr) as Map<String, dynamic>,
    );
  }
}
