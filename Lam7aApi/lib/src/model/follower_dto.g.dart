// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FollowerDto extends FollowerDto {
  @override
  final num id;
  @override
  final String username;
  @override
  final JsonObject? displayName;
  @override
  final JsonObject? bio;
  @override
  final JsonObject? profileImageUrl;
  @override
  final DateTime followedAt;

  factory _$FollowerDto([void Function(FollowerDtoBuilder)? updates]) =>
      (FollowerDtoBuilder()..update(updates))._build();

  _$FollowerDto._(
      {required this.id,
      required this.username,
      this.displayName,
      this.bio,
      this.profileImageUrl,
      required this.followedAt})
      : super._();
  @override
  FollowerDto rebuild(void Function(FollowerDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FollowerDtoBuilder toBuilder() => FollowerDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FollowerDto &&
        id == other.id &&
        username == other.username &&
        displayName == other.displayName &&
        bio == other.bio &&
        profileImageUrl == other.profileImageUrl &&
        followedAt == other.followedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, profileImageUrl.hashCode);
    _$hash = $jc(_$hash, followedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FollowerDto')
          ..add('id', id)
          ..add('username', username)
          ..add('displayName', displayName)
          ..add('bio', bio)
          ..add('profileImageUrl', profileImageUrl)
          ..add('followedAt', followedAt))
        .toString();
  }
}

class FollowerDtoBuilder implements Builder<FollowerDto, FollowerDtoBuilder> {
  _$FollowerDto? _$v;

  num? _id;
  num? get id => _$this._id;
  set id(num? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  JsonObject? _displayName;
  JsonObject? get displayName => _$this._displayName;
  set displayName(JsonObject? displayName) => _$this._displayName = displayName;

  JsonObject? _bio;
  JsonObject? get bio => _$this._bio;
  set bio(JsonObject? bio) => _$this._bio = bio;

  JsonObject? _profileImageUrl;
  JsonObject? get profileImageUrl => _$this._profileImageUrl;
  set profileImageUrl(JsonObject? profileImageUrl) =>
      _$this._profileImageUrl = profileImageUrl;

  DateTime? _followedAt;
  DateTime? get followedAt => _$this._followedAt;
  set followedAt(DateTime? followedAt) => _$this._followedAt = followedAt;

  FollowerDtoBuilder() {
    FollowerDto._defaults(this);
  }

  FollowerDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _displayName = $v.displayName;
      _bio = $v.bio;
      _profileImageUrl = $v.profileImageUrl;
      _followedAt = $v.followedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FollowerDto other) {
    _$v = other as _$FollowerDto;
  }

  @override
  void update(void Function(FollowerDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FollowerDto build() => _build();

  _$FollowerDto _build() {
    final _$result = _$v ??
        _$FollowerDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FollowerDto', 'id'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'FollowerDto', 'username'),
          displayName: displayName,
          bio: bio,
          profileImageUrl: profileImageUrl,
          followedAt: BuiltValueNullFieldError.checkNotNull(
              followedAt, r'FollowerDto', 'followedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
