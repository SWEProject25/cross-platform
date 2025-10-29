import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

@freezed
abstract class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    required int id,
    required String createdAt,
    required DateTime updatedAt,
    MessageDto? lastMessage,
    required UserDto user,
  }) = _ConversationDto;
 
  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}


@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String username,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    required String displayName,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
