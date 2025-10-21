class ProfileModel {
  final String name;
  final String username;
  final String bio;
  final String imageUrl;
  final bool isVerified;
  final ProfileStateOfFollow stateFollow;
  final ProfileStateOfMute stateMute;
  final ProfileStateBlocked stateBlocked;

  ProfileModel({
    required this.name,
    required this.username,
    required this.bio,
    required this.imageUrl,
    required this.isVerified,
    required this.stateFollow,
    required this.stateMute,
    required this.stateBlocked,
  });

  ProfileModel copyWith({ProfileStateOfFollow? stateFollow, ProfileStateBlocked? stateBlocked, ProfileStateOfMute? stateMute}) =>
      ProfileModel(
        name: name,
        username: username,
        bio: bio,
        imageUrl: imageUrl,
        isVerified: isVerified,
        stateFollow: stateFollow ?? this.stateFollow,
        stateBlocked: stateBlocked ?? this.stateBlocked,
        stateMute: stateMute ?? this.stateMute,
      );
}

enum ProfileStateOfFollow { following, notfollowing }
enum ProfileStateOfMute { muted, notmuted }
enum ProfileStateBlocked { blocked, notblocked }
