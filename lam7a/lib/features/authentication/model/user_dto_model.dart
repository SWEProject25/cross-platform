import 'package:lam7a/core/models/user_dto.dart';

class RootData {
  final User user;
  final OnboardingStatus onboardingStatus;

  RootData({required this.user, required this.onboardingStatus});

  factory RootData.fromJson(Map<String, dynamic> json) {
    String onBoard = "onboardingStatus";
    if (json['onboardingStatus'] == null)
    {
      onBoard = "onboarding";
    }
    return RootData(
      user: User.fromJson(json['user']),
      onboardingStatus: OnboardingStatus.fromJson(json[onBoard]),
    );
  }
}

class User {
  final int id;
  final String? username;
  final String email;
  final String role;
  final Profile profile;
  User({
    required this.id,
    this.username,
    required this.email,
    required this.role,
    required this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      profile: Profile.fromJson(json['profile']),
    );
  }
  UserDtoAuth mapToUserDtoAuth() {
    return UserDtoAuth(
      id: this.id,
      userId: this.id,
      name: this.profile.name,
      birthDate: DateTime.now(),
      profileImageUrl: this.profile.profileImageUrl,
      bannerImageUrl: this.profile.profileImageUrl,
      bio: "",
      location: "",
      website: "",
      isDeactivated: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      user: UserDash(
        id: id,
        username: username,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      ),
      followersCount: 0,
      followingCount: 0,
      isFollowedByMe: false,
    );
  }
}

class Profile {
  final String name;
  final String? profileImageUrl;

  Profile({required this.name, required this.profileImageUrl});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}

class OnboardingStatus {
  final bool hasCompeletedFollowing;
  final bool hasCompeletedInterests;
  final bool hasCompletedBirthDate;

  OnboardingStatus({
    required this.hasCompeletedFollowing,
    required this.hasCompeletedInterests,
    required this.hasCompletedBirthDate,
  });

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) {
    return OnboardingStatus(
      hasCompeletedFollowing: json['hasCompeletedFollowing'],
      hasCompeletedInterests: json['hasCompeletedInterests'],
      hasCompletedBirthDate: json['hasCompletedBirthDate'],
    );
  }
}
