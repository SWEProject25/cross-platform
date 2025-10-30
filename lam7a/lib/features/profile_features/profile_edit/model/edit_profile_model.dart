import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_model.freezed.dart';
part 'edit_profile_model.g.dart';

@freezed
abstract class EditProfileModel with _$EditProfileModel {
  const factory EditProfileModel({
    required String displayName,
    required String bio,
    required String location,
    required String avatarImage,
    required String bannerImage,
  }) = _EditProfileModel;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) =>
      _$EditProfileModelFromJson(json);
}
