// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserResponse extends UserResponse {
  @override
  final String username;
  @override
  final String? email;
  @override
  final String? role;
  @override
  final String? name;
  @override
  final Date? birthDate;
  @override
  final JsonObject? profileImageUrl;
  @override
  final JsonObject? bannerImageUrl;
  @override
  final JsonObject? bio;
  @override
  final JsonObject? location;
  @override
  final JsonObject? website;
  @override
  final DateTime createdAt;

  factory _$UserResponse([void Function(UserResponseBuilder)? updates]) =>
      (UserResponseBuilder()..update(updates))._build();

  _$UserResponse._(
      {required this.username,
      this.email,
      this.role,
      this.name,
      this.birthDate,
      this.profileImageUrl,
      this.bannerImageUrl,
      this.bio,
      this.location,
      this.website,
      required this.createdAt})
      : super._();
  @override
  UserResponse rebuild(void Function(UserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserResponseBuilder toBuilder() => UserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserResponse &&
        username == other.username &&
        email == other.email &&
        role == other.role &&
        name == other.name &&
        birthDate == other.birthDate &&
        profileImageUrl == other.profileImageUrl &&
        bannerImageUrl == other.bannerImageUrl &&
        bio == other.bio &&
        location == other.location &&
        website == other.website &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, profileImageUrl.hashCode);
    _$hash = $jc(_$hash, bannerImageUrl.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, website.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserResponse')
          ..add('username', username)
          ..add('email', email)
          ..add('role', role)
          ..add('name', name)
          ..add('birthDate', birthDate)
          ..add('profileImageUrl', profileImageUrl)
          ..add('bannerImageUrl', bannerImageUrl)
          ..add('bio', bio)
          ..add('location', location)
          ..add('website', website)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class UserResponseBuilder
    implements Builder<UserResponse, UserResponseBuilder> {
  _$UserResponse? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  Date? _birthDate;
  Date? get birthDate => _$this._birthDate;
  set birthDate(Date? birthDate) => _$this._birthDate = birthDate;

  JsonObject? _profileImageUrl;
  JsonObject? get profileImageUrl => _$this._profileImageUrl;
  set profileImageUrl(JsonObject? profileImageUrl) =>
      _$this._profileImageUrl = profileImageUrl;

  JsonObject? _bannerImageUrl;
  JsonObject? get bannerImageUrl => _$this._bannerImageUrl;
  set bannerImageUrl(JsonObject? bannerImageUrl) =>
      _$this._bannerImageUrl = bannerImageUrl;

  JsonObject? _bio;
  JsonObject? get bio => _$this._bio;
  set bio(JsonObject? bio) => _$this._bio = bio;

  JsonObject? _location;
  JsonObject? get location => _$this._location;
  set location(JsonObject? location) => _$this._location = location;

  JsonObject? _website;
  JsonObject? get website => _$this._website;
  set website(JsonObject? website) => _$this._website = website;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserResponseBuilder() {
    UserResponse._defaults(this);
  }

  UserResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _email = $v.email;
      _role = $v.role;
      _name = $v.name;
      _birthDate = $v.birthDate;
      _profileImageUrl = $v.profileImageUrl;
      _bannerImageUrl = $v.bannerImageUrl;
      _bio = $v.bio;
      _location = $v.location;
      _website = $v.website;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserResponse other) {
    _$v = other as _$UserResponse;
  }

  @override
  void update(void Function(UserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserResponse build() => _build();

  _$UserResponse _build() {
    final _$result = _$v ??
        _$UserResponse._(
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'UserResponse', 'username'),
          email: email,
          role: role,
          name: name,
          birthDate: birthDate,
          profileImageUrl: profileImageUrl,
          bannerImageUrl: bannerImageUrl,
          bio: bio,
          location: location,
          website: website,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'UserResponse', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
