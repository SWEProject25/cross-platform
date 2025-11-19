import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    int? id,
    String? username,
    String? email,
    String? role,
    String? name,
    String? birthDate,
    String? profileImageUrl,
    String? bannerImageUrl,
    String? bio,
    String? location,
    String? website,
    String? createdAt,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
