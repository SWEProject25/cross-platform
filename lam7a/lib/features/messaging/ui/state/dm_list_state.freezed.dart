// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dm_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DMListState {

 AsyncValue<List<Conversation>> get conversations; AsyncValue<List<Contact>> get contacts;
/// Create a copy of DMListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DMListStateCopyWith<DMListState> get copyWith => _$DMListStateCopyWithImpl<DMListState>(this as DMListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DMListState&&(identical(other.conversations, conversations) || other.conversations == conversations)&&(identical(other.contacts, contacts) || other.contacts == contacts));
}


@override
int get hashCode => Object.hash(runtimeType,conversations,contacts);

@override
String toString() {
  return 'DMListState(conversations: $conversations, contacts: $contacts)';
}


}

/// @nodoc
abstract mixin class $DMListStateCopyWith<$Res>  {
  factory $DMListStateCopyWith(DMListState value, $Res Function(DMListState) _then) = _$DMListStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<List<Conversation>> conversations, AsyncValue<List<Contact>> contacts
});




}
/// @nodoc
class _$DMListStateCopyWithImpl<$Res>
    implements $DMListStateCopyWith<$Res> {
  _$DMListStateCopyWithImpl(this._self, this._then);

  final DMListState _self;
  final $Res Function(DMListState) _then;

/// Create a copy of DMListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversations = null,Object? contacts = null,}) {
  return _then(_self.copyWith(
conversations: null == conversations ? _self.conversations : conversations // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<Conversation>>,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<Contact>>,
  ));
}

}


/// Adds pattern-matching-related methods to [DMListState].
extension DMListStatePatterns on DMListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DMListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DMListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DMListState value)  $default,){
final _that = this;
switch (_that) {
case _DMListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DMListState value)?  $default,){
final _that = this;
switch (_that) {
case _DMListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<List<Conversation>> conversations,  AsyncValue<List<Contact>> contacts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DMListState() when $default != null:
return $default(_that.conversations,_that.contacts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<List<Conversation>> conversations,  AsyncValue<List<Contact>> contacts)  $default,) {final _that = this;
switch (_that) {
case _DMListState():
return $default(_that.conversations,_that.contacts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<List<Conversation>> conversations,  AsyncValue<List<Contact>> contacts)?  $default,) {final _that = this;
switch (_that) {
case _DMListState() when $default != null:
return $default(_that.conversations,_that.contacts);case _:
  return null;

}
}

}

/// @nodoc


class _DMListState implements DMListState {
  const _DMListState({this.conversations = const AsyncValue.loading(), this.contacts = const AsyncValue.loading()});
  

@override@JsonKey() final  AsyncValue<List<Conversation>> conversations;
@override@JsonKey() final  AsyncValue<List<Contact>> contacts;

/// Create a copy of DMListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DMListStateCopyWith<_DMListState> get copyWith => __$DMListStateCopyWithImpl<_DMListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DMListState&&(identical(other.conversations, conversations) || other.conversations == conversations)&&(identical(other.contacts, contacts) || other.contacts == contacts));
}


@override
int get hashCode => Object.hash(runtimeType,conversations,contacts);

@override
String toString() {
  return 'DMListState(conversations: $conversations, contacts: $contacts)';
}


}

/// @nodoc
abstract mixin class _$DMListStateCopyWith<$Res> implements $DMListStateCopyWith<$Res> {
  factory _$DMListStateCopyWith(_DMListState value, $Res Function(_DMListState) _then) = __$DMListStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<List<Conversation>> conversations, AsyncValue<List<Contact>> contacts
});




}
/// @nodoc
class __$DMListStateCopyWithImpl<$Res>
    implements _$DMListStateCopyWith<$Res> {
  __$DMListStateCopyWithImpl(this._self, this._then);

  final _DMListState _self;
  final $Res Function(_DMListState) _then;

/// Create a copy of DMListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversations = null,Object? contacts = null,}) {
  return _then(_DMListState(
conversations: null == conversations ? _self.conversations : conversations // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<Conversation>>,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as AsyncValue<List<Contact>>,
  ));
}


}

// dart format on
