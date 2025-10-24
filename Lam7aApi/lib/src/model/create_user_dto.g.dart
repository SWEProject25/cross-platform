// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateUserDto extends CreateUserDto {
  @override
  final String name;
  @override
  final String email;
  @override
  final String password;
  @override
  final Date birthDate;

  factory _$CreateUserDto([void Function(CreateUserDtoBuilder)? updates]) =>
      (CreateUserDtoBuilder()..update(updates))._build();

  _$CreateUserDto._(
      {required this.name,
      required this.email,
      required this.password,
      required this.birthDate})
      : super._();
  @override
  CreateUserDto rebuild(void Function(CreateUserDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateUserDtoBuilder toBuilder() => CreateUserDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateUserDto &&
        name == other.name &&
        email == other.email &&
        password == other.password &&
        birthDate == other.birthDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateUserDto')
          ..add('name', name)
          ..add('email', email)
          ..add('password', password)
          ..add('birthDate', birthDate))
        .toString();
  }
}

class CreateUserDtoBuilder
    implements Builder<CreateUserDto, CreateUserDtoBuilder> {
  _$CreateUserDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  Date? _birthDate;
  Date? get birthDate => _$this._birthDate;
  set birthDate(Date? birthDate) => _$this._birthDate = birthDate;

  CreateUserDtoBuilder() {
    CreateUserDto._defaults(this);
  }

  CreateUserDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _email = $v.email;
      _password = $v.password;
      _birthDate = $v.birthDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateUserDto other) {
    _$v = other as _$CreateUserDto;
  }

  @override
  void update(void Function(CreateUserDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateUserDto build() => _build();

  _$CreateUserDto _build() {
    final _$result = _$v ??
        _$CreateUserDto._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CreateUserDto', 'name'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'CreateUserDto', 'email'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'CreateUserDto', 'password'),
          birthDate: BuiltValueNullFieldError.checkNotNull(
              birthDate, r'CreateUserDto', 'birthDate'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
