// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_card_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddCardState {

 bool get isActiveCard; String get cardNumber; String get cardName; String get date; String get cvc;
/// Create a copy of AddCardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddCardStateCopyWith<AddCardState> get copyWith => _$AddCardStateCopyWithImpl<AddCardState>(this as AddCardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCardState&&(identical(other.isActiveCard, isActiveCard) || other.isActiveCard == isActiveCard)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardName, cardName) || other.cardName == cardName)&&(identical(other.date, date) || other.date == date)&&(identical(other.cvc, cvc) || other.cvc == cvc));
}


@override
int get hashCode => Object.hash(runtimeType,isActiveCard,cardNumber,cardName,date,cvc);

@override
String toString() {
  return 'AddCardState(isActiveCard: $isActiveCard, cardNumber: $cardNumber, cardName: $cardName, date: $date, cvc: $cvc)';
}


}

/// @nodoc
abstract mixin class $AddCardStateCopyWith<$Res>  {
  factory $AddCardStateCopyWith(AddCardState value, $Res Function(AddCardState) _then) = _$AddCardStateCopyWithImpl;
@useResult
$Res call({
 bool isActiveCard, String cardNumber, String cardName, String date, String cvc
});




}
/// @nodoc
class _$AddCardStateCopyWithImpl<$Res>
    implements $AddCardStateCopyWith<$Res> {
  _$AddCardStateCopyWithImpl(this._self, this._then);

  final AddCardState _self;
  final $Res Function(AddCardState) _then;

/// Create a copy of AddCardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isActiveCard = null,Object? cardNumber = null,Object? cardName = null,Object? date = null,Object? cvc = null,}) {
  return _then(_self.copyWith(
isActiveCard: null == isActiveCard ? _self.isActiveCard : isActiveCard // ignore: cast_nullable_to_non_nullable
as bool,cardNumber: null == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String,cardName: null == cardName ? _self.cardName : cardName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,cvc: null == cvc ? _self.cvc : cvc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AddCardState].
extension AddCardStatePatterns on AddCardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddCardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddCardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddCardState value)  $default,){
final _that = this;
switch (_that) {
case _AddCardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddCardState value)?  $default,){
final _that = this;
switch (_that) {
case _AddCardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isActiveCard,  String cardNumber,  String cardName,  String date,  String cvc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddCardState() when $default != null:
return $default(_that.isActiveCard,_that.cardNumber,_that.cardName,_that.date,_that.cvc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isActiveCard,  String cardNumber,  String cardName,  String date,  String cvc)  $default,) {final _that = this;
switch (_that) {
case _AddCardState():
return $default(_that.isActiveCard,_that.cardNumber,_that.cardName,_that.date,_that.cvc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isActiveCard,  String cardNumber,  String cardName,  String date,  String cvc)?  $default,) {final _that = this;
switch (_that) {
case _AddCardState() when $default != null:
return $default(_that.isActiveCard,_that.cardNumber,_that.cardName,_that.date,_that.cvc);case _:
  return null;

}
}

}

/// @nodoc


class _AddCardState extends AddCardState {
  const _AddCardState({this.isActiveCard = false, this.cardNumber = "0000 0000 0000 0000", this.cardName = "", this.date = "", this.cvc = ""}): super._();
  

@override@JsonKey() final  bool isActiveCard;
@override@JsonKey() final  String cardNumber;
@override@JsonKey() final  String cardName;
@override@JsonKey() final  String date;
@override@JsonKey() final  String cvc;

/// Create a copy of AddCardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddCardStateCopyWith<_AddCardState> get copyWith => __$AddCardStateCopyWithImpl<_AddCardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddCardState&&(identical(other.isActiveCard, isActiveCard) || other.isActiveCard == isActiveCard)&&(identical(other.cardNumber, cardNumber) || other.cardNumber == cardNumber)&&(identical(other.cardName, cardName) || other.cardName == cardName)&&(identical(other.date, date) || other.date == date)&&(identical(other.cvc, cvc) || other.cvc == cvc));
}


@override
int get hashCode => Object.hash(runtimeType,isActiveCard,cardNumber,cardName,date,cvc);

@override
String toString() {
  return 'AddCardState(isActiveCard: $isActiveCard, cardNumber: $cardNumber, cardName: $cardName, date: $date, cvc: $cvc)';
}


}

/// @nodoc
abstract mixin class _$AddCardStateCopyWith<$Res> implements $AddCardStateCopyWith<$Res> {
  factory _$AddCardStateCopyWith(_AddCardState value, $Res Function(_AddCardState) _then) = __$AddCardStateCopyWithImpl;
@override @useResult
$Res call({
 bool isActiveCard, String cardNumber, String cardName, String date, String cvc
});




}
/// @nodoc
class __$AddCardStateCopyWithImpl<$Res>
    implements _$AddCardStateCopyWith<$Res> {
  __$AddCardStateCopyWithImpl(this._self, this._then);

  final _AddCardState _self;
  final $Res Function(_AddCardState) _then;

/// Create a copy of AddCardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isActiveCard = null,Object? cardNumber = null,Object? cardName = null,Object? date = null,Object? cvc = null,}) {
  return _then(_AddCardState(
isActiveCard: null == isActiveCard ? _self.isActiveCard : isActiveCard // ignore: cast_nullable_to_non_nullable
as bool,cardNumber: null == cardNumber ? _self.cardNumber : cardNumber // ignore: cast_nullable_to_non_nullable
as String,cardName: null == cardName ? _self.cardName : cardName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,cvc: null == cvc ? _self.cvc : cvc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
