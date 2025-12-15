// coverage:ignore-file
import 'package:lam7a/features/authentication/model/user_dto_model.dart';

class UserToFollowDto {
  int? id;
  String? username;
  String? email;
  UserToFollowProfile? profile;
  int? followersCount;
  bool isFollowing = false;
  
  UserToFollowDto({
    this.id,
    this.username,
    this.email,
    this.profile,
    this.followersCount,
    this.isFollowing = false,
  });
  
  factory UserToFollowDto.fromJson(Map<String, dynamic> json) {
    return UserToFollowDto(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profile: json['profile'] != null
          ? UserToFollowProfile(
              name: json['profile']['name'],
              bio: json['profile']['bio'],
              profileImageUrl: json['profile']['profileImageUrl'],
              bannerImageUrl: json['profile']['bannerImageUrl'],
              location: json['profile']['location'],
              website: json['profile']['website'],
            )
          : null,
      followersCount: json['followersCount'],
    );
  }

  UserToFollowDto copyWith({
    int? id,
    String? username,
    String? email,
    UserToFollowProfile? profile,
    int? followersCount,
    bool? isFollowing,
  }) {
    return UserToFollowDto(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      followersCount: followersCount ?? this.followersCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

class UserToFollowProfile {
  String? name;
  String? bio;
  String? profileImageUrl;
  String? bannerImageUrl;
  String? location;
  String? website;
  
  UserToFollowProfile({
    this.name,
    this.bio,
    this.profileImageUrl,
    this.bannerImageUrl,
    this.location,
    this.website,
  });

  UserToFollowProfile copyWith({
    String? name,
    String? bio,
    String? profileImageUrl,
    String? bannerImageUrl,
    String? location,
    String? website,
  }) {
    return UserToFollowProfile(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      location: location ?? this.location,
      website: website ?? this.website,
    );
  }
}