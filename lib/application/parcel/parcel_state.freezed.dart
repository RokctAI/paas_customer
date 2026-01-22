// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParcelState {

 bool get isLoading; bool get isButtonLoading; bool get isMapLoading; bool get error; LocationModel? get locationFrom; LocationModel? get locationTo; String? get addressTo; String? get addressFrom; TimeOfDay? get time; ParcelCalculateResponse? get calculate; List<TypeModel?> get types; int get selectType; bool get expand; bool get anonymous; ParcelOrder? get parcel; PaymentData? get selectPayment; Map<MarkerId, Marker> get markers; List<LatLng> get polylineCoordinates;
/// Create a copy of ParcelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParcelStateCopyWith<ParcelState> get copyWith => _$ParcelStateCopyWithImpl<ParcelState>(this as ParcelState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParcelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isButtonLoading, isButtonLoading) || other.isButtonLoading == isButtonLoading)&&(identical(other.isMapLoading, isMapLoading) || other.isMapLoading == isMapLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.locationFrom, locationFrom) || other.locationFrom == locationFrom)&&(identical(other.locationTo, locationTo) || other.locationTo == locationTo)&&(identical(other.addressTo, addressTo) || other.addressTo == addressTo)&&(identical(other.addressFrom, addressFrom) || other.addressFrom == addressFrom)&&(identical(other.time, time) || other.time == time)&&(identical(other.calculate, calculate) || other.calculate == calculate)&&const DeepCollectionEquality().equals(other.types, types)&&(identical(other.selectType, selectType) || other.selectType == selectType)&&(identical(other.expand, expand) || other.expand == expand)&&(identical(other.anonymous, anonymous) || other.anonymous == anonymous)&&(identical(other.parcel, parcel) || other.parcel == parcel)&&(identical(other.selectPayment, selectPayment) || other.selectPayment == selectPayment)&&const DeepCollectionEquality().equals(other.markers, markers)&&const DeepCollectionEquality().equals(other.polylineCoordinates, polylineCoordinates));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isButtonLoading,isMapLoading,error,locationFrom,locationTo,addressTo,addressFrom,time,calculate,const DeepCollectionEquality().hash(types),selectType,expand,anonymous,parcel,selectPayment,const DeepCollectionEquality().hash(markers),const DeepCollectionEquality().hash(polylineCoordinates));

@override
String toString() {
  return 'ParcelState(isLoading: $isLoading, isButtonLoading: $isButtonLoading, isMapLoading: $isMapLoading, error: $error, locationFrom: $locationFrom, locationTo: $locationTo, addressTo: $addressTo, addressFrom: $addressFrom, time: $time, calculate: $calculate, types: $types, selectType: $selectType, expand: $expand, anonymous: $anonymous, parcel: $parcel, selectPayment: $selectPayment, markers: $markers, polylineCoordinates: $polylineCoordinates)';
}


}

