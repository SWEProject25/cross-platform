import 'package:lam7a/features/profile/dtos/profile_dto.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';

ProfileDto makeTestDto() {
  return ProfileDto(
    id: 30,
    userId: 30,
    name: "hossam mohamed",
    birthDate: "2005-07-23T00:00:00.000Z",

    profileImageUrl: "https://cdn/avatar.jpg",
    bannerImageUrl: "https://cdn/banner.jpg",

    bio: "Developer",
    location: "Cairo",
    website: "",
    isDeactivated: false,
    createdAt: "2025-11-23T13:49:47.229Z",
    updatedAt: "2025-11-23T18:33:13.328Z",
    user: {
      "username": "hossam.ho8814",
      "followers_count": 3,
      "following_count": 7,
    },
    followersCount: 3,
    followingCount: 7,
    isFollowedByMe: false,
  );
}


ProfileModel makeTestModel() {
  return ProfileModel(
    id: 30,
    userId: 30,
    displayName: "hossam mohamed",
    handle: "hossam.ho8814",
    bio: "Developer",
    avatarImage: "https://example.com/avatar.jpg",
    bannerImage: "https://example.com/banner.jpg",
    location: "Cairo",
    birthday: "2005-07-23T00:00:00.000Z",
    joinedDate: "2025-11-23T13:49:47.229Z",
    website: "",
    isVerified: false,
    followersCount: 3,
    followingCount: 7,
    stateFollow: ProfileStateOfFollow.notfollowing,
  );
}
