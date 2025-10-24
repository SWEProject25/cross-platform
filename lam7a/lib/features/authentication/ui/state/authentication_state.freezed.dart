// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState()';
}


}

/// @nodoc
class $AuthenticationStateCopyWith<$Res>  {
$AuthenticationStateCopyWith(AuthenticationState _, $Res Function(AuthenticationState) __);
}


/// Adds pattern-matching-related methods to [AuthenticationState].
extension AuthenticationStatePatterns on AuthenticationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoginState value)?  login,TResult Function( _SignupState value)?  signup,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when login != null:
return login(_that);case _SignupState() when signup != null:
return signup(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoginState value)  login,required TResult Function( _SignupState value)  signup,}){
final _that = this;
switch (_that) {
case _LoginState():
return login(_that);case _SignupState():
return signup(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoginState value)?  login,TResult? Function( _SignupState value)?  signup,}){
final _that = this;
switch (_that) {
case _LoginState() when login != null:
return login(_that);case _SignupState() when signup != null:
return signup(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String identifier,  String passwordLogin,  int currentLoginStep,  bool isLoadingLogin)?  login,TResult Function( String name,  bool isValidName,  String email,  bool isValidEmail,  String passwordSignup,  bool isValidSignupPassword,  String code,  bool isValidCode,  String username,  bool isValidUsername,  String date,  bool isValidDate,  String imgPath,  int currentSignupStep,  bool isLoadingSignup,  bool isNextEnabled)?  signup,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when login != null:
return login(_that.identifier,_that.passwordLogin,_that.currentLoginStep,_that.isLoadingLogin);case _SignupState() when signup != null:
return signup(_that.name,_that.isValidName,_that.email,_that.isValidEmail,_that.passwordSignup,_that.isValidSignupPassword,_that.code,_that.isValidCode,_that.username,_that.isValidUsername,_that.date,_that.isValidDate,_that.imgPath,_that.currentSignupStep,_that.isLoadingSignup,_that.isNextEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String identifier,  String passwordLogin,  int currentLoginStep,  bool isLoadingLogin)  login,required TResult Function( String name,  bool isValidName,  String email,  bool isValidEmail,  String passwordSignup,  bool isValidSignupPassword,  String code,  bool isValidCode,  String username,  bool isValidUsername,  String date,  bool isValidDate,  String imgPath,  int currentSignupStep,  bool isLoadingSignup,  bool isNextEnabled)  signup,}) {final _that = this;
switch (_that) {
case _LoginState():
return login(_that.identifier,_that.passwordLogin,_that.currentLoginStep,_that.isLoadingLogin);case _SignupState():
return signup(_that.name,_that.isValidName,_that.email,_that.isValidEmail,_that.passwordSignup,_that.isValidSignupPassword,_that.code,_that.isValidCode,_that.username,_that.isValidUsername,_that.date,_that.isValidDate,_that.imgPath,_that.currentSignupStep,_that.isLoadingSignup,_that.isNextEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String identifier,  String passwordLogin,  int currentLoginStep,  bool isLoadingLogin)?  login,TResult? Function( String name,  bool isValidName,  String email,  bool isValidEmail,  String passwordSignup,  bool isValidSignupPassword,  String code,  bool isValidCode,  String username,  bool isValidUsername,  String date,  bool isValidDate,  String imgPath,  int currentSignupStep,  bool isLoadingSignup,  bool isNextEnabled)?  signup,}) {final _that = this;
switch (_that) {
case _LoginState() when login != null:
return login(_that.identifier,_that.passwordLogin,_that.currentLoginStep,_that.isLoadingLogin);case _SignupState() when signup != null:
return signup(_that.name,_that.isValidName,_that.email,_that.isValidEmail,_that.passwordSignup,_that.isValidSignupPassword,_that.code,_that.isValidCode,_that.username,_that.isValidUsername,_that.date,_that.isValidDate,_that.imgPath,_that.currentSignupStep,_that.isLoadingSignup,_that.isNextEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState extends AuthenticationState {
  const _LoginState({this.identifier = "", this.passwordLogin = "", this.currentLoginStep = 0, this.isLoadingLogin = false}): super._();
  

@JsonKey() final  String identifier;
@JsonKey() final  String passwordLogin;
@JsonKey() final  int currentLoginStep;
@JsonKey() final  bool isLoadingLogin;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.passwordLogin, passwordLogin) || other.passwordLogin == passwordLogin)&&(identical(other.currentLoginStep, currentLoginStep) || other.currentLoginStep == currentLoginStep)&&(identical(other.isLoadingLogin, isLoadingLogin) || other.isLoadingLogin == isLoadingLogin));
}


