// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TweetModel _$TweetModelFromJson(Map<String, dynamic> json) => _TweetModel(
  id: json['id'] as String,
  body: json['body'] as String,
  mediaPic: json['mediaPic'] as String?,
  mediaVideo: json['mediaVideo'] as String?,
  date: DateTime.parse(json['date'] as String),
  likes: (json['likes'] as num).toInt(),
  qoutes: (json['qoutes'] as num).toInt(),
  bookmarks: (json['bookmarks'] as num).toInt(),
  repost: (json['repost'] as num).toInt(),
  comments: (json['comments'] as num).toInt(),
  views: (json['views'] as num).toInt(),
  userId: json['userId'] as String,
);

Map<String, dynamic> _$TweetModelToJson(_TweetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'mediaPic': instance.mediaPic,
      'mediaVideo': instance.mediaVideo,
      'date': instance.date.toIso8601String(),
      'likes': instance.likes,
      'qoutes': instance.qoutes,
      'bookmarks': instance.bookmarks,
      'repost': instance.repost,
      'comments': instance.comments,
      'views': instance.views,
      'userId': instance.userId,
    };
