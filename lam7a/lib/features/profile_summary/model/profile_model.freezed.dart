// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileModel {

 String get name; String get username; String get bio; String get imageUrl; bool get isVerified; ProfileStateOfFollow get stateFollow; ProfileStateOfMute get stateMute; ProfileStateBlocked get stateBlocked;
/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<ProfileModel> get copyWith => _$ProfileModelCopyWithImpl<ProfileModel>(this as ProfileModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.username, username) || other.username == username)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.stateFollow, stateFollow) || other.stateFollow == stateFollow)&&(identical(other.stateMute, stateMute) || other.stateMute == stateMute)&&(identical(other.stateBlocked, stateBlocked) || other.stateBlocked == stateBlocked));
}


@override
int get hashCode => Object.hash(runtimeType,name,username,bio,imageUrl,isVerified,stateFollow,stateMute,stateBlocked);

@override
String toString() {
  return 'ProfileModel(name: $name, username: $username, bio: $bio, imageUrl: $imageUrl, isVerified: $isVerified, stateFollow: $stateFollow, stateMute: $stateMute, stateBlocked: $stateBlocked)';
}


}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res>  {
  factory $ProfileModelCopyWith(ProfileModel value, $Res Function(ProfileModel) _then) = _$ProfileModelCopyWithImpl;
@useResult
$Res call({
 String name, String username, String bio, String imageUrl, bool isVerified, ProfileStateOfFollow stateFollow, ProfileStateOfMute stateMute, ProfileStateBlocked stateBlocked
});




}
/// @nodoc
class _$ProfileModelCopyWithImpl<$Res>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? username = null,Object? bio = null,Object? imageUrl = null,Object? isVerified = null,Object? stateFollow = null,Object? stateMute = null,Object? stateBlocked = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,stateFollow: null == stateFollow ? _self.stateFollow : stateFollow // ignore: cast_nullable_to_non_nullable
as ProfileStateOfFollow,stateMute: null == stateMute ? _self.stateMute : stateMute // ignore: cast_nullable_to_non_nullable
as ProfileStateOfMute,stateBlocked: null == stateBlocked ? _self.stateBlocked : stateBlocked // ignore: cast_nullable_to_non_nullable
as ProfileStateBlocked,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String username,  String bio,  String imageUrl,  bool isVerified,  ProfileStateOfFollow stateFollow,  ProfileStateOfMute stateMute,  ProfileStateBlocked stateBlocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.name,_that.username,_that.bio,_that.imageUrl,_that.isVerified,_that.stateFollow,_that.stateMute,_that.stateBlocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String username,  String bio,  String imageUrl,  bool isVerified,  ProfileStateOfFollow stateFollow,  ProfileStateOfMute stateMute,  ProfileStateBlocked stateBlocked)  $default,) {final _that = this;
switch (_that) {
case _ProfileModel():
return $default(_that.name,_that.username,_that.bio,_that.imageUrl,_that.isVerified,_that.stateFollow,_that.stateMute,_that.stateBlocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String username,  String bio,  String imageUrl,  bool isVerified,  ProfileStateOfFollow stateFollow,  ProfileStateOfMute stateMute,  ProfileStateBlocked stateBlocked)?  $default,) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.name,_that.username,_that.bio,_that.imageUrl,_that.isVerified,_that.stateFollow,_that.stateMute,_that.stateBlocked);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileModel implements ProfileModel {
  const _ProfileModel({required this.name, required this.username, required this.bio, required this.imageUrl, required this.isVerified, required this.stateFollow, required this.stateMute, required this.stateBlocked});
  

@override final  String name;
@override final  String username;
@override final  String bio;
@override final  String imageUrl;
@override final  bool isVerified;
@override final  ProfileStateOfFollow stateFollow;
@override final  ProfileStateOfMute stateMute;
@override final  ProfileStateBlocked stateBlocked;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModelCopyWith<_ProfileModel> get copyWith => __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.username, username) || other.username == username)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.stateFollow, stateFollow) || other.stateFollow == stateFollow)&&(identical(other.stateMute, stateMute) || other.stateMute == stateMute)&&(identical(other.stateBlocked, stateBlocked) || other.stateBlocked == stateBlocked));
}


@override
int get hashCode => Object.hash(runtimeType,name,username,bio,imageUrl,isVerified,stateFollow,stateMute,stateBlocked);

@override
String toString() {
  return 'ProfileModel(name: $name, username: $username, bio: $bio, imageUrl: $imageUrl, isVerified: $isVerified, stateFollow: $stateFollow, stateMute: $stateMute, stateBlocked: $stateBlocked)';
}


}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res> implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(_ProfileModel value, $Res Function(_ProfileModel) _then) = __$ProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String username, String bio, String imageUrl, bool isVerified, ProfileStateOfFollow stateFollow, ProfileStateOfMute stateMute, ProfileStateBlocked stateBlocked
});




}
/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? username = null,Object? bio = null,Object? imageUrl = null,Object? isVerified = null,Object? stateFollow = null,Object? stateMute = null,Object? stateBlocked = null,}) {
  return _then(_ProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,stateFollow: null == stateFollow ? _self.stateFollow : stateFollow // ignore: cast_nullable_to_non_nullable
as ProfileStateOfFollow,stateMute: null == stateMute ? _self.stateMute : stateMute // ignore: cast_nullable_to_non_nullable
as ProfileStateOfMute,stateBlocked: null == stateBlocked ? _self.stateBlocked : stateBlocked // ignore: cast_nullable_to_non_nullable
as ProfileStateBlocked,
  ));
}


}

// dart format on
