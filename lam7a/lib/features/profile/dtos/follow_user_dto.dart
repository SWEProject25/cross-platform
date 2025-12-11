// lib/features/profile/dtos/follow_user_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_user_dto.freezed.dart';
part 'follow_user_dto.g.dart';

@freezed
abstract class FollowUserDto with _$FollowUserDto {
  const factory FollowUserDto({
    required int id,
    required String username,
    @JsonKey(name: 'displayName') String? name,
    String? bio,
    String? profileImageUrl,
    @JsonKey(name: 'is_followed_by_me') bool? isFollowedByMe,
    @JsonKey(name: 'is_following_me') bool? isFollowingMe,
  }) = _FollowUserDto;

  factory FollowUserDto.fromJson(Map<String, dynamic> json) =>
      _$FollowUserDtoFromJson(json);
}
