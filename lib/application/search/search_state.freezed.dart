// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 bool get isShopLoading; bool get isProductLoading; String get search; List<ProductData> get products; List<ShopData> get shops; int get selectIndexCategory; List<String> get searchHistory;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.isShopLoading, isShopLoading) || other.isShopLoading == isShopLoading)&&(identical(other.isProductLoading, isProductLoading) || other.isProductLoading == isProductLoading)&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.shops, shops)&&(identical(other.selectIndexCategory, selectIndexCategory) || other.selectIndexCategory == selectIndexCategory)&&const DeepCollectionEquality().equals(other.searchHistory, searchHistory));
}


@override
int get hashCode => Object.hash(runtimeType,isShopLoading,isProductLoading,search,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(shops),selectIndexCategory,const DeepCollectionEquality().hash(searchHistory));

@override
String toString() {
  return 'SearchState(isShopLoading: $isShopLoading, isProductLoading: $isProductLoading, search: $search, products: $products, shops: $shops, selectIndexCategory: $selectIndexCategory, searchHistory: $searchHistory)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 bool isShopLoading, bool isProductLoading, String search, List<ProductData> products, List<ShopData> shops, int selectIndexCategory, List<String> searchHistory
});




}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isShopLoading = null,Object? isProductLoading = null,Object? search = null,Object? products = null,Object? shops = null,Object? selectIndexCategory = null,Object? searchHistory = null,}) {
  return _then(_self.copyWith(
isShopLoading: null == isShopLoading ? _self.isShopLoading : isShopLoading // ignore: cast_nullable_to_non_nullable
as bool,isProductLoading: null == isProductLoading ? _self.isProductLoading : isProductLoading // ignore: cast_nullable_to_non_nullable
as bool,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductData>,shops: null == shops ? _self.shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,selectIndexCategory: null == selectIndexCategory ? _self.selectIndexCategory : selectIndexCategory // ignore: cast_nullable_to_non_nullable
as int,searchHistory: null == searchHistory ? _self.searchHistory : searchHistory // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isShopLoading,  bool isProductLoading,  String search,  List<ProductData> products,  List<ShopData> shops,  int selectIndexCategory,  List<String> searchHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.isShopLoading,_that.isProductLoading,_that.search,_that.products,_that.shops,_that.selectIndexCategory,_that.searchHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isShopLoading,  bool isProductLoading,  String search,  List<ProductData> products,  List<ShopData> shops,  int selectIndexCategory,  List<String> searchHistory)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.isShopLoading,_that.isProductLoading,_that.search,_that.products,_that.shops,_that.selectIndexCategory,_that.searchHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isShopLoading,  bool isProductLoading,  String search,  List<ProductData> products,  List<ShopData> shops,  int selectIndexCategory,  List<String> searchHistory)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.isShopLoading,_that.isProductLoading,_that.search,_that.products,_that.shops,_that.selectIndexCategory,_that.searchHistory);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState extends SearchState {
  const _SearchState({this.isShopLoading = true, this.isProductLoading = true, this.search = "", final  List<ProductData> products = const [], final  List<ShopData> shops = const [], this.selectIndexCategory = -1, final  List<String> searchHistory = const []}): _products = products,_shops = shops,_searchHistory = searchHistory,super._();
  

@override@JsonKey() final  bool isShopLoading;
@override@JsonKey() final  bool isProductLoading;
@override@JsonKey() final  String search;
 final  List<ProductData> _products;
@override@JsonKey() List<ProductData> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<ShopData> _shops;
@override@JsonKey() List<ShopData> get shops {
  if (_shops is EqualUnmodifiableListView) return _shops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shops);
}

@override@JsonKey() final  int selectIndexCategory;
 final  List<String> _searchHistory;
@override@JsonKey() List<String> get searchHistory {
  if (_searchHistory is EqualUnmodifiableListView) return _searchHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchHistory);
}


/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.isShopLoading, isShopLoading) || other.isShopLoading == isShopLoading)&&(identical(other.isProductLoading, isProductLoading) || other.isProductLoading == isProductLoading)&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._shops, _shops)&&(identical(other.selectIndexCategory, selectIndexCategory) || other.selectIndexCategory == selectIndexCategory)&&const DeepCollectionEquality().equals(other._searchHistory, _searchHistory));
}


@override
int get hashCode => Object.hash(runtimeType,isShopLoading,isProductLoading,search,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_shops),selectIndexCategory,const DeepCollectionEquality().hash(_searchHistory));

@override
String toString() {
  return 'SearchState(isShopLoading: $isShopLoading, isProductLoading: $isProductLoading, search: $search, products: $products, shops: $shops, selectIndexCategory: $selectIndexCategory, searchHistory: $searchHistory)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 bool isShopLoading, bool isProductLoading, String search, List<ProductData> products, List<ShopData> shops, int selectIndexCategory, List<String> searchHistory
});




}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isShopLoading = null,Object? isProductLoading = null,Object? search = null,Object? products = null,Object? shops = null,Object? selectIndexCategory = null,Object? searchHistory = null,}) {
  return _then(_SearchState(
isShopLoading: null == isShopLoading ? _self.isShopLoading : isShopLoading // ignore: cast_nullable_to_non_nullable
as bool,isProductLoading: null == isProductLoading ? _self.isProductLoading : isProductLoading // ignore: cast_nullable_to_non_nullable
as bool,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductData>,shops: null == shops ? _self._shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,selectIndexCategory: null == selectIndexCategory ? _self.selectIndexCategory : selectIndexCategory // ignore: cast_nullable_to_non_nullable
as int,searchHistory: null == searchHistory ? _self._searchHistory : searchHistory // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
