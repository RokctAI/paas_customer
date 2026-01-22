// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FilterState {

 FilterModel? get filterModel; bool get freeDelivery; bool get deals; bool get open; int get shopCount; double get endPrice; double get startPrice; bool get isLoading; bool get isTagLoading; bool get isShopLoading; bool get isRestaurantLoading; RangeValues get rangeValues; List<ShopData> get shops; List<TakeModel> get tags; List<int> get prices; List<ShopData> get restaurant;
/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterStateCopyWith<FilterState> get copyWith => _$FilterStateCopyWithImpl<FilterState>(this as FilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterState&&(identical(other.filterModel, filterModel) || other.filterModel == filterModel)&&(identical(other.freeDelivery, freeDelivery) || other.freeDelivery == freeDelivery)&&(identical(other.deals, deals) || other.deals == deals)&&(identical(other.open, open) || other.open == open)&&(identical(other.shopCount, shopCount) || other.shopCount == shopCount)&&(identical(other.endPrice, endPrice) || other.endPrice == endPrice)&&(identical(other.startPrice, startPrice) || other.startPrice == startPrice)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isTagLoading, isTagLoading) || other.isTagLoading == isTagLoading)&&(identical(other.isShopLoading, isShopLoading) || other.isShopLoading == isShopLoading)&&(identical(other.isRestaurantLoading, isRestaurantLoading) || other.isRestaurantLoading == isRestaurantLoading)&&(identical(other.rangeValues, rangeValues) || other.rangeValues == rangeValues)&&const DeepCollectionEquality().equals(other.shops, shops)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.prices, prices)&&const DeepCollectionEquality().equals(other.restaurant, restaurant));
}


@override
int get hashCode => Object.hash(runtimeType,filterModel,freeDelivery,deals,open,shopCount,endPrice,startPrice,isLoading,isTagLoading,isShopLoading,isRestaurantLoading,rangeValues,const DeepCollectionEquality().hash(shops),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(prices),const DeepCollectionEquality().hash(restaurant));

@override
String toString() {
  return 'FilterState(filterModel: $filterModel, freeDelivery: $freeDelivery, deals: $deals, open: $open, shopCount: $shopCount, endPrice: $endPrice, startPrice: $startPrice, isLoading: $isLoading, isTagLoading: $isTagLoading, isShopLoading: $isShopLoading, isRestaurantLoading: $isRestaurantLoading, rangeValues: $rangeValues, shops: $shops, tags: $tags, prices: $prices, restaurant: $restaurant)';
}


}

