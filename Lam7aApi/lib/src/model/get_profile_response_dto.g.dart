// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_profile_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetProfileResponseDto extends GetProfileResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final ProfileResponseDto data;

  factory _$GetProfileResponseDto(
          [void Function(GetProfileResponseDtoBuilder)? updates]) =>
      (GetProfileResponseDtoBuilder()..update(updates))._build();

  _$GetProfileResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  GetProfileResponseDto rebuild(
          void Function(GetProfileResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetProfileResponseDtoBuilder toBuilder() =>
      GetProfileResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetProfileResponseDto &&
        status == other.status &&
        message == other.message &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetProfileResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class GetProfileResponseDtoBuilder
    implements Builder<GetProfileResponseDto, GetProfileResponseDtoBuilder> {
  _$GetProfileResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  ProfileResponseDtoBuilder? _data;
  ProfileResponseDtoBuilder get data =>
      _$this._data ??= ProfileResponseDtoBuilder();
  set data(ProfileResponseDtoBuilder? data) => _$this._data = data;

  GetProfileResponseDtoBuilder() {
    GetProfileResponseDto._defaults(this);
  }

  GetProfileResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _message = $v.message;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetProfileResponseDto other) {
    _$v = other as _$GetProfileResponseDto;
  }

  @override
  void update(void Function(GetProfileResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetProfileResponseDto build() => _build();

  _$GetProfileResponseDto _build() {
    _$GetProfileResponseDto _$result;
    try {
      _$result = _$v ??
          _$GetProfileResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GetProfileResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'GetProfileResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetProfileResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
