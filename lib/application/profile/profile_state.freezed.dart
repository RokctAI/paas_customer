// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 bool get isLoading; bool get isReferralLoading; bool get isSaveLoading; bool get isLoadingHistory; int get typeIndex; int get selectAddress; String get bgImage; String get logoImage; AddressNewModel? get addressModel; ProfileData? get userData; ReferralModel? get referralData; List<WalletData>? get walletHistory; bool get isTermLoading; bool get isPolicyLoading; Translation? get policy; Translation? get term; List<String> get filepath; List<CareerData> get careers; CareerData? get selectedCareer; List<BlogData> get blogs; BlogData? get selectBlog; List<PageData> get about;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isReferralLoading, isReferralLoading) || other.isReferralLoading == isReferralLoading)&&(identical(other.isSaveLoading, isSaveLoading) || other.isSaveLoading == isSaveLoading)&&(identical(other.isLoadingHistory, isLoadingHistory) || other.isLoadingHistory == isLoadingHistory)&&(identical(other.typeIndex, typeIndex) || other.typeIndex == typeIndex)&&(identical(other.selectAddress, selectAddress) || other.selectAddress == selectAddress)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.logoImage, logoImage) || other.logoImage == logoImage)&&(identical(other.addressModel, addressModel) || other.addressModel == addressModel)&&(identical(other.userData, userData) || other.userData == userData)&&(identical(other.referralData, referralData) || other.referralData == referralData)&&const DeepCollectionEquality().equals(other.walletHistory, walletHistory)&&(identical(other.isTermLoading, isTermLoading) || other.isTermLoading == isTermLoading)&&(identical(other.isPolicyLoading, isPolicyLoading) || other.isPolicyLoading == isPolicyLoading)&&(identical(other.policy, policy) || other.policy == policy)&&(identical(other.term, term) || other.term == term)&&const DeepCollectionEquality().equals(other.filepath, filepath)&&const DeepCollectionEquality().equals(other.careers, careers)&&(identical(other.selectedCareer, selectedCareer) || other.selectedCareer == selectedCareer)&&const DeepCollectionEquality().equals(other.blogs, blogs)&&(identical(other.selectBlog, selectBlog) || other.selectBlog == selectBlog)&&const DeepCollectionEquality().equals(other.about, about));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isReferralLoading,isSaveLoading,isLoadingHistory,typeIndex,selectAddress,bgImage,logoImage,addressModel,userData,referralData,const DeepCollectionEquality().hash(walletHistory),isTermLoading,isPolicyLoading,policy,term,const DeepCollectionEquality().hash(filepath),const DeepCollectionEquality().hash(careers),selectedCareer,const DeepCollectionEquality().hash(blogs),selectBlog,const DeepCollectionEquality().hash(about)]);

