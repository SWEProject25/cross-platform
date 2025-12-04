import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/core/converters/string_to_bool_converter.dart';
import 'package:lam7a/core/converters/string_to_int_converter.dart';

part 'notification_dtos.freezed.dart';
part 'notification_dtos.g.dart';

@freezed
abstract class NotificationsResponse with _$NotificationsResponse {
  const factory NotificationsResponse({
    List<NotificationDto>? data,
    MetadataDto? metadata,
  }) = _NotificationsResponse;

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseFromJson(json);
}

@freezed
abstract class NotificationDto with _$NotificationDto {
  const factory NotificationDto({
    @StringToIntConverter() int? actorId,
    String? actorUsername,
    String? actorDisplayName,
    String? actorAvatarUrl,

    String? id,
    NotificationTypeDTO? type,
    @StringToIntConverter() int? recipientId,
    ActorDto? actor,
    @StringToBoolConverter() bool? isRead,
    DateTime? createdAt,
    @StringToIntConverter() int? postId,
    @StringToIntConverter() int? replyId,
    @StringToIntConverter() int? threadPostId,
    String? postPreviewText,
    @StringToIntConverter() int? conversationId,
    String? messagePreview,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);
}

@freezed
abstract class ActorDto with _$ActorDto {
  const factory ActorDto({
    @StringToIntConverter() int? id,
    String? username,
    String? displayName,
    String? avatarUrl,
  }) = _ActorDto;

  factory ActorDto.fromJson(Map<String, dynamic> json) =>
      _$ActorDtoFromJson(json);
}

@freezed
abstract class MetadataDto with _$MetadataDto {
  const factory MetadataDto({
    int? totalItems,
    int? page,
    int? limit,
    int? totalPages,
    int? unreadCount,
  }) = _MetadataDto;

  factory MetadataDto.fromJson(Map<String, dynamic> json) =>
      _$MetadataDtoFromJson(json);
}

enum NotificationTypeDTO {
  @JsonValue('REPLY')
  reply,

  @JsonValue('LIKE')
  like,

  @JsonValue('REPOST')
  repost,

  @JsonValue('FOLLOW')
  follow,

  @JsonValue('QUOTE')
  quote,

  @JsonValue('MENTION')
  mention,

  @JsonValue('DM')
  directMessage,
}