/// @nodoc
abstract mixin class $ParcelStateCopyWith<$Res>  {
  factory $ParcelStateCopyWith(ParcelState value, $Res Function(ParcelState) _then) = _$ParcelStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isButtonLoading, bool isMapLoading, bool error, LocationModel? locationFrom, LocationModel? locationTo, String? addressTo, String? addressFrom, TimeOfDay? time, ParcelCalculateResponse? calculate, List<TypeModel?> types, int selectType, bool expand, bool anonymous, ParcelOrder? parcel, PaymentData? selectPayment, Map<MarkerId, Marker> markers, List<LatLng> polylineCoordinates
});




}
/// @nodoc
class _$ParcelStateCopyWithImpl<$Res>
    implements $ParcelStateCopyWith<$Res> {
  _$ParcelStateCopyWithImpl(this._self, this._then);

  final ParcelState _self;
  final $Res Function(ParcelState) _then;

/// Create a copy of ParcelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isButtonLoading = null,Object? isMapLoading = null,Object? error = null,Object? locationFrom = freezed,Object? locationTo = freezed,Object? addressTo = freezed,Object? addressFrom = freezed,Object? time = freezed,Object? calculate = freezed,Object? types = null,Object? selectType = null,Object? expand = null,Object? anonymous = null,Object? parcel = freezed,Object? selectPayment = freezed,Object? markers = null,Object? polylineCoordinates = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isButtonLoading: null == isButtonLoading ? _self.isButtonLoading : isButtonLoading // ignore: cast_nullable_to_non_nullable
as bool,isMapLoading: null == isMapLoading ? _self.isMapLoading : isMapLoading // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,locationFrom: freezed == locationFrom ? _self.locationFrom : locationFrom // ignore: cast_nullable_to_non_nullable
as LocationModel?,locationTo: freezed == locationTo ? _self.locationTo : locationTo // ignore: cast_nullable_to_non_nullable
as LocationModel?,addressTo: freezed == addressTo ? _self.addressTo : addressTo // ignore: cast_nullable_to_non_nullable
as String?,addressFrom: freezed == addressFrom ? _self.addressFrom : addressFrom // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,calculate: freezed == calculate ? _self.calculate : calculate // ignore: cast_nullable_to_non_nullable
as ParcelCalculateResponse?,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as List<TypeModel?>,selectType: null == selectType ? _self.selectType : selectType // ignore: cast_nullable_to_non_nullable
as int,expand: null == expand ? _self.expand : expand // ignore: cast_nullable_to_non_nullable
as bool,anonymous: null == anonymous ? _self.anonymous : anonymous // ignore: cast_nullable_to_non_nullable
as bool,parcel: freezed == parcel ? _self.parcel : parcel // ignore: cast_nullable_to_non_nullable
as ParcelOrder?,selectPayment: freezed == selectPayment ? _self.selectPayment : selectPayment // ignore: cast_nullable_to_non_nullable
as PaymentData?,markers: null == markers ? _self.markers : markers // ignore: cast_nullable_to_non_nullable
as Map<MarkerId, Marker>,polylineCoordinates: null == polylineCoordinates ? _self.polylineCoordinates : polylineCoordinates // ignore: cast_nullable_to_non_nullable
as List<LatLng>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParcelState].
extension ParcelStatePatterns on ParcelState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParcelState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParcelState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParcelState value)  $default,){
final _that = this;
switch (_that) {
case _ParcelState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParcelState value)?  $default,){
final _that = this;
switch (_that) {
case _ParcelState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isButtonLoading,  bool isMapLoading,  bool error,  LocationModel? locationFrom,  LocationModel? locationTo,  String? addressTo,  String? addressFrom,  TimeOfDay? time,  ParcelCalculateResponse? calculate,  List<TypeModel?> types,  int selectType,  bool expand,  bool anonymous,  ParcelOrder? parcel,  PaymentData? selectPayment,  Map<MarkerId, Marker> markers,  List<LatLng> polylineCoordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParcelState() when $default != null:
return $default(_that.isLoading,_that.isButtonLoading,_that.isMapLoading,_that.error,_that.locationFrom,_that.locationTo,_that.addressTo,_that.addressFrom,_that.time,_that.calculate,_that.types,_that.selectType,_that.expand,_that.anonymous,_that.parcel,_that.selectPayment,_that.markers,_that.polylineCoordinates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isButtonLoading,  bool isMapLoading,  bool error,  LocationModel? locationFrom,  LocationModel? locationTo,  String? addressTo,  String? addressFrom,  TimeOfDay? time,  ParcelCalculateResponse? calculate,  List<TypeModel?> types,  int selectType,  bool expand,  bool anonymous,  ParcelOrder? parcel,  PaymentData? selectPayment,  Map<MarkerId, Marker> markers,  List<LatLng> polylineCoordinates)  $default,) {final _that = this;
switch (_that) {
case _ParcelState():
return $default(_that.isLoading,_that.isButtonLoading,_that.isMapLoading,_that.error,_that.locationFrom,_that.locationTo,_that.addressTo,_that.addressFrom,_that.time,_that.calculate,_that.types,_that.selectType,_that.expand,_that.anonymous,_that.parcel,_that.selectPayment,_that.markers,_that.polylineCoordinates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isButtonLoading,  bool isMapLoading,  bool error,  LocationModel? locationFrom,  LocationModel? locationTo,  String? addressTo,  String? addressFrom,  TimeOfDay? time,  ParcelCalculateResponse? calculate,  List<TypeModel?> types,  int selectType,  bool expand,  bool anonymous,  ParcelOrder? parcel,  PaymentData? selectPayment,  Map<MarkerId, Marker> markers,  List<LatLng> polylineCoordinates)?  $default,) {final _that = this;
switch (_that) {
case _ParcelState() when $default != null:
return $default(_that.isLoading,_that.isButtonLoading,_that.isMapLoading,_that.error,_that.locationFrom,_that.locationTo,_that.addressTo,_that.addressFrom,_that.time,_that.calculate,_that.types,_that.selectType,_that.expand,_that.anonymous,_that.parcel,_that.selectPayment,_that.markers,_that.polylineCoordinates);case _:
  return null;

}
}

}

/// @nodoc


class _ParcelState extends ParcelState {
  const _ParcelState({this.isLoading = false, this.isButtonLoading = false, this.isMapLoading = false, this.error = false, this.locationFrom = null, this.locationTo = null, this.addressTo = null, this.addressFrom = null, this.time = null, this.calculate = null, final  List<TypeModel?> types = const [], this.selectType = 0, this.expand = false, this.anonymous = false, this.parcel = null, this.selectPayment = null, final  Map<MarkerId, Marker> markers = const {}, final  List<LatLng> polylineCoordinates = const []}): _types = types,_markers = markers,_polylineCoordinates = polylineCoordinates,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isButtonLoading;
@override@JsonKey() final  bool isMapLoading;
@override@JsonKey() final  bool error;
@override@JsonKey() final  LocationModel? locationFrom;
@override@JsonKey() final  LocationModel? locationTo;
@override@JsonKey() final  String? addressTo;
@override@JsonKey() final  String? addressFrom;
@override@JsonKey() final  TimeOfDay? time;
@override@JsonKey() final  ParcelCalculateResponse? calculate;
 final  List<TypeModel?> _types;
@override@JsonKey() List<TypeModel?> get types {
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_types);
}

@override@JsonKey() final  int selectType;
@override@JsonKey() final  bool expand;
@override@JsonKey() final  bool anonymous;
@override@JsonKey() final  ParcelOrder? parcel;
@override@JsonKey() final  PaymentData? selectPayment;
 final  Map<MarkerId, Marker> _markers;
@override@JsonKey() Map<MarkerId, Marker> get markers {
  if (_markers is EqualUnmodifiableMapView) return _markers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_markers);
}

 final  List<LatLng> _polylineCoordinates;
