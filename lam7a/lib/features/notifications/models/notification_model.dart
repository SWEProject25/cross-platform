import 'dart:convert';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/notifications/models/actor_model.dart';

enum NotificationType {
  repost, like, follow,  // Not View
  quote, mention, reply, // Post View
  dm,                    // Pop up not
  unknown}

class NotificationModel {
  final String notificationId;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final TweetModel? post;
  final String? postPreviewText;

  final int? postId;
  final int? threadPostId;
  final int? replyId;
  final int? quoteId;

  final int? conversationId;
  final String? textMessage;

  final ActorModel actor;

  const NotificationModel({
    required this.notificationId,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.actor,
    this.post,
    this.postPreviewText,
    this.conversationId,
    this.textMessage,

    this.postId,
    this.threadPostId,
    this.replyId,
    this.quoteId,
  });

   NotificationModel copyWith({
    String? notificationId,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    ActorModel? actor,
    TweetModel? post,
    String? postPreviewText,
    int? conversationId,
    String? textMessage,

    int? postId,
    int? threadPostId,
    int? replyId,
    int? quoteId,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      actor: actor ?? this.actor,
      post: post ?? this.post,
      postPreviewText: postPreviewText ?? this.postPreviewText,
      conversationId: conversationId ?? this.conversationId,
      textMessage: textMessage ?? this.textMessage,

      postId: postId ?? this.postId,
      threadPostId: threadPostId ?? this.threadPostId,
      replyId: replyId ?? this.replyId,
      quoteId: quoteId ?? this.quoteId,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationTypeFromString(String type) {
      return switch (type) {
        'LIKE' => NotificationType.like,
        'REPOST' => NotificationType.repost,
        'FOLLOW' => NotificationType.follow,
        'MENTION' => NotificationType.mention,
        'REPLY' => NotificationType.reply,
        'QUOTE' => NotificationType.quote,
        'DM' => NotificationType.dm,
        _ => NotificationType.unknown,
      };
    }

    late ActorModel actorModel;
    if (json['actor'] == null) {
      actorModel = ActorModel(
        id: 0,
        username: json['actorUsername'] as String? ?? 'unknown',
        displayName: json['actorDisplayName'] as String? ?? 'Unknown',
        profileImageUrl: json['actorAvatarUrl'] as String? ?? '',
      );
    } else {
      if (json['actor'] is String) {
        actorModel = ActorModel.fromJson(
            Map<String, dynamic>.from(jsonDecode(json['actor'] as String)));
      } else {
        actorModel = ActorModel.fromJson(json['actor'] as Map<String, dynamic>);
      }
    }

    TweetModel? postModel;
    if (json['post'] != null) {
      try {
        if (json['post'] is String) {
          postModel = TweetModel.fromJsonPosts(
              Map<String, dynamic>.from(jsonDecode(json['post'] as String)));
        } else {
          postModel =
              TweetModel.fromJsonPosts(json['post'] as Map<String, dynamic>);
        }
      } catch (e) {
        postModel = null;
        print("Error parsing post in tweet model: $e");
      }
    } else {
      postModel = null;
    }

    return NotificationModel(
      notificationId: json['id'] as String,
      type: notificationTypeFromString(json['type'] as String),
      isRead: (json['isRead'] is String)
        ? json['isRead']?.toString().toLowerCase() == 'true'
        : (json['isRead'] as bool? ?? true),

      createdAt: DateTime.parse(json['createdAt'] as String),
      actor: actorModel,
      post: postModel,
      postPreviewText: json['postPreviewText'] as String?,
      conversationId: json['conversationId'] is String
        ? int.tryParse(json['conversationId'] as String)
        : json['conversationId'] as int?,
      textMessage: json['messagePreview'] as String?,

      postId: json['postId'] is String
        ? int.tryParse(json['postId'] as String)
        : json['postId'] as int?,
      threadPostId: json['threadPostId'] is String
        ? int.tryParse(json['threadPostId'] as String)
        : json['threadPostId'] as int?,
      replyId: json['replyId'] is String
        ? int.tryParse(json['replyId'] as String)
        : json['replyId'] as int?,
    );
  }
}
