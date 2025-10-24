import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String name,
    required String username,
    required String bio,
    required String imageUrl,
    required bool isVerified,
    required ProfileStateOfFollow stateFollow,
    required ProfileStateOfMute stateMute,
    required ProfileStateBlocked stateBlocked,
  }) = _ProfileModel;
}

enum ProfileStateOfFollow { following, notfollowing }
enum ProfileStateOfMute { muted, notmuted }
enum ProfileStateBlocked { blocked, notblocked }