@override@JsonKey() List<LatLng> get polylineCoordinates {
  if (_polylineCoordinates is EqualUnmodifiableListView) return _polylineCoordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polylineCoordinates);
}


/// Create a copy of ParcelState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParcelStateCopyWith<_ParcelState> get copyWith => __$ParcelStateCopyWithImpl<_ParcelState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParcelState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isButtonLoading, isButtonLoading) || other.isButtonLoading == isButtonLoading)&&(identical(other.isMapLoading, isMapLoading) || other.isMapLoading == isMapLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.locationFrom, locationFrom) || other.locationFrom == locationFrom)&&(identical(other.locationTo, locationTo) || other.locationTo == locationTo)&&(identical(other.addressTo, addressTo) || other.addressTo == addressTo)&&(identical(other.addressFrom, addressFrom) || other.addressFrom == addressFrom)&&(identical(other.time, time) || other.time == time)&&(identical(other.calculate, calculate) || other.calculate == calculate)&&const DeepCollectionEquality().equals(other._types, _types)&&(identical(other.selectType, selectType) || other.selectType == selectType)&&(identical(other.expand, expand) || other.expand == expand)&&(identical(other.anonymous, anonymous) || other.anonymous == anonymous)&&(identical(other.parcel, parcel) || other.parcel == parcel)&&(identical(other.selectPayment, selectPayment) || other.selectPayment == selectPayment)&&const DeepCollectionEquality().equals(other._markers, _markers)&&const DeepCollectionEquality().equals(other._polylineCoordinates, _polylineCoordinates));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isButtonLoading,isMapLoading,error,locationFrom,locationTo,addressTo,addressFrom,time,calculate,const DeepCollectionEquality().hash(_types),selectType,expand,anonymous,parcel,selectPayment,const DeepCollectionEquality().hash(_markers),const DeepCollectionEquality().hash(_polylineCoordinates));

