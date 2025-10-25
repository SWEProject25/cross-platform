// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tweet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TweetState {

 bool get isLiked; bool get isReposted; bool get isViewed; AsyncValue<TweetModel> get tweet;
/// Create a copy of TweetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TweetStateCopyWith<TweetState> get copyWith => _$TweetStateCopyWithImpl<TweetState>(this as TweetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TweetState&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isReposted, isReposted) || other.isReposted == isReposted)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.tweet, tweet) || other.tweet == tweet));
}


@override
int get hashCode => Object.hash(runtimeType,isLiked,isReposted,isViewed,tweet);

@override
String toString() {
  return 'TweetState(isLiked: $isLiked, isReposted: $isReposted, isViewed: $isViewed, tweet: $tweet)';
}


}

/// @nodoc
abstract mixin class $TweetStateCopyWith<$Res>  {
  factory $TweetStateCopyWith(TweetState value, $Res Function(TweetState) _then) = _$TweetStateCopyWithImpl;
@useResult
$Res call({
 bool isLiked, bool isReposted, bool isViewed, AsyncValue<TweetModel> tweet
});




}
/// @nodoc
class _$TweetStateCopyWithImpl<$Res>
    implements $TweetStateCopyWith<$Res> {
  _$TweetStateCopyWithImpl(this._self, this._then);

  final TweetState _self;
  final $Res Function(TweetState) _then;

/// Create a copy of TweetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLiked = null,Object? isReposted = null,Object? isViewed = null,Object? tweet = null,}) {
  return _then(_self.copyWith(
isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isReposted: null == isReposted ? _self.isReposted : isReposted // ignore: cast_nullable_to_non_nullable
as bool,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,tweet: null == tweet ? _self.tweet : tweet // ignore: cast_nullable_to_non_nullable
as AsyncValue<TweetModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [TweetState].
extension TweetStatePatterns on TweetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TweetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TweetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TweetState value)  $default,){
final _that = this;
switch (_that) {
case _TweetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TweetState value)?  $default,){
final _that = this;
switch (_that) {
case _TweetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLiked,  bool isReposted,  bool isViewed,  AsyncValue<TweetModel> tweet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TweetState() when $default != null:
return $default(_that.isLiked,_that.isReposted,_that.isViewed,_that.tweet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLiked,  bool isReposted,  bool isViewed,  AsyncValue<TweetModel> tweet)  $default,) {final _that = this;
switch (_that) {
case _TweetState():
return $default(_that.isLiked,_that.isReposted,_that.isViewed,_that.tweet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLiked,  bool isReposted,  bool isViewed,  AsyncValue<TweetModel> tweet)?  $default,) {final _that = this;
switch (_that) {
case _TweetState() when $default != null:
return $default(_that.isLiked,_that.isReposted,_that.isViewed,_that.tweet);case _:
  return null;

}
}

}

/// @nodoc


class _TweetState implements TweetState {
  const _TweetState({required this.isLiked, required this.isReposted, required this.isViewed, required this.tweet});
  

@override final  bool isLiked;
@override final  bool isReposted;
@override final  bool isViewed;
@override final  AsyncValue<TweetModel> tweet;

/// Create a copy of TweetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TweetStateCopyWith<_TweetState> get copyWith => __$TweetStateCopyWithImpl<_TweetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TweetState&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isReposted, isReposted) || other.isReposted == isReposted)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed)&&(identical(other.tweet, tweet) || other.tweet == tweet));
}


@override
int get hashCode => Object.hash(runtimeType,isLiked,isReposted,isViewed,tweet);

@override
String toString() {
  return 'TweetState(isLiked: $isLiked, isReposted: $isReposted, isViewed: $isViewed, tweet: $tweet)';
}


}

/// @nodoc
abstract mixin class _$TweetStateCopyWith<$Res> implements $TweetStateCopyWith<$Res> {
  factory _$TweetStateCopyWith(_TweetState value, $Res Function(_TweetState) _then) = __$TweetStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLiked, bool isReposted, bool isViewed, AsyncValue<TweetModel> tweet
});




}
/// @nodoc
class __$TweetStateCopyWithImpl<$Res>
    implements _$TweetStateCopyWith<$Res> {
  __$TweetStateCopyWithImpl(this._self, this._then);

  final _TweetState _self;
  final $Res Function(_TweetState) _then;

/// Create a copy of TweetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLiked = null,Object? isReposted = null,Object? isViewed = null,Object? tweet = null,}) {
  return _then(_TweetState(
isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isReposted: null == isReposted ? _self.isReposted : isReposted // ignore: cast_nullable_to_non_nullable
as bool,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,tweet: null == tweet ? _self.tweet : tweet // ignore: cast_nullable_to_non_nullable
as AsyncValue<TweetModel>,
  ));
}


}

// dart format on
