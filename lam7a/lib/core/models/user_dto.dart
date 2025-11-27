class UserDtoAuth {
  int id;
  int userId;
  String name;
  DateTime birthDate;
  String? profileImageUrl;
  String? bannerImageUrl;
  String? bio;
  String? location;
  String? website;
  bool isDeactivated;
  DateTime createdAt;
  DateTime updatedAt;
  UserDash user;
  int followersCount;
  int followingCount;
  bool isFollowedByMe;

  UserDtoAuth({
    required this.id,
    required this.userId,
    required this.name,
    required this.birthDate,
    this.profileImageUrl,
    required this.bannerImageUrl,
    required this.bio,
    required this.location,
    required this.website,
    required this.isDeactivated,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowedByMe,
  });

  factory UserDtoAuth.fromJson(Map<String, dynamic> json) {
    print("H");
    print(json);
    return UserDtoAuth(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      birthDate: DateTime.parse(json['birth_date']),
      profileImageUrl: json['profile_image_url'],
      bannerImageUrl: json['banner_image_url'],
      bio: json['bio'],
      location: json['location'],
      website: json['website'],
      isDeactivated: json['is_deactivated'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserDash.fromJson(json['User']),
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      isFollowedByMe: json['is_followed_by_me'],
    );
  }
}

class UserDash {
  int id;
  String username;
  String email;
  String role;
  DateTime createdAt;

  UserDash({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory UserDash.fromJson(Map<String, dynamic> json) {
    return UserDash(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
}
