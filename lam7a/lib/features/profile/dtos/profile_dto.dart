// profile_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
abstract class ProfileDto with _$ProfileDto {
  const factory ProfileDto({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
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

    // backend returns a nested user object
    @JsonKey(name: 'User') Map<String, dynamic>? user,

    // IMPORTANT! backend returns:
    // "followers_count": 0,
    // "following_count": 0
    @JsonKey(name: 'followers_count') int? followersCount,
    @JsonKey(name: 'following_count') int? followingCount,
    
    // backend returns:
    // "is_followed_by_me": false
    @JsonKey(name: 'is_followed_by_me') bool? isFollowedByMe,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);
}
