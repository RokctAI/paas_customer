// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 bool get isCategoryLoading; bool get isBannerLoading; bool get isShopLoading; bool get isRestaurantLoading; bool get isRestaurantNewLoading; bool get isStoryLoading; bool get isShopRecommendLoading; int get totalShops; int get selectIndexCategory; int get selectIndexSubCategory; int get isSelectCategoryLoading; AddressNewModel? get addressData; List<CategoryData> get categories; List<BannerData> get banners; List<BannerData> get ads; BannerData? get banner; List<ShopData> get shops; List<ShopData> get restaurant; List<ShopData> get newRestaurant; List<List<StoryModel?>?>? get story; List<ShopData> get shopsRecommend; List<ShopData> get filterShops; List<ShopData> get filterMarket;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.isCategoryLoading, isCategoryLoading) || other.isCategoryLoading == isCategoryLoading)&&(identical(other.isBannerLoading, isBannerLoading) || other.isBannerLoading == isBannerLoading)&&(identical(other.isShopLoading, isShopLoading) || other.isShopLoading == isShopLoading)&&(identical(other.isRestaurantLoading, isRestaurantLoading) || other.isRestaurantLoading == isRestaurantLoading)&&(identical(other.isRestaurantNewLoading, isRestaurantNewLoading) || other.isRestaurantNewLoading == isRestaurantNewLoading)&&(identical(other.isStoryLoading, isStoryLoading) || other.isStoryLoading == isStoryLoading)&&(identical(other.isShopRecommendLoading, isShopRecommendLoading) || other.isShopRecommendLoading == isShopRecommendLoading)&&(identical(other.totalShops, totalShops) || other.totalShops == totalShops)&&(identical(other.selectIndexCategory, selectIndexCategory) || other.selectIndexCategory == selectIndexCategory)&&(identical(other.selectIndexSubCategory, selectIndexSubCategory) || other.selectIndexSubCategory == selectIndexSubCategory)&&(identical(other.isSelectCategoryLoading, isSelectCategoryLoading) || other.isSelectCategoryLoading == isSelectCategoryLoading)&&(identical(other.addressData, addressData) || other.addressData == addressData)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.banners, banners)&&const DeepCollectionEquality().equals(other.ads, ads)&&(identical(other.banner, banner) || other.banner == banner)&&const DeepCollectionEquality().equals(other.shops, shops)&&const DeepCollectionEquality().equals(other.restaurant, restaurant)&&const DeepCollectionEquality().equals(other.newRestaurant, newRestaurant)&&const DeepCollectionEquality().equals(other.story, story)&&const DeepCollectionEquality().equals(other.shopsRecommend, shopsRecommend)&&const DeepCollectionEquality().equals(other.filterShops, filterShops)&&const DeepCollectionEquality().equals(other.filterMarket, filterMarket));
}


@override
int get hashCode => Object.hashAll([runtimeType,isCategoryLoading,isBannerLoading,isShopLoading,isRestaurantLoading,isRestaurantNewLoading,isStoryLoading,isShopRecommendLoading,totalShops,selectIndexCategory,selectIndexSubCategory,isSelectCategoryLoading,addressData,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(banners),const DeepCollectionEquality().hash(ads),banner,const DeepCollectionEquality().hash(shops),const DeepCollectionEquality().hash(restaurant),const DeepCollectionEquality().hash(newRestaurant),const DeepCollectionEquality().hash(story),const DeepCollectionEquality().hash(shopsRecommend),const DeepCollectionEquality().hash(filterShops),const DeepCollectionEquality().hash(filterMarket)]);