@override
String toString() {
  return 'ProfileState(isLoading: $isLoading, isReferralLoading: $isReferralLoading, isSaveLoading: $isSaveLoading, isLoadingHistory: $isLoadingHistory, typeIndex: $typeIndex, selectAddress: $selectAddress, bgImage: $bgImage, logoImage: $logoImage, addressModel: $addressModel, userData: $userData, referralData: $referralData, walletHistory: $walletHistory, isTermLoading: $isTermLoading, isPolicyLoading: $isPolicyLoading, policy: $policy, term: $term, filepath: $filepath, careers: $careers, selectedCareer: $selectedCareer, blogs: $blogs, selectBlog: $selectBlog, about: $about)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isReferralLoading, bool isSaveLoading, bool isLoadingHistory, int typeIndex, int selectAddress, String bgImage, String logoImage, AddressNewModel? addressModel, ProfileData? userData, ReferralModel? referralData, List<WalletData>? walletHistory, bool isTermLoading, bool isPolicyLoading, Translation? policy, Translation? term, List<String> filepath, List<CareerData> careers, CareerData? selectedCareer, List<BlogData> blogs, BlogData? selectBlog, List<PageData> about
});




}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isReferralLoading = null,Object? isSaveLoading = null,Object? isLoadingHistory = null,Object? typeIndex = null,Object? selectAddress = null,Object? bgImage = null,Object? logoImage = null,Object? addressModel = freezed,Object? userData = freezed,Object? referralData = freezed,Object? walletHistory = freezed,Object? isTermLoading = null,Object? isPolicyLoading = null,Object? policy = freezed,Object? term = freezed,Object? filepath = null,Object? careers = null,Object? selectedCareer = freezed,Object? blogs = null,Object? selectBlog = freezed,Object? about = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isReferralLoading: null == isReferralLoading ? _self.isReferralLoading : isReferralLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaveLoading: null == isSaveLoading ? _self.isSaveLoading : isSaveLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,typeIndex: null == typeIndex ? _self.typeIndex : typeIndex // ignore: cast_nullable_to_non_nullable
as int,selectAddress: null == selectAddress ? _self.selectAddress : selectAddress // ignore: cast_nullable_to_non_nullable
as int,bgImage: null == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String,logoImage: null == logoImage ? _self.logoImage : logoImage // ignore: cast_nullable_to_non_nullable
as String,addressModel: freezed == addressModel ? _self.addressModel : addressModel // ignore: cast_nullable_to_non_nullable
as AddressNewModel?,userData: freezed == userData ? _self.userData : userData // ignore: cast_nullable_to_non_nullable
as ProfileData?,referralData: freezed == referralData ? _self.referralData : referralData // ignore: cast_nullable_to_non_nullable
as ReferralModel?,walletHistory: freezed == walletHistory ? _self.walletHistory : walletHistory // ignore: cast_nullable_to_non_nullable
as List<WalletData>?,isTermLoading: null == isTermLoading ? _self.isTermLoading : isTermLoading // ignore: cast_nullable_to_non_nullable
as bool,isPolicyLoading: null == isPolicyLoading ? _self.isPolicyLoading : isPolicyLoading // ignore: cast_nullable_to_non_nullable
as bool,policy: freezed == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as Translation?,term: freezed == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as Translation?,filepath: null == filepath ? _self.filepath : filepath // ignore: cast_nullable_to_non_nullable
as List<String>,careers: null == careers ? _self.careers : careers // ignore: cast_nullable_to_non_nullable
as List<CareerData>,selectedCareer: freezed == selectedCareer ? _self.selectedCareer : selectedCareer // ignore: cast_nullable_to_non_nullable
as CareerData?,blogs: null == blogs ? _self.blogs : blogs // ignore: cast_nullable_to_non_nullable
as List<BlogData>,selectBlog: freezed == selectBlog ? _self.selectBlog : selectBlog // ignore: cast_nullable_to_non_nullable
as BlogData?,about: null == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as List<PageData>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isReferralLoading,  bool isSaveLoading,  bool isLoadingHistory,  int typeIndex,  int selectAddress,  String bgImage,  String logoImage,  AddressNewModel? addressModel,  ProfileData? userData,  ReferralModel? referralData,  List<WalletData>? walletHistory,  bool isTermLoading,  bool isPolicyLoading,  Translation? policy,  Translation? term,  List<String> filepath,  List<CareerData> careers,  CareerData? selectedCareer,  List<BlogData> blogs,  BlogData? selectBlog,  List<PageData> about)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isLoading,_that.isReferralLoading,_that.isSaveLoading,_that.isLoadingHistory,_that.typeIndex,_that.selectAddress,_that.bgImage,_that.logoImage,_that.addressModel,_that.userData,_that.referralData,_that.walletHistory,_that.isTermLoading,_that.isPolicyLoading,_that.policy,_that.term,_that.filepath,_that.careers,_that.selectedCareer,_that.blogs,_that.selectBlog,_that.about);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isReferralLoading,  bool isSaveLoading,  bool isLoadingHistory,  int typeIndex,  int selectAddress,  String bgImage,  String logoImage,  AddressNewModel? addressModel,  ProfileData? userData,  ReferralModel? referralData,  List<WalletData>? walletHistory,  bool isTermLoading,  bool isPolicyLoading,  Translation? policy,  Translation? term,  List<String> filepath,  List<CareerData> careers,  CareerData? selectedCareer,  List<BlogData> blogs,  BlogData? selectBlog,  List<PageData> about)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.isLoading,_that.isReferralLoading,_that.isSaveLoading,_that.isLoadingHistory,_that.typeIndex,_that.selectAddress,_that.bgImage,_that.logoImage,_that.addressModel,_that.userData,_that.referralData,_that.walletHistory,_that.isTermLoading,_that.isPolicyLoading,_that.policy,_that.term,_that.filepath,_that.careers,_that.selectedCareer,_that.blogs,_that.selectBlog,_that.about);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isReferralLoading,  bool isSaveLoading,  bool isLoadingHistory,  int typeIndex,  int selectAddress,  String bgImage,  String logoImage,  AddressNewModel? addressModel,  ProfileData? userData,  ReferralModel? referralData,  List<WalletData>? walletHistory,  bool isTermLoading,  bool isPolicyLoading,  Translation? policy,  Translation? term,  List<String> filepath,  List<CareerData> careers,  CareerData? selectedCareer,  List<BlogData> blogs,  BlogData? selectBlog,  List<PageData> about)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isLoading,_that.isReferralLoading,_that.isSaveLoading,_that.isLoadingHistory,_that.typeIndex,_that.selectAddress,_that.bgImage,_that.logoImage,_that.addressModel,_that.userData,_that.referralData,_that.walletHistory,_that.isTermLoading,_that.isPolicyLoading,_that.policy,_that.term,_that.filepath,_that.careers,_that.selectedCareer,_that.blogs,_that.selectBlog,_that.about);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState extends ProfileState {
  const _ProfileState({this.isLoading = false, this.isReferralLoading = true, this.isSaveLoading = false, this.isLoadingHistory = true, this.typeIndex = 0, this.selectAddress = 0, this.bgImage = "", this.logoImage = "", this.addressModel = null, this.userData = null, this.referralData = null, final  List<WalletData>? walletHistory = const [], this.isTermLoading = false, this.isPolicyLoading = false, this.policy = null, this.term = null, final  List<String> filepath = const [], final  List<CareerData> careers = const [], this.selectedCareer = null, final  List<BlogData> blogs = const [], this.selectBlog = null, final  List<PageData> about = const []}): _walletHistory = walletHistory,_filepath = filepath,_careers = careers,_blogs = blogs,_about = about,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isReferralLoading;
@override@JsonKey() final  bool isSaveLoading;
@override@JsonKey() final  bool isLoadingHistory;
@override@JsonKey() final  int typeIndex;
@override@JsonKey() final  int selectAddress;
@override@JsonKey() final  String bgImage;
@override@JsonKey() final  String logoImage;
@override@JsonKey() final  AddressNewModel? addressModel;
@override@JsonKey() final  ProfileData? userData;
@override@JsonKey() final  ReferralModel? referralData;
 final  List<WalletData>? _walletHistory;
@override@JsonKey() List<WalletData>? get walletHistory {
  final value = _walletHistory;
  if (value == null) return null;
  if (_walletHistory is EqualUnmodifiableListView) return _walletHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isTermLoading;
@override@JsonKey() final  bool isPolicyLoading;
@override@JsonKey() final  Translation? policy;
@override@JsonKey() final  Translation? term;
 final  List<String> _filepath;
@override@JsonKey() List<String> get filepath {
  if (_filepath is EqualUnmodifiableListView) return _filepath;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filepath);
}

 final  List<CareerData> _careers;
@override@JsonKey() List<CareerData> get careers {
  if (_careers is EqualUnmodifiableListView) return _careers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_careers);
}

