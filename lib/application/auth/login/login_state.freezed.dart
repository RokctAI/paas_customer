// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 bool get isLoading; bool get showPassword; bool get isKeepLogin; bool get isProfileDetailsLoading; bool get isLoginError; bool get isEmailNotValid; bool get isPasswordNotValid; bool get isSelectLanguage; List<LanguageData> get list; String get email; String get phone; String get password; bool get isAgreedToTerms;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showPassword, showPassword) || other.showPassword == showPassword)&&(identical(other.isKeepLogin, isKeepLogin) || other.isKeepLogin == isKeepLogin)&&(identical(other.isProfileDetailsLoading, isProfileDetailsLoading) || other.isProfileDetailsLoading == isProfileDetailsLoading)&&(identical(other.isLoginError, isLoginError) || other.isLoginError == isLoginError)&&(identical(other.isEmailNotValid, isEmailNotValid) || other.isEmailNotValid == isEmailNotValid)&&(identical(other.isPasswordNotValid, isPasswordNotValid) || other.isPasswordNotValid == isPasswordNotValid)&&(identical(other.isSelectLanguage, isSelectLanguage) || other.isSelectLanguage == isSelectLanguage)&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.isAgreedToTerms, isAgreedToTerms) || other.isAgreedToTerms == isAgreedToTerms));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,showPassword,isKeepLogin,isProfileDetailsLoading,isLoginError,isEmailNotValid,isPasswordNotValid,isSelectLanguage,const DeepCollectionEquality().hash(list),email,phone,password,isAgreedToTerms);

@override
String toString() {
  return 'LoginState(isLoading: $isLoading, showPassword: $showPassword, isKeepLogin: $isKeepLogin, isProfileDetailsLoading: $isProfileDetailsLoading, isLoginError: $isLoginError, isEmailNotValid: $isEmailNotValid, isPasswordNotValid: $isPasswordNotValid, isSelectLanguage: $isSelectLanguage, list: $list, email: $email, phone: $phone, password: $password, isAgreedToTerms: $isAgreedToTerms)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool showPassword, bool isKeepLogin, bool isProfileDetailsLoading, bool isLoginError, bool isEmailNotValid, bool isPasswordNotValid, bool isSelectLanguage, List<LanguageData> list, String email, String phone, String password, bool isAgreedToTerms
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? showPassword = null,Object? isKeepLogin = null,Object? isProfileDetailsLoading = null,Object? isLoginError = null,Object? isEmailNotValid = null,Object? isPasswordNotValid = null,Object? isSelectLanguage = null,Object? list = null,Object? email = null,Object? phone = null,Object? password = null,Object? isAgreedToTerms = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showPassword: null == showPassword ? _self.showPassword : showPassword // ignore: cast_nullable_to_non_nullable
as bool,isKeepLogin: null == isKeepLogin ? _self.isKeepLogin : isKeepLogin // ignore: cast_nullable_to_non_nullable
as bool,isProfileDetailsLoading: null == isProfileDetailsLoading ? _self.isProfileDetailsLoading : isProfileDetailsLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoginError: null == isLoginError ? _self.isLoginError : isLoginError // ignore: cast_nullable_to_non_nullable
as bool,isEmailNotValid: null == isEmailNotValid ? _self.isEmailNotValid : isEmailNotValid // ignore: cast_nullable_to_non_nullable
as bool,isPasswordNotValid: null == isPasswordNotValid ? _self.isPasswordNotValid : isPasswordNotValid // ignore: cast_nullable_to_non_nullable
as bool,isSelectLanguage: null == isSelectLanguage ? _self.isSelectLanguage : isSelectLanguage // ignore: cast_nullable_to_non_nullable
as bool,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<LanguageData>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isAgreedToTerms: null == isAgreedToTerms ? _self.isAgreedToTerms : isAgreedToTerms // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool showPassword,  bool isKeepLogin,  bool isProfileDetailsLoading,  bool isLoginError,  bool isEmailNotValid,  bool isPasswordNotValid,  bool isSelectLanguage,  List<LanguageData> list,  String email,  String phone,  String password,  bool isAgreedToTerms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.isLoading,_that.showPassword,_that.isKeepLogin,_that.isProfileDetailsLoading,_that.isLoginError,_that.isEmailNotValid,_that.isPasswordNotValid,_that.isSelectLanguage,_that.list,_that.email,_that.phone,_that.password,_that.isAgreedToTerms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool showPassword,  bool isKeepLogin,  bool isProfileDetailsLoading,  bool isLoginError,  bool isEmailNotValid,  bool isPasswordNotValid,  bool isSelectLanguage,  List<LanguageData> list,  String email,  String phone,  String password,  bool isAgreedToTerms)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.isLoading,_that.showPassword,_that.isKeepLogin,_that.isProfileDetailsLoading,_that.isLoginError,_that.isEmailNotValid,_that.isPasswordNotValid,_that.isSelectLanguage,_that.list,_that.email,_that.phone,_that.password,_that.isAgreedToTerms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool showPassword,  bool isKeepLogin,  bool isProfileDetailsLoading,  bool isLoginError,  bool isEmailNotValid,  bool isPasswordNotValid,  bool isSelectLanguage,  List<LanguageData> list,  String email,  String phone,  String password,  bool isAgreedToTerms)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.isLoading,_that.showPassword,_that.isKeepLogin,_that.isProfileDetailsLoading,_that.isLoginError,_that.isEmailNotValid,_that.isPasswordNotValid,_that.isSelectLanguage,_that.list,_that.email,_that.phone,_that.password,_that.isAgreedToTerms);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState extends LoginState {
  const _LoginState({this.isLoading = false, this.showPassword = false, this.isKeepLogin = false, this.isProfileDetailsLoading = false, this.isLoginError = false, this.isEmailNotValid = false, this.isPasswordNotValid = false, this.isSelectLanguage = true, final  List<LanguageData> list = const [], this.email = '', this.phone = '', this.password = '', this.isAgreedToTerms = false}): _list = list,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool showPassword;
@override@JsonKey() final  bool isKeepLogin;
@override@JsonKey() final  bool isProfileDetailsLoading;
@override@JsonKey() final  bool isLoginError;
@override@JsonKey() final  bool isEmailNotValid;
@override@JsonKey() final  bool isPasswordNotValid;
@override@JsonKey() final  bool isSelectLanguage;
 final  List<LanguageData> _list;
@override@JsonKey() List<LanguageData> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String password;
@override@JsonKey() final  bool isAgreedToTerms;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.showPassword, showPassword) || other.showPassword == showPassword)&&(identical(other.isKeepLogin, isKeepLogin) || other.isKeepLogin == isKeepLogin)&&(identical(other.isProfileDetailsLoading, isProfileDetailsLoading) || other.isProfileDetailsLoading == isProfileDetailsLoading)&&(identical(other.isLoginError, isLoginError) || other.isLoginError == isLoginError)&&(identical(other.isEmailNotValid, isEmailNotValid) || other.isEmailNotValid == isEmailNotValid)&&(identical(other.isPasswordNotValid, isPasswordNotValid) || other.isPasswordNotValid == isPasswordNotValid)&&(identical(other.isSelectLanguage, isSelectLanguage) || other.isSelectLanguage == isSelectLanguage)&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.isAgreedToTerms, isAgreedToTerms) || other.isAgreedToTerms == isAgreedToTerms));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,showPassword,isKeepLogin,isProfileDetailsLoading,isLoginError,isEmailNotValid,isPasswordNotValid,isSelectLanguage,const DeepCollectionEquality().hash(_list),email,phone,password,isAgreedToTerms);

