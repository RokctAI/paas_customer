// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductState {

 bool get isLoading; bool get isAddLoading; bool get isShareLoading; bool get isCheckShopOrder; int get currentIndex; int get count; int get stockCount; List<TypedExtra> get typedExtras; List<Stocks> get initialStocks; List<int> get selectedIndexes; String get activeImageUrl; ProductData? get productData; Galleries? get selectImage; Stocks? get selectedStock;
/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductStateCopyWith<ProductState> get copyWith => _$ProductStateCopyWithImpl<ProductState>(this as ProductState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAddLoading, isAddLoading) || other.isAddLoading == isAddLoading)&&(identical(other.isShareLoading, isShareLoading) || other.isShareLoading == isShareLoading)&&(identical(other.isCheckShopOrder, isCheckShopOrder) || other.isCheckShopOrder == isCheckShopOrder)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.count, count) || other.count == count)&&(identical(other.stockCount, stockCount) || other.stockCount == stockCount)&&const DeepCollectionEquality().equals(other.typedExtras, typedExtras)&&const DeepCollectionEquality().equals(other.initialStocks, initialStocks)&&const DeepCollectionEquality().equals(other.selectedIndexes, selectedIndexes)&&(identical(other.activeImageUrl, activeImageUrl) || other.activeImageUrl == activeImageUrl)&&(identical(other.productData, productData) || other.productData == productData)&&(identical(other.selectImage, selectImage) || other.selectImage == selectImage)&&(identical(other.selectedStock, selectedStock) || other.selectedStock == selectedStock));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isAddLoading,isShareLoading,isCheckShopOrder,currentIndex,count,stockCount,const DeepCollectionEquality().hash(typedExtras),const DeepCollectionEquality().hash(initialStocks),const DeepCollectionEquality().hash(selectedIndexes),activeImageUrl,productData,selectImage,selectedStock);

@override
String toString() {
  return 'ProductState(isLoading: $isLoading, isAddLoading: $isAddLoading, isShareLoading: $isShareLoading, isCheckShopOrder: $isCheckShopOrder, currentIndex: $currentIndex, count: $count, stockCount: $stockCount, typedExtras: $typedExtras, initialStocks: $initialStocks, selectedIndexes: $selectedIndexes, activeImageUrl: $activeImageUrl, productData: $productData, selectImage: $selectImage, selectedStock: $selectedStock)';
}


}

