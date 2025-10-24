// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_email_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateEmailDto extends UpdateEmailDto {
  @override
  final String email;

  factory _$UpdateEmailDto([void Function(UpdateEmailDtoBuilder)? updates]) =>
      (UpdateEmailDtoBuilder()..update(updates))._build();

  _$UpdateEmailDto._({required this.email}) : super._();
  @override
  UpdateEmailDto rebuild(void Function(UpdateEmailDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateEmailDtoBuilder toBuilder() => UpdateEmailDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateEmailDto && email == other.email;
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
    return (newBuiltValueToStringHelper(r'UpdateEmailDto')..add('email', email))
        .toString();
  }
}

class UpdateEmailDtoBuilder
    implements Builder<UpdateEmailDto, UpdateEmailDtoBuilder> {
  _$UpdateEmailDto? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  UpdateEmailDtoBuilder() {
    UpdateEmailDto._defaults(this);
  }

  UpdateEmailDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateEmailDto other) {
    _$v = other as _$UpdateEmailDto;
  }

  @override
  void update(void Function(UpdateEmailDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateEmailDto build() => _build();

  _$UpdateEmailDto _build() {
    final _$result = _$v ??
        _$UpdateEmailDto._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'UpdateEmailDto', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