@override
String toString() {
  return 'HomeState(isCategoryLoading: $isCategoryLoading, isBannerLoading: $isBannerLoading, isShopLoading: $isShopLoading, isRestaurantLoading: $isRestaurantLoading, isRestaurantNewLoading: $isRestaurantNewLoading, isStoryLoading: $isStoryLoading, isShopRecommendLoading: $isShopRecommendLoading, totalShops: $totalShops, selectIndexCategory: $selectIndexCategory, selectIndexSubCategory: $selectIndexSubCategory, isSelectCategoryLoading: $isSelectCategoryLoading, addressData: $addressData, categories: $categories, banners: $banners, ads: $ads, banner: $banner, shops: $shops, restaurant: $restaurant, newRestaurant: $newRestaurant, story: $story, shopsRecommend: $shopsRecommend, filterShops: $filterShops, filterMarket: $filterMarket)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 bool isCategoryLoading, bool isBannerLoading, bool isShopLoading, bool isRestaurantLoading, bool isRestaurantNewLoading, bool isStoryLoading, bool isShopRecommendLoading, int totalShops, int selectIndexCategory, int selectIndexSubCategory, int isSelectCategoryLoading, AddressNewModel? addressData, List<CategoryData> categories, List<BannerData> banners, List<BannerData> ads, BannerData? banner, List<ShopData> shops, List<ShopData> restaurant, List<ShopData> newRestaurant, List<List<StoryModel?>?>? story, List<ShopData> shopsRecommend, List<ShopData> filterShops, List<ShopData> filterMarket
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCategoryLoading = null,Object? isBannerLoading = null,Object? isShopLoading = null,Object? isRestaurantLoading = null,Object? isRestaurantNewLoading = null,Object? isStoryLoading = null,Object? isShopRecommendLoading = null,Object? totalShops = null,Object? selectIndexCategory = null,Object? selectIndexSubCategory = null,Object? isSelectCategoryLoading = null,Object? addressData = freezed,Object? categories = null,Object? banners = null,Object? ads = null,Object? banner = freezed,Object? shops = null,Object? restaurant = null,Object? newRestaurant = null,Object? story = freezed,Object? shopsRecommend = null,Object? filterShops = null,Object? filterMarket = null,}) {
  return _then(_self.copyWith(
isCategoryLoading: null == isCategoryLoading ? _self.isCategoryLoading : isCategoryLoading // ignore: cast_nullable_to_non_nullable
as bool,isBannerLoading: null == isBannerLoading ? _self.isBannerLoading : isBannerLoading // ignore: cast_nullable_to_non_nullable
as bool,isShopLoading: null == isShopLoading ? _self.isShopLoading : isShopLoading // ignore: cast_nullable_to_non_nullable
as bool,isRestaurantLoading: null == isRestaurantLoading ? _self.isRestaurantLoading : isRestaurantLoading // ignore: cast_nullable_to_non_nullable
as bool,isRestaurantNewLoading: null == isRestaurantNewLoading ? _self.isRestaurantNewLoading : isRestaurantNewLoading // ignore: cast_nullable_to_non_nullable
as bool,isStoryLoading: null == isStoryLoading ? _self.isStoryLoading : isStoryLoading // ignore: cast_nullable_to_non_nullable
as bool,isShopRecommendLoading: null == isShopRecommendLoading ? _self.isShopRecommendLoading : isShopRecommendLoading // ignore: cast_nullable_to_non_nullable
as bool,totalShops: null == totalShops ? _self.totalShops : totalShops // ignore: cast_nullable_to_non_nullable
as int,selectIndexCategory: null == selectIndexCategory ? _self.selectIndexCategory : selectIndexCategory // ignore: cast_nullable_to_non_nullable
as int,selectIndexSubCategory: null == selectIndexSubCategory ? _self.selectIndexSubCategory : selectIndexSubCategory // ignore: cast_nullable_to_non_nullable
as int,isSelectCategoryLoading: null == isSelectCategoryLoading ? _self.isSelectCategoryLoading : isSelectCategoryLoading // ignore: cast_nullable_to_non_nullable
as int,addressData: freezed == addressData ? _self.addressData : addressData // ignore: cast_nullable_to_non_nullable
as AddressNewModel?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryData>,banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerData>,ads: null == ads ? _self.ads : ads // ignore: cast_nullable_to_non_nullable
as List<BannerData>,banner: freezed == banner ? _self.banner : banner // ignore: cast_nullable_to_non_nullable
as BannerData?,shops: null == shops ? _self.shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,restaurant: null == restaurant ? _self.restaurant : restaurant // ignore: cast_nullable_to_non_nullable
as List<ShopData>,newRestaurant: null == newRestaurant ? _self.newRestaurant : newRestaurant // ignore: cast_nullable_to_non_nullable
as List<ShopData>,story: freezed == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as List<List<StoryModel?>?>?,shopsRecommend: null == shopsRecommend ? _self.shopsRecommend : shopsRecommend // ignore: cast_nullable_to_non_nullable
as List<ShopData>,filterShops: null == filterShops ? _self.filterShops : filterShops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,filterMarket: null == filterMarket ? _self.filterMarket : filterMarket // ignore: cast_nullable_to_non_nullable
as List<ShopData>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isCategoryLoading,  bool isBannerLoading,  bool isShopLoading,  bool isRestaurantLoading,  bool isRestaurantNewLoading,  bool isStoryLoading,  bool isShopRecommendLoading,  int totalShops,  int selectIndexCategory,  int selectIndexSubCategory,  int isSelectCategoryLoading,  AddressNewModel? addressData,  List<CategoryData> categories,  List<BannerData> banners,  List<BannerData> ads,  BannerData? banner,  List<ShopData> shops,  List<ShopData> restaurant,  List<ShopData> newRestaurant,  List<List<StoryModel?>?>? story,  List<ShopData> shopsRecommend,  List<ShopData> filterShops,  List<ShopData> filterMarket)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.isCategoryLoading,_that.isBannerLoading,_that.isShopLoading,_that.isRestaurantLoading,_that.isRestaurantNewLoading,_that.isStoryLoading,_that.isShopRecommendLoading,_that.totalShops,_that.selectIndexCategory,_that.selectIndexSubCategory,_that.isSelectCategoryLoading,_that.addressData,_that.categories,_that.banners,_that.ads,_that.banner,_that.shops,_that.restaurant,_that.newRestaurant,_that.story,_that.shopsRecommend,_that.filterShops,_that.filterMarket);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isCategoryLoading,  bool isBannerLoading,  bool isShopLoading,  bool isRestaurantLoading,  bool isRestaurantNewLoading,  bool isStoryLoading,  bool isShopRecommendLoading,  int totalShops,  int selectIndexCategory,  int selectIndexSubCategory,  int isSelectCategoryLoading,  AddressNewModel? addressData,  List<CategoryData> categories,  List<BannerData> banners,  List<BannerData> ads,  BannerData? banner,  List<ShopData> shops,  List<ShopData> restaurant,  List<ShopData> newRestaurant,  List<List<StoryModel?>?>? story,  List<ShopData> shopsRecommend,  List<ShopData> filterShops,  List<ShopData> filterMarket)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.isCategoryLoading,_that.isBannerLoading,_that.isShopLoading,_that.isRestaurantLoading,_that.isRestaurantNewLoading,_that.isStoryLoading,_that.isShopRecommendLoading,_that.totalShops,_that.selectIndexCategory,_that.selectIndexSubCategory,_that.isSelectCategoryLoading,_that.addressData,_that.categories,_that.banners,_that.ads,_that.banner,_that.shops,_that.restaurant,_that.newRestaurant,_that.story,_that.shopsRecommend,_that.filterShops,_that.filterMarket);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isCategoryLoading,  bool isBannerLoading,  bool isShopLoading,  bool isRestaurantLoading,  bool isRestaurantNewLoading,  bool isStoryLoading,  bool isShopRecommendLoading,  int totalShops,  int selectIndexCategory,  int selectIndexSubCategory,  int isSelectCategoryLoading,  AddressNewModel? addressData,  List<CategoryData> categories,  List<BannerData> banners,  List<BannerData> ads,  BannerData? banner,  List<ShopData> shops,  List<ShopData> restaurant,  List<ShopData> newRestaurant,  List<List<StoryModel?>?>? story,  List<ShopData> shopsRecommend,  List<ShopData> filterShops,  List<ShopData> filterMarket)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.isCategoryLoading,_that.isBannerLoading,_that.isShopLoading,_that.isRestaurantLoading,_that.isRestaurantNewLoading,_that.isStoryLoading,_that.isShopRecommendLoading,_that.totalShops,_that.selectIndexCategory,_that.selectIndexSubCategory,_that.isSelectCategoryLoading,_that.addressData,_that.categories,_that.banners,_that.ads,_that.banner,_that.shops,_that.restaurant,_that.newRestaurant,_that.story,_that.shopsRecommend,_that.filterShops,_that.filterMarket);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({this.isCategoryLoading = true, this.isBannerLoading = true, this.isShopLoading = true, this.isRestaurantLoading = true, this.isRestaurantNewLoading = true, this.isStoryLoading = true, this.isShopRecommendLoading = true, this.totalShops = -1, this.selectIndexCategory = -1, this.selectIndexSubCategory = -1, this.isSelectCategoryLoading = 0, this.addressData = null, final  List<CategoryData> categories = const [], final  List<BannerData> banners = const [], final  List<BannerData> ads = const [], this.banner = null, final  List<ShopData> shops = const [], final  List<ShopData> restaurant = const [], final  List<ShopData> newRestaurant = const [], final  List<List<StoryModel?>?>? story = const [], final  List<ShopData> shopsRecommend = const [], final  List<ShopData> filterShops = const [], final  List<ShopData> filterMarket = const []}): _categories = categories,_banners = banners,_ads = ads,_shops = shops,_restaurant = restaurant,_newRestaurant = newRestaurant,_story = story,_shopsRecommend = shopsRecommend,_filterShops = filterShops,_filterMarket = filterMarket,super._();
  

