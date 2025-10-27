// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tweet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TweetModel {

 String get id; String get body; String? get mediaPic; String? get mediaVideo; DateTime get date; int get likes; int get qoutes; int get bookmarks; int get repost; int get comments; int get views; String get userId;
/// Create a copy of TweetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TweetModelCopyWith<TweetModel> get copyWith => _$TweetModelCopyWithImpl<TweetModel>(this as TweetModel, _$identity);

  /// Serializes this TweetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TweetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.mediaPic, mediaPic) || other.mediaPic == mediaPic)&&(identical(other.mediaVideo, mediaVideo) || other.mediaVideo == mediaVideo)&&(identical(other.date, date) || other.date == date)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.qoutes, qoutes) || other.qoutes == qoutes)&&(identical(other.bookmarks, bookmarks) || other.bookmarks == bookmarks)&&(identical(other.repost, repost) || other.repost == repost)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.views, views) || other.views == views)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,mediaPic,mediaVideo,date,likes,qoutes,bookmarks,repost,comments,views,userId);

@override
String toString() {
  return 'TweetModel(id: $id, body: $body, mediaPic: $mediaPic, mediaVideo: $mediaVideo, date: $date, likes: $likes, qoutes: $qoutes, bookmarks: $bookmarks, repost: $repost, comments: $comments, views: $views, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $TweetModelCopyWith<$Res>  {
  factory $TweetModelCopyWith(TweetModel value, $Res Function(TweetModel) _then) = _$TweetModelCopyWithImpl;
@useResult
$Res call({
 String id, String body, String? mediaPic, String? mediaVideo, DateTime date, int likes, int qoutes, int bookmarks, int repost, int comments, int views, String userId
});




}
/// @nodoc
class _$TweetModelCopyWithImpl<$Res>
    implements $TweetModelCopyWith<$Res> {
  _$TweetModelCopyWithImpl(this._self, this._then);

  final TweetModel _self;
  final $Res Function(TweetModel) _then;

/// Create a copy of TweetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? mediaPic = freezed,Object? mediaVideo = freezed,Object? date = null,Object? likes = null,Object? qoutes = null,Object? bookmarks = null,Object? repost = null,Object? comments = null,Object? views = null,Object? userId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,mediaPic: freezed == mediaPic ? _self.mediaPic : mediaPic // ignore: cast_nullable_to_non_nullable
as String?,mediaVideo: freezed == mediaVideo ? _self.mediaVideo : mediaVideo // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,qoutes: null == qoutes ? _self.qoutes : qoutes // ignore: cast_nullable_to_non_nullable
as int,bookmarks: null == bookmarks ? _self.bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as int,repost: null == repost ? _self.repost : repost // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TweetModel].
extension TweetModelPatterns on TweetModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TweetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TweetModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TweetModel value)  $default,){
final _that = this;
switch (_that) {
case _TweetModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TweetModel value)?  $default,){
final _that = this;
switch (_that) {
case _TweetModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String body,  String? mediaPic,  String? mediaVideo,  DateTime date,  int likes,  int qoutes,  int bookmarks,  int repost,  int comments,  int views,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TweetModel() when $default != null:
return $default(_that.id,_that.body,_that.mediaPic,_that.mediaVideo,_that.date,_that.likes,_that.qoutes,_that.bookmarks,_that.repost,_that.comments,_that.views,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String body,  String? mediaPic,  String? mediaVideo,  DateTime date,  int likes,  int qoutes,  int bookmarks,  int repost,  int comments,  int views,  String userId)  $default,) {final _that = this;
switch (_that) {
case _TweetModel():
return $default(_that.id,_that.body,_that.mediaPic,_that.mediaVideo,_that.date,_that.likes,_that.qoutes,_that.bookmarks,_that.repost,_that.comments,_that.views,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String body,  String? mediaPic,  String? mediaVideo,  DateTime date,  int likes,  int qoutes,  int bookmarks,  int repost,  int comments,  int views,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _TweetModel() when $default != null:
return $default(_that.id,_that.body,_that.mediaPic,_that.mediaVideo,_that.date,_that.likes,_that.qoutes,_that.bookmarks,_that.repost,_that.comments,_that.views,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TweetModel implements TweetModel {
  const _TweetModel({required this.id, required this.body, this.mediaPic, this.mediaVideo, required this.date, required this.likes, required this.qoutes, required this.bookmarks, required this.repost, required this.comments, required this.views, required this.userId});
  factory _TweetModel.fromJson(Map<String, dynamic> json) => _$TweetModelFromJson(json);

@override final  String id;
@override final  String body;
@override final  String? mediaPic;
@override final  String? mediaVideo;
@override final  DateTime date;
@override final  int likes;
@override final  int qoutes;
@override final  int bookmarks;
@override final  int repost;
@override final  int comments;
@override final  int views;
@override final  String userId;

/// Create a copy of TweetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TweetModelCopyWith<_TweetModel> get copyWith => __$TweetModelCopyWithImpl<_TweetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TweetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TweetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.mediaPic, mediaPic) || other.mediaPic == mediaPic)&&(identical(other.mediaVideo, mediaVideo) || other.mediaVideo == mediaVideo)&&(identical(other.date, date) || other.date == date)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.qoutes, qoutes) || other.qoutes == qoutes)&&(identical(other.bookmarks, bookmarks) || other.bookmarks == bookmarks)&&(identical(other.repost, repost) || other.repost == repost)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.views, views) || other.views == views)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,mediaPic,mediaVideo,date,likes,qoutes,bookmarks,repost,comments,views,userId);

@override
String toString() {
  return 'TweetModel(id: $id, body: $body, mediaPic: $mediaPic, mediaVideo: $mediaVideo, date: $date, likes: $likes, qoutes: $qoutes, bookmarks: $bookmarks, repost: $repost, comments: $comments, views: $views, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$TweetModelCopyWith<$Res> implements $TweetModelCopyWith<$Res> {
  factory _$TweetModelCopyWith(_TweetModel value, $Res Function(_TweetModel) _then) = __$TweetModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String body, String? mediaPic, String? mediaVideo, DateTime date, int likes, int qoutes, int bookmarks, int repost, int comments, int views, String userId
});




}
/// @nodoc
class __$TweetModelCopyWithImpl<$Res>
    implements _$TweetModelCopyWith<$Res> {
  __$TweetModelCopyWithImpl(this._self, this._then);

  final _TweetModel _self;
  final $Res Function(_TweetModel) _then;

/// Create a copy of TweetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? mediaPic = freezed,Object? mediaVideo = freezed,Object? date = null,Object? likes = null,Object? qoutes = null,Object? bookmarks = null,Object? repost = null,Object? comments = null,Object? views = null,Object? userId = null,}) {
  return _then(_TweetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,mediaPic: freezed == mediaPic ? _self.mediaPic : mediaPic // ignore: cast_nullable_to_non_nullable
as String?,mediaVideo: freezed == mediaVideo ? _self.mediaVideo : mediaVideo // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,qoutes: null == qoutes ? _self.qoutes : qoutes // ignore: cast_nullable_to_non_nullable
as int,bookmarks: null == bookmarks ? _self.bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as int,repost: null == repost ? _self.repost : repost // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
