// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserInfoDtoRoleEnum _$userInfoDtoRoleEnum_USER =
    const UserInfoDtoRoleEnum._('USER');
const UserInfoDtoRoleEnum _$userInfoDtoRoleEnum_ADMIN =
    const UserInfoDtoRoleEnum._('ADMIN');

UserInfoDtoRoleEnum _$userInfoDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'USER':
      return _$userInfoDtoRoleEnum_USER;
    case 'ADMIN':
      return _$userInfoDtoRoleEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UserInfoDtoRoleEnum> _$userInfoDtoRoleEnumValues =
    BuiltSet<UserInfoDtoRoleEnum>(const <UserInfoDtoRoleEnum>[
  _$userInfoDtoRoleEnum_USER,
  _$userInfoDtoRoleEnum_ADMIN,
]);

Serializer<UserInfoDtoRoleEnum> _$userInfoDtoRoleEnumSerializer =
    _$UserInfoDtoRoleEnumSerializer();

class _$UserInfoDtoRoleEnumSerializer
    implements PrimitiveSerializer<UserInfoDtoRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'USER': 'USER',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'USER': 'USER',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[UserInfoDtoRoleEnum];
  @override
  final String wireName = 'UserInfoDtoRoleEnum';

  @override
  Object serialize(Serializers serializers, UserInfoDtoRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UserInfoDtoRoleEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserInfoDtoRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UserInfoDto extends UserInfoDto {
  @override
  final num id;
  @override
  final String username;
  @override
  final String email;
  @override
  final UserInfoDtoRoleEnum role;
  @override
  final DateTime createdAt;

  factory _$UserInfoDto([void Function(UserInfoDtoBuilder)? updates]) =>
      (UserInfoDtoBuilder()..update(updates))._build();

  _$UserInfoDto._(
      {required this.id,
      required this.username,
      required this.email,
      required this.role,
      required this.createdAt})
      : super._();
  @override
  UserInfoDto rebuild(void Function(UserInfoDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserInfoDtoBuilder toBuilder() => UserInfoDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserInfoDto &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        role == other.role &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserInfoDto')
          ..add('id', id)
          ..add('username', username)
          ..add('email', email)
          ..add('role', role)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class UserInfoDtoBuilder implements Builder<UserInfoDto, UserInfoDtoBuilder> {
  _$UserInfoDto? _$v;

  num? _id;
  num? get id => _$this._id;
  set id(num? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  UserInfoDtoRoleEnum? _role;
  UserInfoDtoRoleEnum? get role => _$this._role;
  set role(UserInfoDtoRoleEnum? role) => _$this._role = role;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserInfoDtoBuilder() {
    UserInfoDto._defaults(this);
  }

  UserInfoDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _email = $v.email;
      _role = $v.role;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserInfoDto other) {
    _$v = other as _$UserInfoDto;
  }

  @override
  void update(void Function(UserInfoDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserInfoDto build() => _build();

  _$UserInfoDto _build() {
    final _$result = _$v ??
        _$UserInfoDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserInfoDto', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'UserInfoDto', 'username'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'UserInfoDto', 'email'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'UserInfoDto', 'role'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'UserInfoDto', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