@override@JsonKey() final  bool isCategoryLoading;
@override@JsonKey() final  bool isBannerLoading;
@override@JsonKey() final  bool isShopLoading;
@override@JsonKey() final  bool isRestaurantLoading;
@override@JsonKey() final  bool isRestaurantNewLoading;
@override@JsonKey() final  bool isStoryLoading;
@override@JsonKey() final  bool isShopRecommendLoading;
@override@JsonKey() final  int totalShops;
@override@JsonKey() final  int selectIndexCategory;
@override@JsonKey() final  int selectIndexSubCategory;
@override@JsonKey() final  int isSelectCategoryLoading;
@override@JsonKey() final  AddressNewModel? addressData;
 final  List<CategoryData> _categories;
@override@JsonKey() List<CategoryData> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<BannerData> _banners;
@override@JsonKey() List<BannerData> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

 final  List<BannerData> _ads;
@override@JsonKey() List<BannerData> get ads {
  if (_ads is EqualUnmodifiableListView) return _ads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ads);
}

@override@JsonKey() final  BannerData? banner;
 final  List<ShopData> _shops;
@override@JsonKey() List<ShopData> get shops {
  if (_shops is EqualUnmodifiableListView) return _shops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shops);
}

 final  List<ShopData> _restaurant;
@override@JsonKey() List<ShopData> get restaurant {
  if (_restaurant is EqualUnmodifiableListView) return _restaurant;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_restaurant);
}

 final  List<ShopData> _newRestaurant;
