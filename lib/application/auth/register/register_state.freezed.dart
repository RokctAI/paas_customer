// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterState {

 bool get isLoading; bool get isSuccess; bool get showPassword; bool get showConfirmPassword; bool get isEmailInvalid; bool get isPasswordInvalid; bool get isConfirmPasswordInvalid; String get phone; String get verificationId; String get email; String get referral; String get firstName; String get lastName; String get password; String get confirmPassword;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.showPassword, showPassword) || other.showPassword == showPassword)&&(identical(other.showConfirmPassword, showConfirmPassword) || other.showConfirmPassword == showConfirmPassword)&&(identical(other.isEmailInvalid, isEmailInvalid) || other.isEmailInvalid == isEmailInvalid)&&(identical(other.isPasswordInvalid, isPasswordInvalid) || other.isPasswordInvalid == isPasswordInvalid)&&(identical(other.isConfirmPasswordInvalid, isConfirmPasswordInvalid) || other.isConfirmPasswordInvalid == isConfirmPasswordInvalid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.email, email) || other.email == email)&&(identical(other.referral, referral) || other.referral == referral)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSuccess,showPassword,showConfirmPassword,isEmailInvalid,isPasswordInvalid,isConfirmPasswordInvalid,phone,verificationId,email,referral,firstName,lastName,password,confirmPassword);

@override
String toString() {
  return 'RegisterState(isLoading: $isLoading, isSuccess: $isSuccess, showPassword: $showPassword, showConfirmPassword: $showConfirmPassword, isEmailInvalid: $isEmailInvalid, isPasswordInvalid: $isPasswordInvalid, isConfirmPasswordInvalid: $isConfirmPasswordInvalid, phone: $phone, verificationId: $verificationId, email: $email, referral: $referral, firstName: $firstName, lastName: $lastName, password: $password, confirmPassword: $confirmPassword)';
}


}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSuccess, bool showPassword, bool showConfirmPassword, bool isEmailInvalid, bool isPasswordInvalid, bool isConfirmPasswordInvalid, String phone, String verificationId, String email, String referral, String firstName, String lastName, String password, String confirmPassword
});




}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSuccess = null,Object? showPassword = null,Object? showConfirmPassword = null,Object? isEmailInvalid = null,Object? isPasswordInvalid = null,Object? isConfirmPasswordInvalid = null,Object? phone = null,Object? verificationId = null,Object? email = null,Object? referral = null,Object? firstName = null,Object? lastName = null,Object? password = null,Object? confirmPassword = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,showPassword: null == showPassword ? _self.showPassword : showPassword // ignore: cast_nullable_to_non_nullable
as bool,showConfirmPassword: null == showConfirmPassword ? _self.showConfirmPassword : showConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,isEmailInvalid: null == isEmailInvalid ? _self.isEmailInvalid : isEmailInvalid // ignore: cast_nullable_to_non_nullable
as bool,isPasswordInvalid: null == isPasswordInvalid ? _self.isPasswordInvalid : isPasswordInvalid // ignore: cast_nullable_to_non_nullable
as bool,isConfirmPasswordInvalid: null == isConfirmPasswordInvalid ? _self.isConfirmPasswordInvalid : isConfirmPasswordInvalid // ignore: cast_nullable_to_non_nullable
as bool,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,referral: null == referral ? _self.referral : referral // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSuccess,  bool showPassword,  bool showConfirmPassword,  bool isEmailInvalid,  bool isPasswordInvalid,  bool isConfirmPasswordInvalid,  String phone,  String verificationId,  String email,  String referral,  String firstName,  String lastName,  String password,  String confirmPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.isLoading,_that.isSuccess,_that.showPassword,_that.showConfirmPassword,_that.isEmailInvalid,_that.isPasswordInvalid,_that.isConfirmPasswordInvalid,_that.phone,_that.verificationId,_that.email,_that.referral,_that.firstName,_that.lastName,_that.password,_that.confirmPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSuccess,  bool showPassword,  bool showConfirmPassword,  bool isEmailInvalid,  bool isPasswordInvalid,  bool isConfirmPasswordInvalid,  String phone,  String verificationId,  String email,  String referral,  String firstName,  String lastName,  String password,  String confirmPassword)  $default,) {final _that = this;
switch (_that) {
case _RegisterState():
return $default(_that.isLoading,_that.isSuccess,_that.showPassword,_that.showConfirmPassword,_that.isEmailInvalid,_that.isPasswordInvalid,_that.isConfirmPasswordInvalid,_that.phone,_that.verificationId,_that.email,_that.referral,_that.firstName,_that.lastName,_that.password,_that.confirmPassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSuccess,  bool showPassword,  bool showConfirmPassword,  bool isEmailInvalid,  bool isPasswordInvalid,  bool isConfirmPasswordInvalid,  String phone,  String verificationId,  String email,  String referral,  String firstName,  String lastName,  String password,  String confirmPassword)?  $default,) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.isLoading,_that.isSuccess,_that.showPassword,_that.showConfirmPassword,_that.isEmailInvalid,_that.isPasswordInvalid,_that.isConfirmPasswordInvalid,_that.phone,_that.verificationId,_that.email,_that.referral,_that.firstName,_that.lastName,_that.password,_that.confirmPassword);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterState extends RegisterState {
  const _RegisterState({this.isLoading = false, this.isSuccess = false, this.showPassword = false, this.showConfirmPassword = false, this.isEmailInvalid = false, this.isPasswordInvalid = false, this.isConfirmPasswordInvalid = false, this.phone = '', this.verificationId = '', this.email = '', this.referral = '', this.firstName = '', this.lastName = '', this.password = '', this.confirmPassword = ''}): super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSuccess;
@override@JsonKey() final  bool showPassword;
@override@JsonKey() final  bool showConfirmPassword;
@override@JsonKey() final  bool isEmailInvalid;
@override@JsonKey() final  bool isPasswordInvalid;
@override@JsonKey() final  bool isConfirmPasswordInvalid;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String verificationId;
@override@JsonKey() final  String email;
@override@JsonKey() final  String referral;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override@JsonKey() final  String password;
@override@JsonKey() final  String confirmPassword;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateCopyWith<_RegisterState> get copyWith => __$RegisterStateCopyWithImpl<_RegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.showPassword, showPassword) || other.showPassword == showPassword)&&(identical(other.showConfirmPassword, showConfirmPassword) || other.showConfirmPassword == showConfirmPassword)&&(identical(other.isEmailInvalid, isEmailInvalid) || other.isEmailInvalid == isEmailInvalid)&&(identical(other.isPasswordInvalid, isPasswordInvalid) || other.isPasswordInvalid == isPasswordInvalid)&&(identical(other.isConfirmPasswordInvalid, isConfirmPasswordInvalid) || other.isConfirmPasswordInvalid == isConfirmPasswordInvalid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.email, email) || other.email == email)&&(identical(other.referral, referral) || other.referral == referral)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSuccess,showPassword,showConfirmPassword,isEmailInvalid,isPasswordInvalid,isConfirmPasswordInvalid,phone,verificationId,email,referral,firstName,lastName,password,confirmPassword);

