// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_order_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AutoOrderState {

 DateTime get from; DateTime get to; TimeOfDay? get time; dynamic get isError;
/// Create a copy of AutoOrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutoOrderStateCopyWith<AutoOrderState> get copyWith => _$AutoOrderStateCopyWithImpl<AutoOrderState>(this as AutoOrderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoOrderState&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.isError, isError));
}


@override
int get hashCode => Object.hash(runtimeType,from,to,time,const DeepCollectionEquality().hash(isError));

@override
String toString() {
  return 'AutoOrderState(from: $from, to: $to, time: $time, isError: $isError)';
}


}

/// @nodoc
abstract mixin class $AutoOrderStateCopyWith<$Res>  {
  factory $AutoOrderStateCopyWith(AutoOrderState value, $Res Function(AutoOrderState) _then) = _$AutoOrderStateCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to, TimeOfDay? time, dynamic isError
});




}
/// @nodoc
class _$AutoOrderStateCopyWithImpl<$Res>
    implements $AutoOrderStateCopyWith<$Res> {
  _$AutoOrderStateCopyWithImpl(this._self, this._then);

  final AutoOrderState _self;
  final $Res Function(AutoOrderState) _then;

/// Create a copy of AutoOrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? time = freezed,Object? isError = freezed,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,isError: freezed == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [AutoOrderState].
extension AutoOrderStatePatterns on AutoOrderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutoOrderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutoOrderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutoOrderState value)  $default,){
final _that = this;
switch (_that) {
case _AutoOrderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutoOrderState value)?  $default,){
final _that = this;
switch (_that) {
case _AutoOrderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  TimeOfDay? time,  dynamic isError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutoOrderState() when $default != null:
return $default(_that.from,_that.to,_that.time,_that.isError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  TimeOfDay? time,  dynamic isError)  $default,) {final _that = this;
switch (_that) {
case _AutoOrderState():
return $default(_that.from,_that.to,_that.time,_that.isError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to,  TimeOfDay? time,  dynamic isError)?  $default,) {final _that = this;
switch (_that) {
case _AutoOrderState() when $default != null:
return $default(_that.from,_that.to,_that.time,_that.isError);case _:
  return null;

}
}

}

/// @nodoc


class _AutoOrderState extends AutoOrderState {
  const _AutoOrderState({required this.from, required this.to, this.time, this.isError = false}): super._();
  

@override final  DateTime from;
@override final  DateTime to;
@override final  TimeOfDay? time;
@override@JsonKey() final  dynamic isError;

/// Create a copy of AutoOrderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutoOrderStateCopyWith<_AutoOrderState> get copyWith => __$AutoOrderStateCopyWithImpl<_AutoOrderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutoOrderState&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.isError, isError));
}


@override
int get hashCode => Object.hash(runtimeType,from,to,time,const DeepCollectionEquality().hash(isError));

@override
String toString() {
  return 'AutoOrderState(from: $from, to: $to, time: $time, isError: $isError)';
}


}

/// @nodoc
abstract mixin class _$AutoOrderStateCopyWith<$Res> implements $AutoOrderStateCopyWith<$Res> {
  factory _$AutoOrderStateCopyWith(_AutoOrderState value, $Res Function(_AutoOrderState) _then) = __$AutoOrderStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to, TimeOfDay? time, dynamic isError
});




}
/// @nodoc
class __$AutoOrderStateCopyWithImpl<$Res>
    implements _$AutoOrderStateCopyWith<$Res> {
  __$AutoOrderStateCopyWithImpl(this._self, this._then);

  final _AutoOrderState _self;
  final $Res Function(_AutoOrderState) _then;

/// Create a copy of AutoOrderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? time = freezed,Object? isError = freezed,}) {
  return _then(_AutoOrderState(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,isError: freezed == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