@override@JsonKey() List<ShopData> get newRestaurant {
  if (_newRestaurant is EqualUnmodifiableListView) return _newRestaurant;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_newRestaurant);
}

 final  List<List<StoryModel?>?>? _story;
@override@JsonKey() List<List<StoryModel?>?>? get story {
  final value = _story;
  if (value == null) return null;
  if (_story is EqualUnmodifiableListView) return _story;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ShopData> _shopsRecommend;
@override@JsonKey() List<ShopData> get shopsRecommend {
  if (_shopsRecommend is EqualUnmodifiableListView) return _shopsRecommend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shopsRecommend);
}

 final  List<ShopData> _filterShops;
@override@JsonKey() List<ShopData> get filterShops {
  if (_filterShops is EqualUnmodifiableListView) return _filterShops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filterShops);
}

 final  List<ShopData> _filterMarket;
@override@JsonKey() List<ShopData> get filterMarket {
  if (_filterMarket is EqualUnmodifiableListView) return _filterMarket;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filterMarket);
}


/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.isCategoryLoading, isCategoryLoading) || other.isCategoryLoading == isCategoryLoading)&&(identical(other.isBannerLoading, isBannerLoading) || other.isBannerLoading == isBannerLoading)&&(identical(other.isShopLoading, isShopLoading) || other.isShopLoading == isShopLoading)&&(identical(other.isRestaurantLoading, isRestaurantLoading) || other.isRestaurantLoading == isRestaurantLoading)&&(identical(other.isRestaurantNewLoading, isRestaurantNewLoading) || other.isRestaurantNewLoading == isRestaurantNewLoading)&&(identical(other.isStoryLoading, isStoryLoading) || other.isStoryLoading == isStoryLoading)&&(identical(other.isShopRecommendLoading, isShopRecommendLoading) || other.isShopRecommendLoading == isShopRecommendLoading)&&(identical(other.totalShops, totalShops) || other.totalShops == totalShops)&&(identical(other.selectIndexCategory, selectIndexCategory) || other.selectIndexCategory == selectIndexCategory)&&(identical(other.selectIndexSubCategory, selectIndexSubCategory) || other.selectIndexSubCategory == selectIndexSubCategory)&&(identical(other.isSelectCategoryLoading, isSelectCategoryLoading) || other.isSelectCategoryLoading == isSelectCategoryLoading)&&(identical(other.addressData, addressData) || other.addressData == addressData)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._banners, _banners)&&const DeepCollectionEquality().equals(other._ads, _ads)&&(identical(other.banner, banner) || other.banner == banner)&&const DeepCollectionEquality().equals(other._shops, _shops)&&const DeepCollectionEquality().equals(other._restaurant, _restaurant)&&const DeepCollectionEquality().equals(other._newRestaurant, _newRestaurant)&&const DeepCollectionEquality().equals(other._story, _story)&&const DeepCollectionEquality().equals(other._shopsRecommend, _shopsRecommend)&&const DeepCollectionEquality().equals(other._filterShops, _filterShops)&&const DeepCollectionEquality().equals(other._filterMarket, _filterMarket));
}


