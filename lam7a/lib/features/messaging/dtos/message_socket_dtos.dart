import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_socket_dtos.freezed.dart';
part 'message_socket_dtos.g.dart';

/// =======================================
/// 📤 CLIENT → SERVER EVENTS (Emit)
/// =======================================

@freezed
abstract class JoinConversationRequest with _$JoinConversationRequest {
  const factory JoinConversationRequest({
    required int conversationId,
  }) = _JoinConversationRequest;

  factory JoinConversationRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinConversationRequestFromJson(json);
}

@freezed
abstract class CreateMessageRequest with _$CreateMessageRequest {
  const factory CreateMessageRequest({
    required int conversationId,
    required int senderId,
    required String text,
  }) = _CreateMessageRequest;

  factory CreateMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMessageRequestFromJson(json);
}

@freezed
abstract class UpdateMessageRequest with _$UpdateMessageRequest {
  const factory UpdateMessageRequest({
    required int id,
    required int senderId,
    required String text,
  }) = _UpdateMessageRequest;

  factory UpdateMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageRequestFromJson(json);
}

@freezed
abstract class MarkSeenRequest with _$MarkSeenRequest {
  const factory MarkSeenRequest({
    required int conversationId,
    required int userId,
  }) = _MarkSeenRequest;

  factory MarkSeenRequest.fromJson(Map<String, dynamic> json) =>
      _$MarkSeenRequestFromJson(json);
}

@freezed
abstract class TypingRequest with _$TypingRequest {
  const factory TypingRequest({
    required int conversationId,
  }) = _TypingRequest;

  factory TypingRequest.fromJson(Map<String, dynamic> json) =>
      _$TypingRequestFromJson(json);
}

/// =======================================
/// 📥 SERVER → CLIENT EVENTS (Listen)
/// =======================================

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    int? id,
    int? senderId,
    int? conversationId,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSeen,
    int? unseenCount,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}

@freezed
abstract class MessagesSeenDto with _$MessagesSeenDto {
  const factory MessagesSeenDto({
    required int conversationId,
    required int userId,
    required DateTime timestamp,
  }) = _MessagesSeenDto;

  factory MessagesSeenDto.fromJson(Map<String, dynamic> json) =>
      _$MessagesSeenDtoFromJson(json);
}

@freezed
abstract class TypingEventDto with _$TypingEventDto {
  const factory TypingEventDto({
    required int conversationId,
    required int userId,
  }) = _TypingEventDto;

  factory TypingEventDto.fromJson(Map<String, dynamic> json) =>
      _$TypingEventDtoFromJson(json);
}

@freezed
abstract class SocketErrorDto with _$SocketErrorDto {
  const factory SocketErrorDto({
    required String status,
    required String message,
    required DateTime timestamp,
  }) = _SocketErrorDto;

  factory SocketErrorDto.fromJson(Map<String, dynamic> json) =>
      _$SocketErrorDtoFromJson(json);
}

/// =======================================
/// ✅ GENERIC SERVER RESPONSE WRAPPER
/// =======================================

@Freezed(genericArgumentFactories: true)
abstract class SocketResponse<T> with _$SocketResponse<T> {
  const factory SocketResponse({
    required String status,
    T? data,
    String? message,
    int? conversationId,
  }) = _SocketResponse<T>;

  /// Notice the `fromJson` signature: it MUST accept a `fromJsonT` function.
  factory SocketResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$SocketResponseFromJson(json, fromJsonT);
}

