// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginResponseDto extends LoginResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final UserResponse data;

  factory _$LoginResponseDto(
          [void Function(LoginResponseDtoBuilder)? updates]) =>
      (LoginResponseDtoBuilder()..update(updates))._build();

  _$LoginResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  LoginResponseDto rebuild(void Function(LoginResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginResponseDtoBuilder toBuilder() =>
      LoginResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginResponseDto &&
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
    return (newBuiltValueToStringHelper(r'LoginResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class LoginResponseDtoBuilder
    implements Builder<LoginResponseDto, LoginResponseDtoBuilder> {
  _$LoginResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  UserResponseBuilder? _data;
  UserResponseBuilder get data => _$this._data ??= UserResponseBuilder();
  set data(UserResponseBuilder? data) => _$this._data = data;

  LoginResponseDtoBuilder() {
    LoginResponseDto._defaults(this);
  }

  LoginResponseDtoBuilder get _$this {
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
  void replace(LoginResponseDto other) {
    _$v = other as _$LoginResponseDto;
  }

  @override
  void update(void Function(LoginResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginResponseDto build() => _build();

  _$LoginResponseDto _build() {
    _$LoginResponseDto _$result;
    try {
      _$result = _$v ??
          _$LoginResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'LoginResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'LoginResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LoginResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
