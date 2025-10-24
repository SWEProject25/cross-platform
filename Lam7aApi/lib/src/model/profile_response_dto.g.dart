// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProfileResponseDto extends ProfileResponseDto {
  @override
  final num id;
  @override
  final num userId;
  @override
  final String name;
  @override
  final DateTime birthDate;
  @override
  final String? profileImageUrl;
  @override
  final String? bannerImageUrl;
  @override
  final String? bio;
  @override
  final String? location;
  @override
  final String? website;
  @override
  final bool? isDeactivated;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final UserInfoDto user;

  factory _$ProfileResponseDto(
          [void Function(ProfileResponseDtoBuilder)? updates]) =>
      (ProfileResponseDtoBuilder()..update(updates))._build();

  _$ProfileResponseDto._(
      {required this.id,
      required this.userId,
      required this.name,
      required this.birthDate,
      this.profileImageUrl,
      this.bannerImageUrl,
      this.bio,
      this.location,
      this.website,
      this.isDeactivated,
      required this.createdAt,
      required this.updatedAt,
      required this.user})
      : super._();
  @override
  ProfileResponseDto rebuild(
          void Function(ProfileResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileResponseDtoBuilder toBuilder() =>
      ProfileResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileResponseDto &&
        id == other.id &&
        userId == other.userId &&
        name == other.name &&
        birthDate == other.birthDate &&
        profileImageUrl == other.profileImageUrl &&
        bannerImageUrl == other.bannerImageUrl &&
        bio == other.bio &&
        location == other.location &&
        website == other.website &&
        isDeactivated == other.isDeactivated &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, profileImageUrl.hashCode);
    _$hash = $jc(_$hash, bannerImageUrl.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, website.hashCode);
    _$hash = $jc(_$hash, isDeactivated.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileResponseDto')
          ..add('id', id)
          ..add('userId', userId)
          ..add('name', name)
          ..add('birthDate', birthDate)
          ..add('profileImageUrl', profileImageUrl)
          ..add('bannerImageUrl', bannerImageUrl)
          ..add('bio', bio)
          ..add('location', location)
          ..add('website', website)
          ..add('isDeactivated', isDeactivated)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('user', user))
        .toString();
  }
}

class ProfileResponseDtoBuilder
    implements Builder<ProfileResponseDto, ProfileResponseDtoBuilder> {
  _$ProfileResponseDto? _$v;

  num? _id;
  num? get id => _$this._id;
  set id(num? id) => _$this._id = id;

  num? _userId;
  num? get userId => _$this._userId;
  set userId(num? userId) => _$this._userId = userId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _birthDate;
  DateTime? get birthDate => _$this._birthDate;
  set birthDate(DateTime? birthDate) => _$this._birthDate = birthDate;

  String? _profileImageUrl;
  String? get profileImageUrl => _$this._profileImageUrl;
  set profileImageUrl(String? profileImageUrl) =>
      _$this._profileImageUrl = profileImageUrl;

  String? _bannerImageUrl;
  String? get bannerImageUrl => _$this._bannerImageUrl;
  set bannerImageUrl(String? bannerImageUrl) =>
      _$this._bannerImageUrl = bannerImageUrl;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  String? _website;
  String? get website => _$this._website;
  set website(String? website) => _$this._website = website;

  bool? _isDeactivated;
  bool? get isDeactivated => _$this._isDeactivated;
  set isDeactivated(bool? isDeactivated) =>
      _$this._isDeactivated = isDeactivated;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserInfoDtoBuilder? _user;
  UserInfoDtoBuilder get user => _$this._user ??= UserInfoDtoBuilder();
  set user(UserInfoDtoBuilder? user) => _$this._user = user;

  ProfileResponseDtoBuilder() {
    ProfileResponseDto._defaults(this);
  }

  ProfileResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _name = $v.name;
      _birthDate = $v.birthDate;
      _profileImageUrl = $v.profileImageUrl;
      _bannerImageUrl = $v.bannerImageUrl;
      _bio = $v.bio;
      _location = $v.location;
      _website = $v.website;
      _isDeactivated = $v.isDeactivated;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileResponseDto other) {
    _$v = other as _$ProfileResponseDto;
  }

  @override
  void update(void Function(ProfileResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileResponseDto build() => _build();

  _$ProfileResponseDto _build() {
    _$ProfileResponseDto _$result;
    try {
      _$result = _$v ??
          _$ProfileResponseDto._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProfileResponseDto', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'ProfileResponseDto', 'userId'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProfileResponseDto', 'name'),
            birthDate: BuiltValueNullFieldError.checkNotNull(
                birthDate, r'ProfileResponseDto', 'birthDate'),
            profileImageUrl: profileImageUrl,
            bannerImageUrl: bannerImageUrl,
            bio: bio,
            location: location,
            website: website,
            isDeactivated: isDeactivated,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ProfileResponseDto', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'ProfileResponseDto', 'updatedAt'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProfileResponseDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
