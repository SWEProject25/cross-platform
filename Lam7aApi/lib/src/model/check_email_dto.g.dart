// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_email_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CheckEmailDto extends CheckEmailDto {
  @override
  final String email;

  factory _$CheckEmailDto([void Function(CheckEmailDtoBuilder)? updates]) =>
      (CheckEmailDtoBuilder()..update(updates))._build();

  _$CheckEmailDto._({required this.email}) : super._();
  @override
  CheckEmailDto rebuild(void Function(CheckEmailDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckEmailDtoBuilder toBuilder() => CheckEmailDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckEmailDto && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckEmailDto')..add('email', email))
        .toString();
  }
}

class CheckEmailDtoBuilder
    implements Builder<CheckEmailDto, CheckEmailDtoBuilder> {
  _$CheckEmailDto? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  CheckEmailDtoBuilder() {
    CheckEmailDto._defaults(this);
  }

  CheckEmailDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckEmailDto other) {
    _$v = other as _$CheckEmailDto;
  }

  @override
  void update(void Function(CheckEmailDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckEmailDto build() => _build();

  _$CheckEmailDto _build() {
    final _$result = _$v ??
        _$CheckEmailDto._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'CheckEmailDto', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
