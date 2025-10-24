// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateProfileDto extends UpdateProfileDto {
  @override
  final String? name;
  @override
  final Date? birthDate;
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

  factory _$UpdateProfileDto(
          [void Function(UpdateProfileDtoBuilder)? updates]) =>
      (UpdateProfileDtoBuilder()..update(updates))._build();

  _$UpdateProfileDto._(
      {this.name,
      this.birthDate,
      this.profileImageUrl,
      this.bannerImageUrl,
      this.bio,
      this.location,
      this.website})
      : super._();
  @override
  UpdateProfileDto rebuild(void Function(UpdateProfileDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateProfileDtoBuilder toBuilder() =>
      UpdateProfileDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateProfileDto &&
        name == other.name &&
        birthDate == other.birthDate &&
        profileImageUrl == other.profileImageUrl &&
        bannerImageUrl == other.bannerImageUrl &&
        bio == other.bio &&
        location == other.location &&
        website == other.website;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, profileImageUrl.hashCode);
    _$hash = $jc(_$hash, bannerImageUrl.hashCode);
    _$hash = $jc(_$hash, bio.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, website.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateProfileDto')
          ..add('name', name)
          ..add('birthDate', birthDate)
          ..add('profileImageUrl', profileImageUrl)
          ..add('bannerImageUrl', bannerImageUrl)
          ..add('bio', bio)
          ..add('location', location)
          ..add('website', website))
        .toString();
  }
}

class UpdateProfileDtoBuilder
    implements Builder<UpdateProfileDto, UpdateProfileDtoBuilder> {
  _$UpdateProfileDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  Date? _birthDate;
  Date? get birthDate => _$this._birthDate;
  set birthDate(Date? birthDate) => _$this._birthDate = birthDate;

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

  UpdateProfileDtoBuilder() {
    UpdateProfileDto._defaults(this);
  }

  UpdateProfileDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _birthDate = $v.birthDate;
      _profileImageUrl = $v.profileImageUrl;
      _bannerImageUrl = $v.bannerImageUrl;
      _bio = $v.bio;
      _location = $v.location;
      _website = $v.website;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateProfileDto other) {
    _$v = other as _$UpdateProfileDto;
  }

  @override
  void update(void Function(UpdateProfileDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateProfileDto build() => _build();

  _$UpdateProfileDto _build() {
    final _$result = _$v ??
        _$UpdateProfileDto._(
          name: name,
          birthDate: birthDate,
          profileImageUrl: profileImageUrl,
          bannerImageUrl: bannerImageUrl,
          bio: bio,
          location: location,
          website: website,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
