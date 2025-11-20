// lib/features/profile/model/profile_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Unified Profile Model that combines ProfileHeaderModel and ProfileModel
@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    // Basic Info
    required String displayName,
    required String handle,
    required String bio,
    required String avatarImage,
    required String bannerImage,
    @Default(false) bool isVerified,
    
    // Additional Info
    @Default('') String location,
    @Default('') String birthday,
    required String joinedDate,
    
    // Counts
    required int followersCount,
    required int followingCount,
    
    // States (for viewing other profiles)
    @Default(ProfileStateOfFollow.notfollowing) ProfileStateOfFollow stateFollow,
    @Default(ProfileStateOfMute.notmuted) ProfileStateOfMute stateMute,
    @Default(ProfileStateBlocked.notblocked) ProfileStateBlocked stateBlocked,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

enum ProfileStateOfFollow { following, notfollowing }
enum ProfileStateOfMute { muted, notmuted }
enum ProfileStateBlocked { blocked, notblocked }