@override
String toString() {
  return 'ParcelState(isLoading: $isLoading, isButtonLoading: $isButtonLoading, isMapLoading: $isMapLoading, error: $error, locationFrom: $locationFrom, locationTo: $locationTo, addressTo: $addressTo, addressFrom: $addressFrom, time: $time, calculate: $calculate, types: $types, selectType: $selectType, expand: $expand, anonymous: $anonymous, parcel: $parcel, selectPayment: $selectPayment, markers: $markers, polylineCoordinates: $polylineCoordinates)';
}


}

/// @nodoc
abstract mixin class _$ParcelStateCopyWith<$Res> implements $ParcelStateCopyWith<$Res> {
  factory _$ParcelStateCopyWith(_ParcelState value, $Res Function(_ParcelState) _then) = __$ParcelStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isButtonLoading, bool isMapLoading, bool error, LocationModel? locationFrom, LocationModel? locationTo, String? addressTo, String? addressFrom, TimeOfDay? time, ParcelCalculateResponse? calculate, List<TypeModel?> types, int selectType, bool expand, bool anonymous, ParcelOrder? parcel, PaymentData? selectPayment, Map<MarkerId, Marker> markers, List<LatLng> polylineCoordinates
});




}
/// @nodoc
class __$ParcelStateCopyWithImpl<$Res>
    implements _$ParcelStateCopyWith<$Res> {
  __$ParcelStateCopyWithImpl(this._self, this._then);

  final _ParcelState _self;
  final $Res Function(_ParcelState) _then;

/// Create a copy of ParcelState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isButtonLoading = null,Object? isMapLoading = null,Object? error = null,Object? locationFrom = freezed,Object? locationTo = freezed,Object? addressTo = freezed,Object? addressFrom = freezed,Object? time = freezed,Object? calculate = freezed,Object? types = null,Object? selectType = null,Object? expand = null,Object? anonymous = null,Object? parcel = freezed,Object? selectPayment = freezed,Object? markers = null,Object? polylineCoordinates = null,}) {
  return _then(_ParcelState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isButtonLoading: null == isButtonLoading ? _self.isButtonLoading : isButtonLoading // ignore: cast_nullable_to_non_nullable
as bool,isMapLoading: null == isMapLoading ? _self.isMapLoading : isMapLoading // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool,locationFrom: freezed == locationFrom ? _self.locationFrom : locationFrom // ignore: cast_nullable_to_non_nullable
as LocationModel?,locationTo: freezed == locationTo ? _self.locationTo : locationTo // ignore: cast_nullable_to_non_nullable
as LocationModel?,addressTo: freezed == addressTo ? _self.addressTo : addressTo // ignore: cast_nullable_to_non_nullable
as String?,addressFrom: freezed == addressFrom ? _self.addressFrom : addressFrom // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,calculate: freezed == calculate ? _self.calculate : calculate // ignore: cast_nullable_to_non_nullable
as ParcelCalculateResponse?,types: null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<TypeModel?>,selectType: null == selectType ? _self.selectType : selectType // ignore: cast_nullable_to_non_nullable
as int,expand: null == expand ? _self.expand : expand // ignore: cast_nullable_to_non_nullable
as bool,anonymous: null == anonymous ? _self.anonymous : anonymous // ignore: cast_nullable_to_non_nullable
as bool,parcel: freezed == parcel ? _self.parcel : parcel // ignore: cast_nullable_to_non_nullable
as ParcelOrder?,selectPayment: freezed == selectPayment ? _self.selectPayment : selectPayment // ignore: cast_nullable_to_non_nullable
as PaymentData?,markers: null == markers ? _self._markers : markers // ignore: cast_nullable_to_non_nullable
as Map<MarkerId, Marker>,polylineCoordinates: null == polylineCoordinates ? _self._polylineCoordinates : polylineCoordinates // ignore: cast_nullable_to_non_nullable
as List<LatLng>,
  ));
}


}

// dart format on
