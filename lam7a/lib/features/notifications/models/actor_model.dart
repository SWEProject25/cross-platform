// coverage:ignore-file
class ActorModel {
  final int id;
  final String username;
  final String displayName;
  final String? profileImageUrl;

  ActorModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.profileImageUrl,
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    return ActorModel(
      id: json['id'] as int? ?? -1,
      username: json['username'] as String? ?? '@unknown',
      displayName: json['displayName'] as String? ?? 'unknown',
      profileImageUrl: json['avatarUrl'] as String?,
    );
  }
}