/// @nodoc
abstract mixin class $FilterStateCopyWith<$Res>  {
  factory $FilterStateCopyWith(FilterState value, $Res Function(FilterState) _then) = _$FilterStateCopyWithImpl;
@useResult
$Res call({
 FilterModel? filterModel, bool freeDelivery, bool deals, bool open, int shopCount, double endPrice, double startPrice, bool isLoading, bool isTagLoading, bool isShopLoading, bool isRestaurantLoading, RangeValues rangeValues, List<ShopData> shops, List<TakeModel> tags, List<int> prices, List<ShopData> restaurant
});




}
/// @nodoc
class _$FilterStateCopyWithImpl<$Res>
    implements $FilterStateCopyWith<$Res> {
  _$FilterStateCopyWithImpl(this._self, this._then);

  final FilterState _self;
  final $Res Function(FilterState) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterModel = freezed,Object? freeDelivery = null,Object? deals = null,Object? open = null,Object? shopCount = null,Object? endPrice = null,Object? startPrice = null,Object? isLoading = null,Object? isTagLoading = null,Object? isShopLoading = null,Object? isRestaurantLoading = null,Object? rangeValues = null,Object? shops = null,Object? tags = null,Object? prices = null,Object? restaurant = null,}) {
  return _then(_self.copyWith(
filterModel: freezed == filterModel ? _self.filterModel : filterModel // ignore: cast_nullable_to_non_nullable
as FilterModel?,freeDelivery: null == freeDelivery ? _self.freeDelivery : freeDelivery // ignore: cast_nullable_to_non_nullable
as bool,deals: null == deals ? _self.deals : deals // ignore: cast_nullable_to_non_nullable
as bool,open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as bool,shopCount: null == shopCount ? _self.shopCount : shopCount // ignore: cast_nullable_to_non_nullable
as int,endPrice: null == endPrice ? _self.endPrice : endPrice // ignore: cast_nullable_to_non_nullable
as double,startPrice: null == startPrice ? _self.startPrice : startPrice // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isTagLoading: null == isTagLoading ? _self.isTagLoading : isTagLoading // ignore: cast_nullable_to_non_nullable
as bool,isShopLoading: null == isShopLoading ? _self.isShopLoading : isShopLoading // ignore: cast_nullable_to_non_nullable
as bool,isRestaurantLoading: null == isRestaurantLoading ? _self.isRestaurantLoading : isRestaurantLoading // ignore: cast_nullable_to_non_nullable
as bool,rangeValues: null == rangeValues ? _self.rangeValues : rangeValues // ignore: cast_nullable_to_non_nullable
as RangeValues,shops: null == shops ? _self.shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<TakeModel>,prices: null == prices ? _self.prices : prices // ignore: cast_nullable_to_non_nullable
as List<int>,restaurant: null == restaurant ? _self.restaurant : restaurant // ignore: cast_nullable_to_non_nullable
as List<ShopData>,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterState].
extension FilterStatePatterns on FilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterState value)  $default,){
final _that = this;
switch (_that) {
case _FilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterState value)?  $default,){
final _that = this;
switch (_that) {
case _FilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FilterModel? filterModel,  bool freeDelivery,  bool deals,  bool open,  int shopCount,  double endPrice,  double startPrice,  bool isLoading,  bool isTagLoading,  bool isShopLoading,  bool isRestaurantLoading,  RangeValues rangeValues,  List<ShopData> shops,  List<TakeModel> tags,  List<int> prices,  List<ShopData> restaurant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.filterModel,_that.freeDelivery,_that.deals,_that.open,_that.shopCount,_that.endPrice,_that.startPrice,_that.isLoading,_that.isTagLoading,_that.isShopLoading,_that.isRestaurantLoading,_that.rangeValues,_that.shops,_that.tags,_that.prices,_that.restaurant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FilterModel? filterModel,  bool freeDelivery,  bool deals,  bool open,  int shopCount,  double endPrice,  double startPrice,  bool isLoading,  bool isTagLoading,  bool isShopLoading,  bool isRestaurantLoading,  RangeValues rangeValues,  List<ShopData> shops,  List<TakeModel> tags,  List<int> prices,  List<ShopData> restaurant)  $default,) {final _that = this;
switch (_that) {
case _FilterState():
return $default(_that.filterModel,_that.freeDelivery,_that.deals,_that.open,_that.shopCount,_that.endPrice,_that.startPrice,_that.isLoading,_that.isTagLoading,_that.isShopLoading,_that.isRestaurantLoading,_that.rangeValues,_that.shops,_that.tags,_that.prices,_that.restaurant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FilterModel? filterModel,  bool freeDelivery,  bool deals,  bool open,  int shopCount,  double endPrice,  double startPrice,  bool isLoading,  bool isTagLoading,  bool isShopLoading,  bool isRestaurantLoading,  RangeValues rangeValues,  List<ShopData> shops,  List<TakeModel> tags,  List<int> prices,  List<ShopData> restaurant)?  $default,) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.filterModel,_that.freeDelivery,_that.deals,_that.open,_that.shopCount,_that.endPrice,_that.startPrice,_that.isLoading,_that.isTagLoading,_that.isShopLoading,_that.isRestaurantLoading,_that.rangeValues,_that.shops,_that.tags,_that.prices,_that.restaurant);case _:
  return null;

}
}

}

/// @nodoc


class _FilterState extends FilterState {
  const _FilterState({this.filterModel = null, this.freeDelivery = false, this.deals = false, this.open = true, this.shopCount = 0, this.endPrice = 100, this.startPrice = 1, this.isLoading = false, this.isTagLoading = false, this.isShopLoading = true, this.isRestaurantLoading = true, this.rangeValues = const RangeValues(1, 100), final  List<ShopData> shops = const [], final  List<TakeModel> tags = const [], final  List<int> prices = const [], final  List<ShopData> restaurant = const []}): _shops = shops,_tags = tags,_prices = prices,_restaurant = restaurant,super._();
  

@override@JsonKey() final  FilterModel? filterModel;
@override@JsonKey() final  bool freeDelivery;
@override@JsonKey() final  bool deals;
@override@JsonKey() final  bool open;
@override@JsonKey() final  int shopCount;
@override@JsonKey() final  double endPrice;
@override@JsonKey() final  double startPrice;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isTagLoading;
@override@JsonKey() final  bool isShopLoading;
@override@JsonKey() final  bool isRestaurantLoading;
@override@JsonKey() final  RangeValues rangeValues;
 final  List<ShopData> _shops;
@override@JsonKey() List<ShopData> get shops {
  if (_shops is EqualUnmodifiableListView) return _shops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shops);
}

 final  List<TakeModel> _tags;
@override@JsonKey() List<TakeModel> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<int> _prices;
@override@JsonKey() List<int> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}

 final  List<ShopData> _restaurant;
@override@JsonKey() List<ShopData> get restaurant {
  if (_restaurant is EqualUnmodifiableListView) return _restaurant;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_restaurant);
}


