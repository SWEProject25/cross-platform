// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditProfileModel {

 String get displayName; String get bio; String get location; String get avatarImage; String get bannerImage;
/// Create a copy of EditProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileModelCopyWith<EditProfileModel> get copyWith => _$EditProfileModelCopyWithImpl<EditProfileModel>(this as EditProfileModel, _$identity);

  /// Serializes this EditProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileModel&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,bio,location,avatarImage,bannerImage);

@override
String toString() {
  return 'EditProfileModel(displayName: $displayName, bio: $bio, location: $location, avatarImage: $avatarImage, bannerImage: $bannerImage)';
}


}

/// @nodoc
abstract mixin class $EditProfileModelCopyWith<$Res>  {
  factory $EditProfileModelCopyWith(EditProfileModel value, $Res Function(EditProfileModel) _then) = _$EditProfileModelCopyWithImpl;
@useResult
$Res call({
 String displayName, String bio, String location, String avatarImage, String bannerImage
});




}
/// @nodoc
class _$EditProfileModelCopyWithImpl<$Res>
    implements $EditProfileModelCopyWith<$Res> {
  _$EditProfileModelCopyWithImpl(this._self, this._then);

  final EditProfileModel _self;
  final $Res Function(EditProfileModel) _then;

/// Create a copy of EditProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? bio = null,Object? location = null,Object? avatarImage = null,Object? bannerImage = null,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProfileModel].
extension EditProfileModelPatterns on EditProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _EditProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _EditProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  String bio,  String location,  String avatarImage,  String bannerImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileModel() when $default != null:
return $default(_that.displayName,_that.bio,_that.location,_that.avatarImage,_that.bannerImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  String bio,  String location,  String avatarImage,  String bannerImage)  $default,) {final _that = this;
switch (_that) {
case _EditProfileModel():
return $default(_that.displayName,_that.bio,_that.location,_that.avatarImage,_that.bannerImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  String bio,  String location,  String avatarImage,  String bannerImage)?  $default,) {final _that = this;
switch (_that) {
case _EditProfileModel() when $default != null:
return $default(_that.displayName,_that.bio,_that.location,_that.avatarImage,_that.bannerImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditProfileModel implements EditProfileModel {
  const _EditProfileModel({required this.displayName, required this.bio, required this.location, required this.avatarImage, required this.bannerImage});
  factory _EditProfileModel.fromJson(Map<String, dynamic> json) => _$EditProfileModelFromJson(json);

@override final  String displayName;
@override final  String bio;
@override final  String location;
@override final  String avatarImage;
@override final  String bannerImage;

/// Create a copy of EditProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileModelCopyWith<_EditProfileModel> get copyWith => __$EditProfileModelCopyWithImpl<_EditProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileModel&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.location, location) || other.location == location)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,bio,location,avatarImage,bannerImage);

@override
String toString() {
  return 'EditProfileModel(displayName: $displayName, bio: $bio, location: $location, avatarImage: $avatarImage, bannerImage: $bannerImage)';
}


}

/// @nodoc
abstract mixin class _$EditProfileModelCopyWith<$Res> implements $EditProfileModelCopyWith<$Res> {
  factory _$EditProfileModelCopyWith(_EditProfileModel value, $Res Function(_EditProfileModel) _then) = __$EditProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String displayName, String bio, String location, String avatarImage, String bannerImage
});




}
/// @nodoc
class __$EditProfileModelCopyWithImpl<$Res>
    implements _$EditProfileModelCopyWith<$Res> {
  __$EditProfileModelCopyWithImpl(this._self, this._then);

  final _EditProfileModel _self;
  final $Res Function(_EditProfileModel) _then;

/// Create a copy of EditProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? bio = null,Object? location = null,Object? avatarImage = null,Object? bannerImage = null,}) {
  return _then(_EditProfileModel(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
