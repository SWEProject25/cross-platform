import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dto.freezed.dart';
part 'profile_dto.g.dart';

@freezed
abstract class ProfileDto with _$ProfileDto {
  const factory ProfileDto({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String name,
    @JsonKey(name: 'birthDate') String? birthDate,
    @JsonKey(name: 'profileImageUrl') String? profileImageUrl,
    @JsonKey(name: 'bannerImageUrl') String? bannerImageUrl,
    String? bio,
    String? location,
    String? website,
    @JsonKey(name: 'is_deactivated') bool? isDeactivated,
    @JsonKey(name: 'createdAt') String? createdAt,
    @JsonKey(name: 'updatedAt') String? updatedAt,
    @JsonKey(name: 'User') Map<String, dynamic>? user,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);
}
