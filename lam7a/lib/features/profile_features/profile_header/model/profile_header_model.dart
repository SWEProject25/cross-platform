import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_header_model.freezed.dart';
part 'profile_header_model.g.dart';

@freezed
abstract class ProfileHeaderModel with _$ProfileHeaderModel {
  const factory ProfileHeaderModel({
    required String bannerImage,
    required String avatarImage,
    required String displayName,
    required String handle,
    required String bio,
    required String location,
    required String joinedDate,
    required List<String> mutualFollowers,
    required bool isVerified,
  }) = _ProfileHeaderModel;

  factory ProfileHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileHeaderModelFromJson(json);
}