@override
int get hashCode => Object.hashAll([runtimeType,isCategoryLoading,isBannerLoading,isShopLoading,isRestaurantLoading,isRestaurantNewLoading,isStoryLoading,isShopRecommendLoading,totalShops,selectIndexCategory,selectIndexSubCategory,isSelectCategoryLoading,addressData,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_banners),const DeepCollectionEquality().hash(_ads),banner,const DeepCollectionEquality().hash(_shops),const DeepCollectionEquality().hash(_restaurant),const DeepCollectionEquality().hash(_newRestaurant),const DeepCollectionEquality().hash(_story),const DeepCollectionEquality().hash(_shopsRecommend),const DeepCollectionEquality().hash(_filterShops),const DeepCollectionEquality().hash(_filterMarket)]);

@override
String toString() {
  return 'HomeState(isCategoryLoading: $isCategoryLoading, isBannerLoading: $isBannerLoading, isShopLoading: $isShopLoading, isRestaurantLoading: $isRestaurantLoading, isRestaurantNewLoading: $isRestaurantNewLoading, isStoryLoading: $isStoryLoading, isShopRecommendLoading: $isShopRecommendLoading, totalShops: $totalShops, selectIndexCategory: $selectIndexCategory, selectIndexSubCategory: $selectIndexSubCategory, isSelectCategoryLoading: $isSelectCategoryLoading, addressData: $addressData, categories: $categories, banners: $banners, ads: $ads, banner: $banner, shops: $shops, restaurant: $restaurant, newRestaurant: $newRestaurant, story: $story, shopsRecommend: $shopsRecommend, filterShops: $filterShops, filterMarket: $filterMarket)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isCategoryLoading, bool isBannerLoading, bool isShopLoading, bool isRestaurantLoading, bool isRestaurantNewLoading, bool isStoryLoading, bool isShopRecommendLoading, int totalShops, int selectIndexCategory, int selectIndexSubCategory, int isSelectCategoryLoading, AddressNewModel? addressData, List<CategoryData> categories, List<BannerData> banners, List<BannerData> ads, BannerData? banner, List<ShopData> shops, List<ShopData> restaurant, List<ShopData> newRestaurant, List<List<StoryModel?>?>? story, List<ShopData> shopsRecommend, List<ShopData> filterShops, List<ShopData> filterMarket
});




}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCategoryLoading = null,Object? isBannerLoading = null,Object? isShopLoading = null,Object? isRestaurantLoading = null,Object? isRestaurantNewLoading = null,Object? isStoryLoading = null,Object? isShopRecommendLoading = null,Object? totalShops = null,Object? selectIndexCategory = null,Object? selectIndexSubCategory = null,Object? isSelectCategoryLoading = null,Object? addressData = freezed,Object? categories = null,Object? banners = null,Object? ads = null,Object? banner = freezed,Object? shops = null,Object? restaurant = null,Object? newRestaurant = null,Object? story = freezed,Object? shopsRecommend = null,Object? filterShops = null,Object? filterMarket = null,}) {
  return _then(_HomeState(
isCategoryLoading: null == isCategoryLoading ? _self.isCategoryLoading : isCategoryLoading // ignore: cast_nullable_to_non_nullable
as bool,isBannerLoading: null == isBannerLoading ? _self.isBannerLoading : isBannerLoading // ignore: cast_nullable_to_non_nullable
as bool,isShopLoading: null == isShopLoading ? _self.isShopLoading : isShopLoading // ignore: cast_nullable_to_non_nullable
as bool,isRestaurantLoading: null == isRestaurantLoading ? _self.isRestaurantLoading : isRestaurantLoading // ignore: cast_nullable_to_non_nullable
as bool,isRestaurantNewLoading: null == isRestaurantNewLoading ? _self.isRestaurantNewLoading : isRestaurantNewLoading // ignore: cast_nullable_to_non_nullable
as bool,isStoryLoading: null == isStoryLoading ? _self.isStoryLoading : isStoryLoading // ignore: cast_nullable_to_non_nullable
as bool,isShopRecommendLoading: null == isShopRecommendLoading ? _self.isShopRecommendLoading : isShopRecommendLoading // ignore: cast_nullable_to_non_nullable
as bool,totalShops: null == totalShops ? _self.totalShops : totalShops // ignore: cast_nullable_to_non_nullable
as int,selectIndexCategory: null == selectIndexCategory ? _self.selectIndexCategory : selectIndexCategory // ignore: cast_nullable_to_non_nullable
as int,selectIndexSubCategory: null == selectIndexSubCategory ? _self.selectIndexSubCategory : selectIndexSubCategory // ignore: cast_nullable_to_non_nullable
as int,isSelectCategoryLoading: null == isSelectCategoryLoading ? _self.isSelectCategoryLoading : isSelectCategoryLoading // ignore: cast_nullable_to_non_nullable
as int,addressData: freezed == addressData ? _self.addressData : addressData // ignore: cast_nullable_to_non_nullable
as AddressNewModel?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryData>,banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerData>,ads: null == ads ? _self._ads : ads // ignore: cast_nullable_to_non_nullable
as List<BannerData>,banner: freezed == banner ? _self.banner : banner // ignore: cast_nullable_to_non_nullable
as BannerData?,shops: null == shops ? _self._shops : shops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,restaurant: null == restaurant ? _self._restaurant : restaurant // ignore: cast_nullable_to_non_nullable
as List<ShopData>,newRestaurant: null == newRestaurant ? _self._newRestaurant : newRestaurant // ignore: cast_nullable_to_non_nullable
as List<ShopData>,story: freezed == story ? _self._story : story // ignore: cast_nullable_to_non_nullable
as List<List<StoryModel?>?>?,shopsRecommend: null == shopsRecommend ? _self._shopsRecommend : shopsRecommend // ignore: cast_nullable_to_non_nullable
as List<ShopData>,filterShops: null == filterShops ? _self._filterShops : filterShops // ignore: cast_nullable_to_non_nullable
as List<ShopData>,filterMarket: null == filterMarket ? _self._filterMarket : filterMarket // ignore: cast_nullable_to_non_nullable
as List<ShopData>,
  ));
}


}

// dart format on