@override
String toString() {
  return 'RegisterState(isLoading: $isLoading, isSuccess: $isSuccess, showPassword: $showPassword, showConfirmPassword: $showConfirmPassword, isEmailInvalid: $isEmailInvalid, isPasswordInvalid: $isPasswordInvalid, isConfirmPasswordInvalid: $isConfirmPasswordInvalid, phone: $phone, verificationId: $verificationId, email: $email, referral: $referral, firstName: $firstName, lastName: $lastName, password: $password, confirmPassword: $confirmPassword)';
}


}

/// @nodoc
abstract mixin class _$RegisterStateCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$RegisterStateCopyWith(_RegisterState value, $Res Function(_RegisterState) _then) = __$RegisterStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSuccess, bool showPassword, bool showConfirmPassword, bool isEmailInvalid, bool isPasswordInvalid, bool isConfirmPasswordInvalid, String phone, String verificationId, String email, String referral, String firstName, String lastName, String password, String confirmPassword
});




}
/// @nodoc
class __$RegisterStateCopyWithImpl<$Res>
    implements _$RegisterStateCopyWith<$Res> {
  __$RegisterStateCopyWithImpl(this._self, this._then);

  final _RegisterState _self;
  final $Res Function(_RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSuccess = null,Object? showPassword = null,Object? showConfirmPassword = null,Object? isEmailInvalid = null,Object? isPasswordInvalid = null,Object? isConfirmPasswordInvalid = null,Object? phone = null,Object? verificationId = null,Object? email = null,Object? referral = null,Object? firstName = null,Object? lastName = null,Object? password = null,Object? confirmPassword = null,}) {
  return _then(_RegisterState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,showPassword: null == showPassword ? _self.showPassword : showPassword // ignore: cast_nullable_to_non_nullable
as bool,showConfirmPassword: null == showConfirmPassword ? _self.showConfirmPassword : showConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,isEmailInvalid: null == isEmailInvalid ? _self.isEmailInvalid : isEmailInvalid // ignore: cast_nullable_to_non_nullable
as bool,isPasswordInvalid: null == isPasswordInvalid ? _self.isPasswordInvalid : isPasswordInvalid // ignore: cast_nullable_to_non_nullable
as bool,isConfirmPasswordInvalid: null == isConfirmPasswordInvalid ? _self.isConfirmPasswordInvalid : isConfirmPasswordInvalid // ignore: cast_nullable_to_non_nullable
as bool,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,verificationId: null == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,referral: null == referral ? _self.referral : referral // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
