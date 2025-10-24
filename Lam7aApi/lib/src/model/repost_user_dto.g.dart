// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repost_user_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RepostUserDto extends RepostUserDto {
  @override
  final num id;
  @override
  final String username;
  @override
  final String email;
  @override
  final bool isVerified;

  factory _$RepostUserDto([void Function(RepostUserDtoBuilder)? updates]) =>
      (RepostUserDtoBuilder()..update(updates))._build();

  _$RepostUserDto._(
      {required this.id,
      required this.username,
      required this.email,
      required this.isVerified})
      : super._();
  @override
  RepostUserDto rebuild(void Function(RepostUserDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RepostUserDtoBuilder toBuilder() => RepostUserDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RepostUserDto &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        isVerified == other.isVerified;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, isVerified.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RepostUserDto')
          ..add('id', id)
          ..add('username', username)
          ..add('email', email)
          ..add('isVerified', isVerified))
        .toString();
  }
}

class RepostUserDtoBuilder
    implements Builder<RepostUserDto, RepostUserDtoBuilder> {
  _$RepostUserDto? _$v;

  num? _id;
  num? get id => _$this._id;
  set id(num? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _isVerified;
  bool? get isVerified => _$this._isVerified;
  set isVerified(bool? isVerified) => _$this._isVerified = isVerified;

  RepostUserDtoBuilder() {
    RepostUserDto._defaults(this);
  }

  RepostUserDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _email = $v.email;
      _isVerified = $v.isVerified;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RepostUserDto other) {
    _$v = other as _$RepostUserDto;
  }

  @override
  void update(void Function(RepostUserDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RepostUserDto build() => _build();

  _$RepostUserDto _build() {
    final _$result = _$v ??
        _$RepostUserDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'RepostUserDto', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'RepostUserDto', 'username'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'RepostUserDto', 'email'),
          isVerified: BuiltValueNullFieldError.checkNotNull(
              isVerified, r'RepostUserDto', 'isVerified'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
