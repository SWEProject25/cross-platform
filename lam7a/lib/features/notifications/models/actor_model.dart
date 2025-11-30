import 'package:lam7a/features/notifications/dtos/notification_dtos.dart';

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

  factory ActorModel.fromDTO(ActorDto dto) {
    return ActorModel(
      id: dto.id ?? -1,
      username: dto.username ?? '@unknown',
      displayName: dto.displayName ?? 'unknown',
      profileImageUrl: dto.avatarUrl,
    );
  }
}