/// @nodoc
abstract mixin class $ProductStateCopyWith<$Res>  {
  factory $ProductStateCopyWith(ProductState value, $Res Function(ProductState) _then) = _$ProductStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isAddLoading, bool isShareLoading, bool isCheckShopOrder, int currentIndex, int count, int stockCount, List<TypedExtra> typedExtras, List<Stocks> initialStocks, List<int> selectedIndexes, String activeImageUrl, ProductData? productData, Galleries? selectImage, Stocks? selectedStock
});




}
/// @nodoc
class _$ProductStateCopyWithImpl<$Res>
    implements $ProductStateCopyWith<$Res> {
  _$ProductStateCopyWithImpl(this._self, this._then);

  final ProductState _self;
  final $Res Function(ProductState) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isAddLoading = null,Object? isShareLoading = null,Object? isCheckShopOrder = null,Object? currentIndex = null,Object? count = null,Object? stockCount = null,Object? typedExtras = null,Object? initialStocks = null,Object? selectedIndexes = null,Object? activeImageUrl = null,Object? productData = freezed,Object? selectImage = freezed,Object? selectedStock = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAddLoading: null == isAddLoading ? _self.isAddLoading : isAddLoading // ignore: cast_nullable_to_non_nullable
as bool,isShareLoading: null == isShareLoading ? _self.isShareLoading : isShareLoading // ignore: cast_nullable_to_non_nullable
as bool,isCheckShopOrder: null == isCheckShopOrder ? _self.isCheckShopOrder : isCheckShopOrder // ignore: cast_nullable_to_non_nullable
as bool,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,stockCount: null == stockCount ? _self.stockCount : stockCount // ignore: cast_nullable_to_non_nullable
as int,typedExtras: null == typedExtras ? _self.typedExtras : typedExtras // ignore: cast_nullable_to_non_nullable
as List<TypedExtra>,initialStocks: null == initialStocks ? _self.initialStocks : initialStocks // ignore: cast_nullable_to_non_nullable
as List<Stocks>,selectedIndexes: null == selectedIndexes ? _self.selectedIndexes : selectedIndexes // ignore: cast_nullable_to_non_nullable
as List<int>,activeImageUrl: null == activeImageUrl ? _self.activeImageUrl : activeImageUrl // ignore: cast_nullable_to_non_nullable
as String,productData: freezed == productData ? _self.productData : productData // ignore: cast_nullable_to_non_nullable
as ProductData?,selectImage: freezed == selectImage ? _self.selectImage : selectImage // ignore: cast_nullable_to_non_nullable
as Galleries?,selectedStock: freezed == selectedStock ? _self.selectedStock : selectedStock // ignore: cast_nullable_to_non_nullable
as Stocks?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductState].
extension ProductStatePatterns on ProductState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductState value)  $default,){
final _that = this;
switch (_that) {
case _ProductState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductState value)?  $default,){
final _that = this;
switch (_that) {
case _ProductState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isAddLoading,  bool isShareLoading,  bool isCheckShopOrder,  int currentIndex,  int count,  int stockCount,  List<TypedExtra> typedExtras,  List<Stocks> initialStocks,  List<int> selectedIndexes,  String activeImageUrl,  ProductData? productData,  Galleries? selectImage,  Stocks? selectedStock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that.isLoading,_that.isAddLoading,_that.isShareLoading,_that.isCheckShopOrder,_that.currentIndex,_that.count,_that.stockCount,_that.typedExtras,_that.initialStocks,_that.selectedIndexes,_that.activeImageUrl,_that.productData,_that.selectImage,_that.selectedStock);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isAddLoading,  bool isShareLoading,  bool isCheckShopOrder,  int currentIndex,  int count,  int stockCount,  List<TypedExtra> typedExtras,  List<Stocks> initialStocks,  List<int> selectedIndexes,  String activeImageUrl,  ProductData? productData,  Galleries? selectImage,  Stocks? selectedStock)  $default,) {final _that = this;
switch (_that) {
case _ProductState():
return $default(_that.isLoading,_that.isAddLoading,_that.isShareLoading,_that.isCheckShopOrder,_that.currentIndex,_that.count,_that.stockCount,_that.typedExtras,_that.initialStocks,_that.selectedIndexes,_that.activeImageUrl,_that.productData,_that.selectImage,_that.selectedStock);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isAddLoading,  bool isShareLoading,  bool isCheckShopOrder,  int currentIndex,  int count,  int stockCount,  List<TypedExtra> typedExtras,  List<Stocks> initialStocks,  List<int> selectedIndexes,  String activeImageUrl,  ProductData? productData,  Galleries? selectImage,  Stocks? selectedStock)?  $default,) {final _that = this;
switch (_that) {
case _ProductState() when $default != null:
return $default(_that.isLoading,_that.isAddLoading,_that.isShareLoading,_that.isCheckShopOrder,_that.currentIndex,_that.count,_that.stockCount,_that.typedExtras,_that.initialStocks,_that.selectedIndexes,_that.activeImageUrl,_that.productData,_that.selectImage,_that.selectedStock);case _:
  return null;

}
}

}

/// @nodoc


class _ProductState extends ProductState {
  const _ProductState({this.isLoading = false, this.isAddLoading = false, this.isShareLoading = false, this.isCheckShopOrder = false, this.currentIndex = 0, this.count = 1, this.stockCount = 0, final  List<TypedExtra> typedExtras = const [], final  List<Stocks> initialStocks = const [], final  List<int> selectedIndexes = const [], this.activeImageUrl = '', this.productData = null, this.selectImage = null, this.selectedStock}): _typedExtras = typedExtras,_initialStocks = initialStocks,_selectedIndexes = selectedIndexes,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isAddLoading;
@override@JsonKey() final  bool isShareLoading;
@override@JsonKey() final  bool isCheckShopOrder;
@override@JsonKey() final  int currentIndex;
@override@JsonKey() final  int count;
@override@JsonKey() final  int stockCount;
 final  List<TypedExtra> _typedExtras;
@override@JsonKey() List<TypedExtra> get typedExtras {
  if (_typedExtras is EqualUnmodifiableListView) return _typedExtras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_typedExtras);
}

 final  List<Stocks> _initialStocks;
@override@JsonKey() List<Stocks> get initialStocks {
  if (_initialStocks is EqualUnmodifiableListView) return _initialStocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_initialStocks);
}

 final  List<int> _selectedIndexes;
@override@JsonKey() List<int> get selectedIndexes {
  if (_selectedIndexes is EqualUnmodifiableListView) return _selectedIndexes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedIndexes);
}

