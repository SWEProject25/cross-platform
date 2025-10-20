// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatPageState {

 AsyncValue<List<ChatMessage>> get messages;
/// Create a copy of ChatPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatPageStateCopyWith<ChatPageState> get copyWith => _$ChatPageStateCopyWithImpl<ChatPageState>(this as ChatPageState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatPageState&&(identical(other.messages, messages) || other.messages == messages));
}


@override
int get hashCode => Object.hash(runtimeType,messages);

@override
String toString() {
  return 'ChatPageState(messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ChatPageStateCopyWith<$Res>  {
  factory $ChatPageStateCopyWith(ChatPageState value, $Res Function(ChatPageState) _then) = _$ChatPageStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<ChatMessage>> messages
});




}
/// @nodoc
class _$ChatPageStateCopyWithImpl<$Res>
    implements $ChatPageStateCopyWith<$Res> {
  _$ChatPageStateCopyWithImpl(this._self, this._then);

  final ChatPageState _self;
  final $Res Function(ChatPageState) _then;

/// Create a copy of ChatPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<ChatMessage>>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatPageState].
extension ChatPageStatePatterns on ChatPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatPageState value)  $default,){
final _that = this;
switch (_that) {
case _ChatPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatPageState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<ChatMessage>> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatPageState() when $default != null:
return $default(_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<ChatMessage>> messages)  $default,) {final _that = this;
switch (_that) {
case _ChatPageState():
return $default(_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<ChatMessage>> messages)?  $default,) {final _that = this;
switch (_that) {
case _ChatPageState() when $default != null:
return $default(_that.messages);case _:
  return null;

}
}

}

/// @nodoc


class _ChatPageState implements ChatPageState {
  const _ChatPageState({this.messages = const AsyncValue.loading()});
  

@override@JsonKey() final  AsyncValue<List<ChatMessage>> messages;

/// Create a copy of ChatPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatPageStateCopyWith<_ChatPageState> get copyWith => __$ChatPageStateCopyWithImpl<_ChatPageState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatPageState&&(identical(other.messages, messages) || other.messages == messages));
}


@override
int get hashCode => Object.hash(runtimeType,messages);

@override
String toString() {
  return 'ChatPageState(messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$ChatPageStateCopyWith<$Res> implements $ChatPageStateCopyWith<$Res> {
  factory _$ChatPageStateCopyWith(_ChatPageState value, $Res Function(_ChatPageState) _then) = __$ChatPageStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<ChatMessage>> messages
});




}
/// @nodoc
class __$ChatPageStateCopyWithImpl<$Res>
    implements _$ChatPageStateCopyWith<$Res> {
  __$ChatPageStateCopyWithImpl(this._self, this._then);

  final _ChatPageState _self;
  final $Res Function(_ChatPageState) _then;

/// Create a copy of ChatPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,}) {
  return _then(_ChatPageState(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<ChatMessage>>,
  ));
}


}

// dart format on