/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterStateCopyWith<_FilterState> get copyWith => __$FilterStateCopyWithImpl<_FilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterState&&(identical(other.filterModel, filterModel) || other.filterModel == filterModel)&&(identical(other.freeDelivery, freeDelivery) || other.freeDelivery == freeDelivery)&&(identical(other.deals, deals) || other.deals == deals)&&(identical(other.open, open) || other.open == open)&&(identical(other.shopCount, shopCount) || other.shopCount == shopCount)&&(identical(other.endPrice, endPrice) || other.endPrice == endPrice)&&(identical(other.startPrice, startPrice) || other.startPrice == startPrice)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isTagLoading, isTagLoading) || other.isTagLoading == isTagLoading)&&(identical(other.isShopLoading, isShopLoading) || other.isShopLoading == isShopLoading)&&(identical(other.isRestaurantLoading, isRestaurantLoading) || other.isRestaurantLoading == isRestaurantLoading)&&(identical(other.rangeValues, rangeValues) || other.rangeValues == rangeValues)&&const DeepCollectionEquality().equals(other._shops, _shops)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._prices, _prices)&&const DeepCollectionEquality().equals(other._restaurant, _restaurant));
}


@override
int get hashCode => Object.hash(runtimeType,filterModel,freeDelivery,deals,open,shopCount,endPrice,startPrice,isLoading,isTagLoading,isShopLoading,isRestaurantLoading,rangeValues,const DeepCollectionEquality().hash(_shops),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_prices),const DeepCollectionEquality().hash(_restaurant));

@override
String toString() {
  return 'FilterState(filterModel: $filterModel, freeDelivery: $freeDelivery, deals: $deals, open: $open, shopCount: $shopCount, endPrice: $endPrice, startPrice: $startPrice, isLoading: $isLoading, isTagLoading: $isTagLoading, isShopLoading: $isShopLoading, isRestaurantLoading: $isRestaurantLoading, rangeValues: $rangeValues, shops: $shops, tags: $tags, prices: $prices, restaurant: $restaurant)';
}


}

/// @nodoc
abstract mixin class _$FilterStateCopyWith<$Res> implements $FilterStateCopyWith<$Res> {
  factory _$FilterStateCopyWith(_FilterState value, $Res Function(_FilterState) _then) = __$FilterStateCopyWithImpl;
@override @useResult
$Res call({
 FilterModel? filterModel, bool freeDelivery, bool deals, bool open, int shopCount, double endPrice, double startPrice, bool isLoading, bool isTagLoading, bool isShopLoading, bool isRestaurantLoading, RangeValues rangeValues, List<ShopData> shops, List<TakeModel> tags, List<int> prices, List<ShopData> restaurant
});




}
/// @nodoc
class __$FilterStateCopyWithImpl<$Res>
    implements _$FilterStateCopyWith<$Res> {
  __$FilterStateCopyWithImpl(this._self, this._then);

  final _FilterState _self;
  final $Res Function(_FilterState) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterModel = freezed,Object? freeDelivery = null,Object? deals = null,Object? open = null,Object? shopCount = null,Object? endPrice = null,Object? startPrice = null,Object? isLoading = null,Object? isTagLoading = null,Object? isShopLoading = null,Object? isRestaurantLoading = null,Object? rangeValues = null,Object? shops = null,Object? tags = null,Object? prices = null,Object? restaurant = null,}) {
  return _then(_FilterState(
filterModel: freezed == filterModel ? _self.filterModel : filterModel // ignore: cast_nullable_to_non_nullable
as FilterModel?,freeDelivery: null == freeDelivery ? _self.freeDelivery : freeDelivery // ignore: cast_nullable_to_non_nullable
as bool,deals: null == deals ? _self.deals : deals // ignore: cast_nullable_to_non_nullable
as bool,open: null == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as bool,shopCount: null == shopCount ? _self.shopCount : shopCount // ignore: cast_nullable_to_non_nullable
as int,endPrice: null == endPrice ? _self.endPrice : endPrice // ignore: cast_nullable_to_non_nullable
as double,startPrice: null == startPrice ? _self.startPrice : startPrice // ignore: cast_nullable_to_non_nullable
as double,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isTagLoading: null == isTagLoading ? _self.isTagLoading : isTagLoading // ignore: cast_nullable_to_non_nullable
as bool,isShopLoading: null == isShopLoading ? _self.isShopLoading : isShopLoading // ignore: cast_nullable_to_non_nullable
as bool,isRestaurantLoading: null == isRestaurantLoading ? _self.isRestaurantLoading : isRestaurantLoading // ignore: cast_nullable_to_non_nullable
as bool,rangeValues: null == rangeValues ? _self.rangeValues : rangeValues // ignore: cast_nullable_to_non_nullable
as RangeValues,shops: null == shops ? _self._shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<TakeModel>,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<int>,restaurant: null == restaurant ? _self._restaurant : restaurant // ignore: cast_nullable_to_non_nullable
as List<ShopData>,
  ));
}


}

// dart format on
