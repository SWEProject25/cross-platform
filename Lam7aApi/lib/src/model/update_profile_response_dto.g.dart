// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProfileResponseDto extends UpdateProfileResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final ProfileResponseDto data;

  factory _$UpdateProfileResponseDto(
          [void Function(UpdateProfileResponseDtoBuilder)? updates]) =>
      (UpdateProfileResponseDtoBuilder()..update(updates))._build();

  _$UpdateProfileResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  UpdateProfileResponseDto rebuild(
          void Function(UpdateProfileResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateProfileResponseDtoBuilder toBuilder() =>
      UpdateProfileResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProfileResponseDto &&
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
    return (newBuiltValueToStringHelper(r'UpdateProfileResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class UpdateProfileResponseDtoBuilder
    implements
        Builder<UpdateProfileResponseDto, UpdateProfileResponseDtoBuilder> {
  _$UpdateProfileResponseDto? _$v;

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

  UpdateProfileResponseDtoBuilder() {
    UpdateProfileResponseDto._defaults(this);
  }

  UpdateProfileResponseDtoBuilder get _$this {
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
  void replace(UpdateProfileResponseDto other) {
    _$v = other as _$UpdateProfileResponseDto;
  }

  @override
  void update(void Function(UpdateProfileResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProfileResponseDto build() => _build();

  _$UpdateProfileResponseDto _build() {
    _$UpdateProfileResponseDto _$result;
    try {
      _$result = _$v ??
          _$UpdateProfileResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'UpdateProfileResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'UpdateProfileResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateProfileResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
