import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileHeaderModel with _$ProfileHeaderModel {
  const factory ProfileHeaderModel({
    required String displayName,
    required String handle,
    required String bio,
    required String avatarImage,
    required String bannerImage,
    @Default(false) bool isVerified,
    required String location,
    required String birthday,
    required String joinedDate,
    required int followersCount,
    required int followingCount,
  }) = _ProfileHeaderModel;

  factory ProfileHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileHeaderModelFromJson(json);
}
