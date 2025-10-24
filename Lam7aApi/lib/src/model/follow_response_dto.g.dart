// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_response_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FollowResponseDto extends FollowResponseDto {
  @override
  final num followerId;
  @override
  final num followingId;
  @override
  final DateTime createdAt;

  factory _$FollowResponseDto(
          [void Function(FollowResponseDtoBuilder)? updates]) =>
      (FollowResponseDtoBuilder()..update(updates))._build();

  _$FollowResponseDto._(
      {required this.followerId,
      required this.followingId,
      required this.createdAt})
      : super._();
  @override
  FollowResponseDto rebuild(void Function(FollowResponseDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FollowResponseDtoBuilder toBuilder() =>
      FollowResponseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FollowResponseDto &&
        followerId == other.followerId &&
        followingId == other.followingId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, followerId.hashCode);
    _$hash = $jc(_$hash, followingId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FollowResponseDto')
          ..add('followerId', followerId)
          ..add('followingId', followingId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class FollowResponseDtoBuilder
    implements Builder<FollowResponseDto, FollowResponseDtoBuilder> {
  _$FollowResponseDto? _$v;

  num? _followerId;
  num? get followerId => _$this._followerId;
  set followerId(num? followerId) => _$this._followerId = followerId;

  num? _followingId;
  num? get followingId => _$this._followingId;
  set followingId(num? followingId) => _$this._followingId = followingId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  FollowResponseDtoBuilder() {
    FollowResponseDto._defaults(this);
  }

  FollowResponseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _followerId = $v.followerId;
      _followingId = $v.followingId;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FollowResponseDto other) {
    _$v = other as _$FollowResponseDto;
  }

  @override
  void update(void Function(FollowResponseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FollowResponseDto build() => _build();

  _$FollowResponseDto _build() {
    final _$result = _$v ??
        _$FollowResponseDto._(
          followerId: BuiltValueNullFieldError.checkNotNull(
              followerId, r'FollowResponseDto', 'followerId'),
          followingId: BuiltValueNullFieldError.checkNotNull(
              followingId, r'FollowResponseDto', 'followingId'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'FollowResponseDto', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