@override
int get hashCode => Object.hash(runtimeType,identifier,passwordLogin,currentLoginStep,isLoadingLogin);

@override
String toString() {
  return 'AuthenticationState.login(identifier: $identifier, passwordLogin: $passwordLogin, currentLoginStep: $currentLoginStep, isLoadingLogin: $isLoadingLogin)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $AuthenticationStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@useResult
$Res call({
 String identifier, String passwordLogin, int currentLoginStep, bool isLoadingLogin
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? identifier = null,Object? passwordLogin = null,Object? currentLoginStep = null,Object? isLoadingLogin = null,}) {
  return _then(_LoginState(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,passwordLogin: null == passwordLogin ? _self.passwordLogin : passwordLogin // ignore: cast_nullable_to_non_nullable
as String,currentLoginStep: null == currentLoginStep ? _self.currentLoginStep : currentLoginStep // ignore: cast_nullable_to_non_nullable
as int,isLoadingLogin: null == isLoadingLogin ? _self.isLoadingLogin : isLoadingLogin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _SignupState extends AuthenticationState {
  const _SignupState({this.name = "", this.isValidName = false, this.email = "", this.isValidEmail = false, this.passwordSignup = "", this.isValidSignupPassword = false, this.code = "", this.isValidCode = false, this.username = "", this.isValidUsername = false, this.date = "", this.isValidDate = false, this.imgPath = "", this.currentSignupStep = 0, this.isLoadingSignup = false, this.isNextEnabled = false}): super._();
  

@JsonKey() final  String name;
@JsonKey() final  bool isValidName;
@JsonKey() final  String email;
@JsonKey() final  bool isValidEmail;
@JsonKey() final  String passwordSignup;
@JsonKey() final  bool isValidSignupPassword;
@JsonKey() final  String code;
@JsonKey() final  bool isValidCode;
@JsonKey() final  String username;
@JsonKey() final  bool isValidUsername;
@JsonKey() final  String date;
@JsonKey() final  bool isValidDate;
@JsonKey() final  String imgPath;
@JsonKey() final  int currentSignupStep;
@JsonKey() final  bool isLoadingSignup;
@JsonKey() final  bool isNextEnabled;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignupStateCopyWith<_SignupState> get copyWith => __$SignupStateCopyWithImpl<_SignupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignupState&&(identical(other.name, name) || other.name == name)&&(identical(other.isValidName, isValidName) || other.isValidName == isValidName)&&(identical(other.email, email) || other.email == email)&&(identical(other.isValidEmail, isValidEmail) || other.isValidEmail == isValidEmail)&&(identical(other.passwordSignup, passwordSignup) || other.passwordSignup == passwordSignup)&&(identical(other.isValidSignupPassword, isValidSignupPassword) || other.isValidSignupPassword == isValidSignupPassword)&&(identical(other.code, code) || other.code == code)&&(identical(other.isValidCode, isValidCode) || other.isValidCode == isValidCode)&&(identical(other.username, username) || other.username == username)&&(identical(other.isValidUsername, isValidUsername) || other.isValidUsername == isValidUsername)&&(identical(other.date, date) || other.date == date)&&(identical(other.isValidDate, isValidDate) || other.isValidDate == isValidDate)&&(identical(other.imgPath, imgPath) || other.imgPath == imgPath)&&(identical(other.currentSignupStep, currentSignupStep) || other.currentSignupStep == currentSignupStep)&&(identical(other.isLoadingSignup, isLoadingSignup) || other.isLoadingSignup == isLoadingSignup)&&(identical(other.isNextEnabled, isNextEnabled) || other.isNextEnabled == isNextEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,name,isValidName,email,isValidEmail,passwordSignup,isValidSignupPassword,code,isValidCode,username,isValidUsername,date,isValidDate,imgPath,currentSignupStep,isLoadingSignup,isNextEnabled);

@override
String toString() {
  return 'AuthenticationState.signup(name: $name, isValidName: $isValidName, email: $email, isValidEmail: $isValidEmail, passwordSignup: $passwordSignup, isValidSignupPassword: $isValidSignupPassword, code: $code, isValidCode: $isValidCode, username: $username, isValidUsername: $isValidUsername, date: $date, isValidDate: $isValidDate, imgPath: $imgPath, currentSignupStep: $currentSignupStep, isLoadingSignup: $isLoadingSignup, isNextEnabled: $isNextEnabled)';
}


}

/// @nodoc
abstract mixin class _$SignupStateCopyWith<$Res> implements $AuthenticationStateCopyWith<$Res> {
  factory _$SignupStateCopyWith(_SignupState value, $Res Function(_SignupState) _then) = __$SignupStateCopyWithImpl;
@useResult
$Res call({
 String name, bool isValidName, String email, bool isValidEmail, String passwordSignup, bool isValidSignupPassword, String code, bool isValidCode, String username, bool isValidUsername, String date, bool isValidDate, String imgPath, int currentSignupStep, bool isLoadingSignup, bool isNextEnabled
});




}
/// @nodoc
class __$SignupStateCopyWithImpl<$Res>
    implements _$SignupStateCopyWith<$Res> {
  __$SignupStateCopyWithImpl(this._self, this._then);

  final _SignupState _self;
  final $Res Function(_SignupState) _then;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isValidName = null,Object? email = null,Object? isValidEmail = null,Object? passwordSignup = null,Object? isValidSignupPassword = null,Object? code = null,Object? isValidCode = null,Object? username = null,Object? isValidUsername = null,Object? date = null,Object? isValidDate = null,Object? imgPath = null,Object? currentSignupStep = null,Object? isLoadingSignup = null,Object? isNextEnabled = null,}) {
  return _then(_SignupState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isValidName: null == isValidName ? _self.isValidName : isValidName // ignore: cast_nullable_to_non_nullable
as bool,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isValidEmail: null == isValidEmail ? _self.isValidEmail : isValidEmail // ignore: cast_nullable_to_non_nullable
as bool,passwordSignup: null == passwordSignup ? _self.passwordSignup : passwordSignup // ignore: cast_nullable_to_non_nullable
as String,isValidSignupPassword: null == isValidSignupPassword ? _self.isValidSignupPassword : isValidSignupPassword // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,isValidCode: null == isValidCode ? _self.isValidCode : isValidCode // ignore: cast_nullable_to_non_nullable
as bool,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,isValidUsername: null == isValidUsername ? _self.isValidUsername : isValidUsername // ignore: cast_nullable_to_non_nullable
as bool,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,isValidDate: null == isValidDate ? _self.isValidDate : isValidDate // ignore: cast_nullable_to_non_nullable
as bool,imgPath: null == imgPath ? _self.imgPath : imgPath // ignore: cast_nullable_to_non_nullable
as String,currentSignupStep: null == currentSignupStep ? _self.currentSignupStep : currentSignupStep // ignore: cast_nullable_to_non_nullable
as int,isLoadingSignup: null == isLoadingSignup ? _self.isLoadingSignup : isLoadingSignup // ignore: cast_nullable_to_non_nullable
as bool,isNextEnabled: null == isNextEnabled ? _self.isNextEnabled : isNextEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
