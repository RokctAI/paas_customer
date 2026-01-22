// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimeState {

 int get currentIndexOne; int get currentIndexTwo; int? get selectIndex;
/// Create a copy of TimeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeStateCopyWith<TimeState> get copyWith => _$TimeStateCopyWithImpl<TimeState>(this as TimeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeState&&(identical(other.currentIndexOne, currentIndexOne) || other.currentIndexOne == currentIndexOne)&&(identical(other.currentIndexTwo, currentIndexTwo) || other.currentIndexTwo == currentIndexTwo)&&(identical(other.selectIndex, selectIndex) || other.selectIndex == selectIndex));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndexOne,currentIndexTwo,selectIndex);

@override
String toString() {
  return 'TimeState(currentIndexOne: $currentIndexOne, currentIndexTwo: $currentIndexTwo, selectIndex: $selectIndex)';
}


}

/// @nodoc
abstract mixin class $TimeStateCopyWith<$Res>  {
  factory $TimeStateCopyWith(TimeState value, $Res Function(TimeState) _then) = _$TimeStateCopyWithImpl;
@useResult
$Res call({
 int currentIndexOne, int currentIndexTwo, int? selectIndex
});




}
/// @nodoc
class _$TimeStateCopyWithImpl<$Res>
    implements $TimeStateCopyWith<$Res> {
  _$TimeStateCopyWithImpl(this._self, this._then);

  final TimeState _self;
  final $Res Function(TimeState) _then;

/// Create a copy of TimeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentIndexOne = null,Object? currentIndexTwo = null,Object? selectIndex = freezed,}) {
  return _then(_self.copyWith(
currentIndexOne: null == currentIndexOne ? _self.currentIndexOne : currentIndexOne // ignore: cast_nullable_to_non_nullable
as int,currentIndexTwo: null == currentIndexTwo ? _self.currentIndexTwo : currentIndexTwo // ignore: cast_nullable_to_non_nullable
as int,selectIndex: freezed == selectIndex ? _self.selectIndex : selectIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeState].
extension TimeStatePatterns on TimeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeState value)  $default,){
final _that = this;
switch (_that) {
case _TimeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeState value)?  $default,){
final _that = this;
switch (_that) {
case _TimeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentIndexOne,  int currentIndexTwo,  int? selectIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeState() when $default != null:
return $default(_that.currentIndexOne,_that.currentIndexTwo,_that.selectIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentIndexOne,  int currentIndexTwo,  int? selectIndex)  $default,) {final _that = this;
switch (_that) {
case _TimeState():
return $default(_that.currentIndexOne,_that.currentIndexTwo,_that.selectIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentIndexOne,  int currentIndexTwo,  int? selectIndex)?  $default,) {final _that = this;
switch (_that) {
case _TimeState() when $default != null:
return $default(_that.currentIndexOne,_that.currentIndexTwo,_that.selectIndex);case _:
  return null;

}
}

}

/// @nodoc


class _TimeState extends TimeState {
  const _TimeState({this.currentIndexOne = 0, this.currentIndexTwo = 0, this.selectIndex = null}): super._();
  

@override@JsonKey() final  int currentIndexOne;
@override@JsonKey() final  int currentIndexTwo;
@override@JsonKey() final  int? selectIndex;

/// Create a copy of TimeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeStateCopyWith<_TimeState> get copyWith => __$TimeStateCopyWithImpl<_TimeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeState&&(identical(other.currentIndexOne, currentIndexOne) || other.currentIndexOne == currentIndexOne)&&(identical(other.currentIndexTwo, currentIndexTwo) || other.currentIndexTwo == currentIndexTwo)&&(identical(other.selectIndex, selectIndex) || other.selectIndex == selectIndex));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndexOne,currentIndexTwo,selectIndex);

@override
String toString() {
  return 'TimeState(currentIndexOne: $currentIndexOne, currentIndexTwo: $currentIndexTwo, selectIndex: $selectIndex)';
}


}

/// @nodoc
abstract mixin class _$TimeStateCopyWith<$Res> implements $TimeStateCopyWith<$Res> {
  factory _$TimeStateCopyWith(_TimeState value, $Res Function(_TimeState) _then) = __$TimeStateCopyWithImpl;
@override @useResult
$Res call({
 int currentIndexOne, int currentIndexTwo, int? selectIndex
});




}
/// @nodoc
class __$TimeStateCopyWithImpl<$Res>
    implements _$TimeStateCopyWith<$Res> {
  __$TimeStateCopyWithImpl(this._self, this._then);

  final _TimeState _self;
  final $Res Function(_TimeState) _then;

/// Create a copy of TimeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentIndexOne = null,Object? currentIndexTwo = null,Object? selectIndex = freezed,}) {
  return _then(_TimeState(
currentIndexOne: null == currentIndexOne ? _self.currentIndexOne : currentIndexOne // ignore: cast_nullable_to_non_nullable
as int,currentIndexTwo: null == currentIndexTwo ? _self.currentIndexTwo : currentIndexTwo // ignore: cast_nullable_to_non_nullable
as int,selectIndex: freezed == selectIndex ? _self.selectIndex : selectIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
