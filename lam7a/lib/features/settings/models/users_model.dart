import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String handle; // e.g. "@mohamedyasser"
  final String displayName; // e.g. "Mohamed Yasser"
  final String bio;
  final String profilePic; // URL or asset path

  const User({
    required this.id,
    required this.handle,
    required this.displayName,
    required this.bio,
    required this.profilePic,
  });

  // Factory method for creating from JSON (useful if you fetch from API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      handle: json['handle'] as String,
      displayName: json['displayName'] as String,
      bio: json['bio'] as String? ?? '',
      profilePic: json['profilePic'] as String? ?? '',
    );
  }

  // Convert to JSON (for saving or sending)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handle': handle,
      'displayName': displayName,
      'bio': bio,
      'profilePic': profilePic,
    };
  }

  // Copy with method — useful for immutability
  User copyWith({
    String? id,
    String? handle,
    String? displayName,
    String? bio,
    String? profilePic,
  }) {
    return User(
      id: id ?? this.id,
      handle: handle ?? this.handle,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  @override
  String toString() =>
      'User(id: $id, handle: $handle, displayName: $displayName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