@override@JsonKey() final  CareerData? selectedCareer;
 final  List<BlogData> _blogs;
@override@JsonKey() List<BlogData> get blogs {
  if (_blogs is EqualUnmodifiableListView) return _blogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blogs);
}

@override@JsonKey() final  BlogData? selectBlog;
 final  List<PageData> _about;
@override@JsonKey() List<PageData> get about {
  if (_about is EqualUnmodifiableListView) return _about;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_about);
}


/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isReferralLoading, isReferralLoading) || other.isReferralLoading == isReferralLoading)&&(identical(other.isSaveLoading, isSaveLoading) || other.isSaveLoading == isSaveLoading)&&(identical(other.isLoadingHistory, isLoadingHistory) || other.isLoadingHistory == isLoadingHistory)&&(identical(other.typeIndex, typeIndex) || other.typeIndex == typeIndex)&&(identical(other.selectAddress, selectAddress) || other.selectAddress == selectAddress)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.logoImage, logoImage) || other.logoImage == logoImage)&&(identical(other.addressModel, addressModel) || other.addressModel == addressModel)&&(identical(other.userData, userData) || other.userData == userData)&&(identical(other.referralData, referralData) || other.referralData == referralData)&&const DeepCollectionEquality().equals(other._walletHistory, _walletHistory)&&(identical(other.isTermLoading, isTermLoading) || other.isTermLoading == isTermLoading)&&(identical(other.isPolicyLoading, isPolicyLoading) || other.isPolicyLoading == isPolicyLoading)&&(identical(other.policy, policy) || other.policy == policy)&&(identical(other.term, term) || other.term == term)&&const DeepCollectionEquality().equals(other._filepath, _filepath)&&const DeepCollectionEquality().equals(other._careers, _careers)&&(identical(other.selectedCareer, selectedCareer) || other.selectedCareer == selectedCareer)&&const DeepCollectionEquality().equals(other._blogs, _blogs)&&(identical(other.selectBlog, selectBlog) || other.selectBlog == selectBlog)&&const DeepCollectionEquality().equals(other._about, _about));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isReferralLoading,isSaveLoading,isLoadingHistory,typeIndex,selectAddress,bgImage,logoImage,addressModel,userData,referralData,const DeepCollectionEquality().hash(_walletHistory),isTermLoading,isPolicyLoading,policy,term,const DeepCollectionEquality().hash(_filepath),const DeepCollectionEquality().hash(_careers),selectedCareer,const DeepCollectionEquality().hash(_blogs),selectBlog,const DeepCollectionEquality().hash(_about)]);

