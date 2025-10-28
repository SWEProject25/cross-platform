/// Simple User Model without Freezed
class UserModel {
  final int userId;
  final String username;
  final String email;
  final String? displayName;
  final String? profileImageURL;
  final String? bannerImageURL;
  final String? bio;
  final String? location;
  final String? website;
  final DateTime? birthdate;
  final DateTime? createdAt;

  const UserModel({
    required this.userId,
    required this.username,
    required this.email,
    this.displayName,
    this.profileImageURL,
    this.bannerImageURL,
    this.bio,
    this.location,
    this.website,
    this.birthdate,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      profileImageURL: json['profileImageURL'] as String?,
      bannerImageURL: json['bannerImageURL'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      website: json['website'] as String?,
      birthdate: json['birthdate'] != null 
          ? DateTime.parse(json['birthdate'] as String) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'displayName': displayName,
      'profileImageURL': profileImageURL,
      'bannerImageURL': bannerImageURL,
      'bio': bio,
      'location': location,
      'website': website,
      'birthdate': birthdate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
