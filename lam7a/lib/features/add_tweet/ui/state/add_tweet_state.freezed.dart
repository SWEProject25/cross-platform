// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_tweet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddTweetState {

 String get body; bool get isValidBody; bool get isLoading; String? get mediaPicPath; String? get mediaVideoPath; String? get errorMessage; bool get isTweetPosted;
/// Create a copy of AddTweetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddTweetStateCopyWith<AddTweetState> get copyWith => _$AddTweetStateCopyWithImpl<AddTweetState>(this as AddTweetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTweetState&&(identical(other.body, body) || other.body == body)&&(identical(other.isValidBody, isValidBody) || other.isValidBody == isValidBody)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.mediaPicPath, mediaPicPath) || other.mediaPicPath == mediaPicPath)&&(identical(other.mediaVideoPath, mediaVideoPath) || other.mediaVideoPath == mediaVideoPath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isTweetPosted, isTweetPosted) || other.isTweetPosted == isTweetPosted));
}


@override
int get hashCode => Object.hash(runtimeType,body,isValidBody,isLoading,mediaPicPath,mediaVideoPath,errorMessage,isTweetPosted);

@override
String toString() {
  return 'AddTweetState(body: $body, isValidBody: $isValidBody, isLoading: $isLoading, mediaPicPath: $mediaPicPath, mediaVideoPath: $mediaVideoPath, errorMessage: $errorMessage, isTweetPosted: $isTweetPosted)';
}


}

/// @nodoc
abstract mixin class $AddTweetStateCopyWith<$Res>  {
  factory $AddTweetStateCopyWith(AddTweetState value, $Res Function(AddTweetState) _then) = _$AddTweetStateCopyWithImpl;
@useResult
$Res call({
 String body, bool isValidBody, bool isLoading, String? mediaPicPath, String? mediaVideoPath, String? errorMessage, bool isTweetPosted
});




}
/// @nodoc
class _$AddTweetStateCopyWithImpl<$Res>
    implements $AddTweetStateCopyWith<$Res> {
  _$AddTweetStateCopyWithImpl(this._self, this._then);

  final AddTweetState _self;
  final $Res Function(AddTweetState) _then;

/// Create a copy of AddTweetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? body = null,Object? isValidBody = null,Object? isLoading = null,Object? mediaPicPath = freezed,Object? mediaVideoPath = freezed,Object? errorMessage = freezed,Object? isTweetPosted = null,}) {
  return _then(_self.copyWith(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isValidBody: null == isValidBody ? _self.isValidBody : isValidBody // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,mediaPicPath: freezed == mediaPicPath ? _self.mediaPicPath : mediaPicPath // ignore: cast_nullable_to_non_nullable
as String?,mediaVideoPath: freezed == mediaVideoPath ? _self.mediaVideoPath : mediaVideoPath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isTweetPosted: null == isTweetPosted ? _self.isTweetPosted : isTweetPosted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AddTweetState].
extension AddTweetStatePatterns on AddTweetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddTweetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddTweetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddTweetState value)  $default,){
final _that = this;
switch (_that) {
case _AddTweetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddTweetState value)?  $default,){
final _that = this;
switch (_that) {
case _AddTweetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String body,  bool isValidBody,  bool isLoading,  String? mediaPicPath,  String? mediaVideoPath,  String? errorMessage,  bool isTweetPosted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddTweetState() when $default != null:
return $default(_that.body,_that.isValidBody,_that.isLoading,_that.mediaPicPath,_that.mediaVideoPath,_that.errorMessage,_that.isTweetPosted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String body,  bool isValidBody,  bool isLoading,  String? mediaPicPath,  String? mediaVideoPath,  String? errorMessage,  bool isTweetPosted)  $default,) {final _that = this;
switch (_that) {
case _AddTweetState():
return $default(_that.body,_that.isValidBody,_that.isLoading,_that.mediaPicPath,_that.mediaVideoPath,_that.errorMessage,_that.isTweetPosted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String body,  bool isValidBody,  bool isLoading,  String? mediaPicPath,  String? mediaVideoPath,  String? errorMessage,  bool isTweetPosted)?  $default,) {final _that = this;
switch (_that) {
case _AddTweetState() when $default != null:
return $default(_that.body,_that.isValidBody,_that.isLoading,_that.mediaPicPath,_that.mediaVideoPath,_that.errorMessage,_that.isTweetPosted);case _:
  return null;

}
}

}

/// @nodoc


class _AddTweetState implements AddTweetState {
  const _AddTweetState({this.body = "", this.isValidBody = false, this.isLoading = false, this.mediaPicPath, this.mediaVideoPath, this.errorMessage, this.isTweetPosted = false});
  

@override@JsonKey() final  String body;
@override@JsonKey() final  bool isValidBody;
@override@JsonKey() final  bool isLoading;
@override final  String? mediaPicPath;
@override final  String? mediaVideoPath;
@override final  String? errorMessage;
@override@JsonKey() final  bool isTweetPosted;

/// Create a copy of AddTweetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTweetStateCopyWith<_AddTweetState> get copyWith => __$AddTweetStateCopyWithImpl<_AddTweetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTweetState&&(identical(other.body, body) || other.body == body)&&(identical(other.isValidBody, isValidBody) || other.isValidBody == isValidBody)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.mediaPicPath, mediaPicPath) || other.mediaPicPath == mediaPicPath)&&(identical(other.mediaVideoPath, mediaVideoPath) || other.mediaVideoPath == mediaVideoPath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isTweetPosted, isTweetPosted) || other.isTweetPosted == isTweetPosted));
}


@override
int get hashCode => Object.hash(runtimeType,body,isValidBody,isLoading,mediaPicPath,mediaVideoPath,errorMessage,isTweetPosted);

@override
String toString() {
  return 'AddTweetState(body: $body, isValidBody: $isValidBody, isLoading: $isLoading, mediaPicPath: $mediaPicPath, mediaVideoPath: $mediaVideoPath, errorMessage: $errorMessage, isTweetPosted: $isTweetPosted)';
}


}

/// @nodoc
abstract mixin class _$AddTweetStateCopyWith<$Res> implements $AddTweetStateCopyWith<$Res> {
  factory _$AddTweetStateCopyWith(_AddTweetState value, $Res Function(_AddTweetState) _then) = __$AddTweetStateCopyWithImpl;
@override @useResult
$Res call({
 String body, bool isValidBody, bool isLoading, String? mediaPicPath, String? mediaVideoPath, String? errorMessage, bool isTweetPosted
});




}
/// @nodoc
class __$AddTweetStateCopyWithImpl<$Res>
    implements _$AddTweetStateCopyWith<$Res> {
  __$AddTweetStateCopyWithImpl(this._self, this._then);

  final _AddTweetState _self;
  final $Res Function(_AddTweetState) _then;

/// Create a copy of AddTweetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? body = null,Object? isValidBody = null,Object? isLoading = null,Object? mediaPicPath = freezed,Object? mediaVideoPath = freezed,Object? errorMessage = freezed,Object? isTweetPosted = null,}) {
  return _then(_AddTweetState(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isValidBody: null == isValidBody ? _self.isValidBody : isValidBody // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,mediaPicPath: freezed == mediaPicPath ? _self.mediaPicPath : mediaPicPath // ignore: cast_nullable_to_non_nullable
as String?,mediaVideoPath: freezed == mediaVideoPath ? _self.mediaVideoPath : mediaVideoPath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isTweetPosted: null == isTweetPosted ? _self.isTweetPosted : isTweetPosted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