@override
String toString() {
  return 'ProfileState(isLoading: $isLoading, isReferralLoading: $isReferralLoading, isSaveLoading: $isSaveLoading, isLoadingHistory: $isLoadingHistory, typeIndex: $typeIndex, selectAddress: $selectAddress, bgImage: $bgImage, logoImage: $logoImage, addressModel: $addressModel, userData: $userData, referralData: $referralData, walletHistory: $walletHistory, isTermLoading: $isTermLoading, isPolicyLoading: $isPolicyLoading, policy: $policy, term: $term, filepath: $filepath, careers: $careers, selectedCareer: $selectedCareer, blogs: $blogs, selectBlog: $selectBlog, about: $about)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isReferralLoading, bool isSaveLoading, bool isLoadingHistory, int typeIndex, int selectAddress, String bgImage, String logoImage, AddressNewModel? addressModel, ProfileData? userData, ReferralModel? referralData, List<WalletData>? walletHistory, bool isTermLoading, bool isPolicyLoading, Translation? policy, Translation? term, List<String> filepath, List<CareerData> careers, CareerData? selectedCareer, List<BlogData> blogs, BlogData? selectBlog, List<PageData> about
});




}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isReferralLoading = null,Object? isSaveLoading = null,Object? isLoadingHistory = null,Object? typeIndex = null,Object? selectAddress = null,Object? bgImage = null,Object? logoImage = null,Object? addressModel = freezed,Object? userData = freezed,Object? referralData = freezed,Object? walletHistory = freezed,Object? isTermLoading = null,Object? isPolicyLoading = null,Object? policy = freezed,Object? term = freezed,Object? filepath = null,Object? careers = null,Object? selectedCareer = freezed,Object? blogs = null,Object? selectBlog = freezed,Object? about = null,}) {
  return _then(_ProfileState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isReferralLoading: null == isReferralLoading ? _self.isReferralLoading : isReferralLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaveLoading: null == isSaveLoading ? _self.isSaveLoading : isSaveLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,typeIndex: null == typeIndex ? _self.typeIndex : typeIndex // ignore: cast_nullable_to_non_nullable
as int,selectAddress: null == selectAddress ? _self.selectAddress : selectAddress // ignore: cast_nullable_to_non_nullable
as int,bgImage: null == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String,logoImage: null == logoImage ? _self.logoImage : logoImage // ignore: cast_nullable_to_non_nullable
as String,addressModel: freezed == addressModel ? _self.addressModel : addressModel // ignore: cast_nullable_to_non_nullable
as AddressNewModel?,userData: freezed == userData ? _self.userData : userData // ignore: cast_nullable_to_non_nullable
as ProfileData?,referralData: freezed == referralData ? _self.referralData : referralData // ignore: cast_nullable_to_non_nullable
as ReferralModel?,walletHistory: freezed == walletHistory ? _self._walletHistory : walletHistory // ignore: cast_nullable_to_non_nullable
as List<WalletData>?,isTermLoading: null == isTermLoading ? _self.isTermLoading : isTermLoading // ignore: cast_nullable_to_non_nullable
as bool,isPolicyLoading: null == isPolicyLoading ? _self.isPolicyLoading : isPolicyLoading // ignore: cast_nullable_to_non_nullable
as bool,policy: freezed == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as Translation?,term: freezed == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as Translation?,filepath: null == filepath ? _self._filepath : filepath // ignore: cast_nullable_to_non_nullable
as List<String>,careers: null == careers ? _self._careers : careers // ignore: cast_nullable_to_non_nullable
as List<CareerData>,selectedCareer: freezed == selectedCareer ? _self.selectedCareer : selectedCareer // ignore: cast_nullable_to_non_nullable
as CareerData?,blogs: null == blogs ? _self._blogs : blogs // ignore: cast_nullable_to_non_nullable
as List<BlogData>,selectBlog: freezed == selectBlog ? _self.selectBlog : selectBlog // ignore: cast_nullable_to_non_nullable
as BlogData?,about: null == about ? _self._about : about // ignore: cast_nullable_to_non_nullable
as List<PageData>,
  ));
}


}

// dart format on
