// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zebra_scan_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ZebraScanData _$ZebraScanDataFromJson(Map<String, dynamic> json) {
  return _ZebraScanData.fromJson(json);
}

/// @nodoc
mixin _$ZebraScanData {
  String get data => throw _privateConstructorUsedError;
  String get labelType => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ZebraScanDataCopyWith<ZebraScanData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZebraScanDataCopyWith<$Res> {
  factory $ZebraScanDataCopyWith(
          ZebraScanData value, $Res Function(ZebraScanData) then) =
      _$ZebraScanDataCopyWithImpl<$Res, ZebraScanData>;
  @useResult
  $Res call({String data, String labelType, String timestamp});
}

/// @nodoc
class _$ZebraScanDataCopyWithImpl<$Res, $Val extends ZebraScanData>
    implements $ZebraScanDataCopyWith<$Res> {
  _$ZebraScanDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? labelType = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      labelType: null == labelType
          ? _value.labelType
          : labelType // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ZebraScanDataCopyWith<$Res>
    implements $ZebraScanDataCopyWith<$Res> {
  factory _$$_ZebraScanDataCopyWith(
          _$_ZebraScanData value, $Res Function(_$_ZebraScanData) then) =
      __$$_ZebraScanDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String data, String labelType, String timestamp});
}

/// @nodoc
class __$$_ZebraScanDataCopyWithImpl<$Res>
    extends _$ZebraScanDataCopyWithImpl<$Res, _$_ZebraScanData>
    implements _$$_ZebraScanDataCopyWith<$Res> {
  __$$_ZebraScanDataCopyWithImpl(
      _$_ZebraScanData _value, $Res Function(_$_ZebraScanData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? labelType = null,
    Object? timestamp = null,
  }) {
    return _then(_$_ZebraScanData(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      labelType: null == labelType
          ? _value.labelType
          : labelType // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ZebraScanData implements _ZebraScanData {
  const _$_ZebraScanData(
      {required this.data, required this.labelType, required this.timestamp});

  factory _$_ZebraScanData.fromJson(Map<String, dynamic> json) =>
      _$$_ZebraScanDataFromJson(json);

  @override
  final String data;
  @override
  final String labelType;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'ZebraScanData(data: $data, labelType: $labelType, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ZebraScanData &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.labelType, labelType) ||
                other.labelType == labelType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data, labelType, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ZebraScanDataCopyWith<_$_ZebraScanData> get copyWith =>
      __$$_ZebraScanDataCopyWithImpl<_$_ZebraScanData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ZebraScanDataToJson(
      this,
    );
  }
}

abstract class _ZebraScanData implements ZebraScanData {
  const factory _ZebraScanData(
      {required final String data,
      required final String labelType,
      required final String timestamp}) = _$_ZebraScanData;

  factory _ZebraScanData.fromJson(Map<String, dynamic> json) =
      _$_ZebraScanData.fromJson;

  @override
  String get data;
  @override
  String get labelType;
  @override
  String get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$_ZebraScanDataCopyWith<_$_ZebraScanData> get copyWith =>
      throw _privateConstructorUsedError;
}
