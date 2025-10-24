// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_data_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterDataResponseDto extends RegisterDataResponseDto {
  @override
  final UserResponse user;

  factory _$RegisterDataResponseDto(
          [void Function(RegisterDataResponseDtoBuilder)? updates]) =>
      (RegisterDataResponseDtoBuilder()..update(updates))._build();

  _$RegisterDataResponseDto._({required this.user}) : super._();
  @override
  RegisterDataResponseDto rebuild(
          void Function(RegisterDataResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterDataResponseDtoBuilder toBuilder() =>
      RegisterDataResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterDataResponseDto && user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterDataResponseDto')
          ..add('user', user))
        .toString();
  }
}

class RegisterDataResponseDtoBuilder
    implements
        Builder<RegisterDataResponseDto, RegisterDataResponseDtoBuilder> {
  _$RegisterDataResponseDto? _$v;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  RegisterDataResponseDtoBuilder() {
    RegisterDataResponseDto._defaults(this);
  }

  RegisterDataResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterDataResponseDto other) {
    _$v = other as _$RegisterDataResponseDto;
  }

  @override
  void update(void Function(RegisterDataResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterDataResponseDto build() => _build();

  _$RegisterDataResponseDto _build() {
    _$RegisterDataResponseDto _$result;
    try {
      _$result = _$v ??
          _$RegisterDataResponseDto._(
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RegisterDataResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
