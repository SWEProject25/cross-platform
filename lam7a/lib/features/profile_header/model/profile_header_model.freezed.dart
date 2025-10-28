// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_header_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileHeaderModel {

 String get bannerImage; String get avatarImage; String get displayName; String get handle; String get bio; String get location; String get joinedDate; List<String> get mutualFollowers; bool get isVerified;
/// Create a copy of ProfileHeaderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileHeaderModelCopyWith<ProfileHeaderModel> get copyWith => _$ProfileHeaderModelCopyWithImpl<ProfileHeaderModel>(this as ProfileHeaderModel, _$identity);

  /// Serializes this ProfileHeaderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileHeaderModel&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.joinedDate, joinedDate) || other.joinedDate == joinedDate)&&const DeepCollectionEquality().equals(other.mutualFollowers, mutualFollowers)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bannerImage,avatarImage,displayName,handle,bio,location,joinedDate,const DeepCollectionEquality().hash(mutualFollowers),isVerified);

@override
String toString() {
  return 'ProfileHeaderModel(bannerImage: $bannerImage, avatarImage: $avatarImage, displayName: $displayName, handle: $handle, bio: $bio, location: $location, joinedDate: $joinedDate, mutualFollowers: $mutualFollowers, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $ProfileHeaderModelCopyWith<$Res>  {
  factory $ProfileHeaderModelCopyWith(ProfileHeaderModel value, $Res Function(ProfileHeaderModel) _then) = _$ProfileHeaderModelCopyWithImpl;
@useResult
$Res call({
 String bannerImage, String avatarImage, String displayName, String handle, String bio, String location, String joinedDate, List<String> mutualFollowers, bool isVerified
});




}
/// @nodoc
class _$ProfileHeaderModelCopyWithImpl<$Res>
    implements $ProfileHeaderModelCopyWith<$Res> {
  _$ProfileHeaderModelCopyWithImpl(this._self, this._then);

  final ProfileHeaderModel _self;
  final $Res Function(ProfileHeaderModel) _then;

/// Create a copy of ProfileHeaderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bannerImage = null,Object? avatarImage = null,Object? displayName = null,Object? handle = null,Object? bio = null,Object? location = null,Object? joinedDate = null,Object? mutualFollowers = null,Object? isVerified = null,}) {
  return _then(_self.copyWith(
bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,joinedDate: null == joinedDate ? _self.joinedDate : joinedDate // ignore: cast_nullable_to_non_nullable
as String,mutualFollowers: null == mutualFollowers ? _self.mutualFollowers : mutualFollowers // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileHeaderModel].
extension ProfileHeaderModelPatterns on ProfileHeaderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileHeaderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileHeaderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileHeaderModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileHeaderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileHeaderModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileHeaderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bannerImage,  String avatarImage,  String displayName,  String handle,  String bio,  String location,  String joinedDate,  List<String> mutualFollowers,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileHeaderModel() when $default != null:
return $default(_that.bannerImage,_that.avatarImage,_that.displayName,_that.handle,_that.bio,_that.location,_that.joinedDate,_that.mutualFollowers,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bannerImage,  String avatarImage,  String displayName,  String handle,  String bio,  String location,  String joinedDate,  List<String> mutualFollowers,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _ProfileHeaderModel():
return $default(_that.bannerImage,_that.avatarImage,_that.displayName,_that.handle,_that.bio,_that.location,_that.joinedDate,_that.mutualFollowers,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bannerImage,  String avatarImage,  String displayName,  String handle,  String bio,  String location,  String joinedDate,  List<String> mutualFollowers,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _ProfileHeaderModel() when $default != null:
return $default(_that.bannerImage,_that.avatarImage,_that.displayName,_that.handle,_that.bio,_that.location,_that.joinedDate,_that.mutualFollowers,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileHeaderModel implements ProfileHeaderModel {
  const _ProfileHeaderModel({required this.bannerImage, required this.avatarImage, required this.displayName, required this.handle, required this.bio, required this.location, required this.joinedDate, required final  List<String> mutualFollowers, required this.isVerified}): _mutualFollowers = mutualFollowers;
  factory _ProfileHeaderModel.fromJson(Map<String, dynamic> json) => _$ProfileHeaderModelFromJson(json);

@override final  String bannerImage;
@override final  String avatarImage;
@override final  String displayName;
@override final  String handle;
@override final  String bio;
@override final  String location;
@override final  String joinedDate;
 final  List<String> _mutualFollowers;
@override List<String> get mutualFollowers {
  if (_mutualFollowers is EqualUnmodifiableListView) return _mutualFollowers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mutualFollowers);
}

@override final  bool isVerified;

/// Create a copy of ProfileHeaderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileHeaderModelCopyWith<_ProfileHeaderModel> get copyWith => __$ProfileHeaderModelCopyWithImpl<_ProfileHeaderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileHeaderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileHeaderModel&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.joinedDate, joinedDate) || other.joinedDate == joinedDate)&&const DeepCollectionEquality().equals(other._mutualFollowers, _mutualFollowers)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bannerImage,avatarImage,displayName,handle,bio,location,joinedDate,const DeepCollectionEquality().hash(_mutualFollowers),isVerified);

@override
String toString() {
  return 'ProfileHeaderModel(bannerImage: $bannerImage, avatarImage: $avatarImage, displayName: $displayName, handle: $handle, bio: $bio, location: $location, joinedDate: $joinedDate, mutualFollowers: $mutualFollowers, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$ProfileHeaderModelCopyWith<$Res> implements $ProfileHeaderModelCopyWith<$Res> {
  factory _$ProfileHeaderModelCopyWith(_ProfileHeaderModel value, $Res Function(_ProfileHeaderModel) _then) = __$ProfileHeaderModelCopyWithImpl;
@override @useResult
$Res call({
 String bannerImage, String avatarImage, String displayName, String handle, String bio, String location, String joinedDate, List<String> mutualFollowers, bool isVerified
});




}
/// @nodoc
class __$ProfileHeaderModelCopyWithImpl<$Res>
    implements _$ProfileHeaderModelCopyWith<$Res> {
  __$ProfileHeaderModelCopyWithImpl(this._self, this._then);

  final _ProfileHeaderModel _self;
  final $Res Function(_ProfileHeaderModel) _then;

/// Create a copy of ProfileHeaderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bannerImage = null,Object? avatarImage = null,Object? displayName = null,Object? handle = null,Object? bio = null,Object? location = null,Object? joinedDate = null,Object? mutualFollowers = null,Object? isVerified = null,}) {
  return _then(_ProfileHeaderModel(
bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,joinedDate: null == joinedDate ? _self.joinedDate : joinedDate // ignore: cast_nullable_to_non_nullable
as String,mutualFollowers: null == mutualFollowers ? _self._mutualFollowers : mutualFollowers // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
