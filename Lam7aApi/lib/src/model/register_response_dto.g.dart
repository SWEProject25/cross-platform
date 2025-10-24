// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterResponseDto extends RegisterResponseDto {
  @override
  final String status;
  @override
  final String message;
  @override
  final RegisterDataResponseDto data;

  factory _$RegisterResponseDto(
          [void Function(RegisterResponseDtoBuilder)? updates]) =>
      (RegisterResponseDtoBuilder()..update(updates))._build();

  _$RegisterResponseDto._(
      {required this.status, required this.message, required this.data})
      : super._();
  @override
  RegisterResponseDto rebuild(
          void Function(RegisterResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterResponseDtoBuilder toBuilder() =>
      RegisterResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterResponseDto &&
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
    return (newBuiltValueToStringHelper(r'RegisterResponseDto')
          ..add('status', status)
          ..add('message', message)
          ..add('data', data))
        .toString();
  }
}

class RegisterResponseDtoBuilder
    implements Builder<RegisterResponseDto, RegisterResponseDtoBuilder> {
  _$RegisterResponseDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  RegisterDataResponseDtoBuilder? _data;
  RegisterDataResponseDtoBuilder get data =>
      _$this._data ??= RegisterDataResponseDtoBuilder();
  set data(RegisterDataResponseDtoBuilder? data) => _$this._data = data;

  RegisterResponseDtoBuilder() {
    RegisterResponseDto._defaults(this);
  }

  RegisterResponseDtoBuilder get _$this {
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
  void replace(RegisterResponseDto other) {
    _$v = other as _$RegisterResponseDto;
  }

  @override
  void update(void Function(RegisterResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterResponseDto build() => _build();

  _$RegisterResponseDto _build() {
    _$RegisterResponseDto _$result;
    try {
      _$result = _$v ??
          _$RegisterResponseDto._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'RegisterResponseDto', 'status'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'RegisterResponseDto', 'message'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RegisterResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
