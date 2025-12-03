import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
abstract class ProfileDto with _$ProfileDto {
  const factory ProfileDto({
    required int id,

    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'profile_id') int? profileId,

    required String name,
    @JsonKey(name: 'birth_date') String? birthDate,

    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    @JsonKey(name: 'banner_image_url') String? bannerImageUrl,

    String? bio,
    String? location,
    String? website,

    @JsonKey(name: 'is_deactivated') bool? isDeactivated,

    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,

    // Nested user object (backend usually returns something like user.username etc)
    @JsonKey(name: 'User') Map<String, dynamic>? user,

    @JsonKey(name: 'followers_count') int? followersCount,
    @JsonKey(name: 'following_count') int? followingCount,

    @JsonKey(name: 'is_followed_by_me') bool? isFollowedByMe,
    @JsonKey(name: 'is_muted_by_me') bool? isMutedByMe,
    @JsonKey(name: 'is_blocked_by_me') bool? isBlockedByMe,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);
}