@override@JsonKey() final  String activeImageUrl;
@override@JsonKey() final  ProductData? productData;
@override@JsonKey() final  Galleries? selectImage;
@override final  Stocks? selectedStock;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductStateCopyWith<_ProductState> get copyWith => __$ProductStateCopyWithImpl<_ProductState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAddLoading, isAddLoading) || other.isAddLoading == isAddLoading)&&(identical(other.isShareLoading, isShareLoading) || other.isShareLoading == isShareLoading)&&(identical(other.isCheckShopOrder, isCheckShopOrder) || other.isCheckShopOrder == isCheckShopOrder)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.count, count) || other.count == count)&&(identical(other.stockCount, stockCount) || other.stockCount == stockCount)&&const DeepCollectionEquality().equals(other._typedExtras, _typedExtras)&&const DeepCollectionEquality().equals(other._initialStocks, _initialStocks)&&const DeepCollectionEquality().equals(other._selectedIndexes, _selectedIndexes)&&(identical(other.activeImageUrl, activeImageUrl) || other.activeImageUrl == activeImageUrl)&&(identical(other.productData, productData) || other.productData == productData)&&(identical(other.selectImage, selectImage) || other.selectImage == selectImage)&&(identical(other.selectedStock, selectedStock) || other.selectedStock == selectedStock));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isAddLoading,isShareLoading,isCheckShopOrder,currentIndex,count,stockCount,const DeepCollectionEquality().hash(_typedExtras),const DeepCollectionEquality().hash(_initialStocks),const DeepCollectionEquality().hash(_selectedIndexes),activeImageUrl,productData,selectImage,selectedStock);

@override
String toString() {
  return 'ProductState(isLoading: $isLoading, isAddLoading: $isAddLoading, isShareLoading: $isShareLoading, isCheckShopOrder: $isCheckShopOrder, currentIndex: $currentIndex, count: $count, stockCount: $stockCount, typedExtras: $typedExtras, initialStocks: $initialStocks, selectedIndexes: $selectedIndexes, activeImageUrl: $activeImageUrl, productData: $productData, selectImage: $selectImage, selectedStock: $selectedStock)';
}


}

/// @nodoc
abstract mixin class _$ProductStateCopyWith<$Res> implements $ProductStateCopyWith<$Res> {
  factory _$ProductStateCopyWith(_ProductState value, $Res Function(_ProductState) _then) = __$ProductStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isAddLoading, bool isShareLoading, bool isCheckShopOrder, int currentIndex, int count, int stockCount, List<TypedExtra> typedExtras, List<Stocks> initialStocks, List<int> selectedIndexes, String activeImageUrl, ProductData? productData, Galleries? selectImage, Stocks? selectedStock
});




}
/// @nodoc
class __$ProductStateCopyWithImpl<$Res>
    implements _$ProductStateCopyWith<$Res> {
  __$ProductStateCopyWithImpl(this._self, this._then);

  final _ProductState _self;
  final $Res Function(_ProductState) _then;

/// Create a copy of ProductState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isAddLoading = null,Object? isShareLoading = null,Object? isCheckShopOrder = null,Object? currentIndex = null,Object? count = null,Object? stockCount = null,Object? typedExtras = null,Object? initialStocks = null,Object? selectedIndexes = null,Object? activeImageUrl = null,Object? productData = freezed,Object? selectImage = freezed,Object? selectedStock = freezed,}) {
  return _then(_ProductState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAddLoading: null == isAddLoading ? _self.isAddLoading : isAddLoading // ignore: cast_nullable_to_non_nullable
as bool,isShareLoading: null == isShareLoading ? _self.isShareLoading : isShareLoading // ignore: cast_nullable_to_non_nullable
as bool,isCheckShopOrder: null == isCheckShopOrder ? _self.isCheckShopOrder : isCheckShopOrder // ignore: cast_nullable_to_non_nullable
as bool,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,stockCount: null == stockCount ? _self.stockCount : stockCount // ignore: cast_nullable_to_non_nullable
as int,typedExtras: null == typedExtras ? _self._typedExtras : typedExtras // ignore: cast_nullable_to_non_nullable
as List<TypedExtra>,initialStocks: null == initialStocks ? _self._initialStocks : initialStocks // ignore: cast_nullable_to_non_nullable
as List<Stocks>,selectedIndexes: null == selectedIndexes ? _self._selectedIndexes : selectedIndexes // ignore: cast_nullable_to_non_nullable
as List<int>,activeImageUrl: null == activeImageUrl ? _self.activeImageUrl : activeImageUrl // ignore: cast_nullable_to_non_nullable
as String,productData: freezed == productData ? _self.productData : productData // ignore: cast_nullable_to_non_nullable
as ProductData?,selectImage: freezed == selectImage ? _self.selectImage : selectImage // ignore: cast_nullable_to_non_nullable
as Galleries?,selectedStock: freezed == selectedStock ? _self.selectedStock : selectedStock // ignore: cast_nullable_to_non_nullable
as Stocks?,
  ));
}


}

// dart format on
