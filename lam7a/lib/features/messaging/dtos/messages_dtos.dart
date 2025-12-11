import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';

part 'messages_dtos.freezed.dart';
part 'messages_dtos.g.dart';

@freezed
abstract class MessagesResponseDto with _$MessagesResponseDto {
  const factory MessagesResponseDto({
    required String status,
    required List<MessageDto> data,
    required MessagesMetadataDto metadata,
  }) = _MessagesResponseDto;

  factory MessagesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseDtoFromJson(json);
}

@freezed
abstract class MessagesMetadataDto with _$MessagesMetadataDto {
  const factory MessagesMetadataDto({
    int? totalItems,
    int? limit,
    bool? hasMore,
    int? lastMessageId,
  }) = _MessagesMetadataDto;

  factory MessagesMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$MessagesMetadataDtoFromJson(json);
}