@override
String toString() {
  return 'LoginState(isLoading: $isLoading, showPassword: $showPassword, isKeepLogin: $isKeepLogin, isProfileDetailsLoading: $isProfileDetailsLoading, isLoginError: $isLoginError, isEmailNotValid: $isEmailNotValid, isPasswordNotValid: $isPasswordNotValid, isSelectLanguage: $isSelectLanguage, list: $list, email: $email, phone: $phone, password: $password, isAgreedToTerms: $isAgreedToTerms)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool showPassword, bool isKeepLogin, bool isProfileDetailsLoading, bool isLoginError, bool isEmailNotValid, bool isPasswordNotValid, bool isSelectLanguage, List<LanguageData> list, String email, String phone, String password, bool isAgreedToTerms
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? showPassword = null,Object? isKeepLogin = null,Object? isProfileDetailsLoading = null,Object? isLoginError = null,Object? isEmailNotValid = null,Object? isPasswordNotValid = null,Object? isSelectLanguage = null,Object? list = null,Object? email = null,Object? phone = null,Object? password = null,Object? isAgreedToTerms = null,}) {
  return _then(_LoginState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,showPassword: null == showPassword ? _self.showPassword : showPassword // ignore: cast_nullable_to_non_nullable
as bool,isKeepLogin: null == isKeepLogin ? _self.isKeepLogin : isKeepLogin // ignore: cast_nullable_to_non_nullable
as bool,isProfileDetailsLoading: null == isProfileDetailsLoading ? _self.isProfileDetailsLoading : isProfileDetailsLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoginError: null == isLoginError ? _self.isLoginError : isLoginError // ignore: cast_nullable_to_non_nullable
as bool,isEmailNotValid: null == isEmailNotValid ? _self.isEmailNotValid : isEmailNotValid // ignore: cast_nullable_to_non_nullable
as bool,isPasswordNotValid: null == isPasswordNotValid ? _self.isPasswordNotValid : isPasswordNotValid // ignore: cast_nullable_to_non_nullable
as bool,isSelectLanguage: null == isSelectLanguage ? _self.isSelectLanguage : isSelectLanguage // ignore: cast_nullable_to_non_nullable
as bool,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<LanguageData>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isAgreedToTerms: null == isAgreedToTerms ? _self.isAgreedToTerms : isAgreedToTerms // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
