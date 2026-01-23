// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readName)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readPrice)
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readRating)
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readImage)
  String get image => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readStores)
  int get stores => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readStringList)
  List<String> get badges => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readCategories)
  List<String> get categories => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readStringList)
  List<String> get images => throw _privateConstructorUsedError;
  List<Offer> get offers => throw _privateConstructorUsedError;
  List<PriceHistoryPoint>? get priceHistory =>
      throw _privateConstructorUsedError;
  List<PriceComparison>? get comparisons => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(readValue: _readName) String name,
      @JsonKey(readValue: _readPrice) double price,
      String currency,
      @JsonKey(readValue: _readRating) double rating,
      @JsonKey(readValue: _readImage) String image,
      @JsonKey(readValue: _readStores) int stores,
      String brand,
      @JsonKey(readValue: _readStringList) List<String> badges,
      @JsonKey(readValue: _readCategories) List<String> categories,
      String title,
      String description,
      @JsonKey(readValue: _readStringList) List<String> images,
      List<Offer> offers,
      List<PriceHistoryPoint>? priceHistory,
      List<PriceComparison>? comparisons});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? rating = null,
    Object? image = null,
    Object? stores = null,
    Object? brand = null,
    Object? badges = null,
    Object? categories = null,
    Object? title = null,
    Object? description = null,
    Object? images = null,
    Object? offers = null,
    Object? priceHistory = freezed,
    Object? comparisons = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as int,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      badges: null == badges
          ? _value.badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      offers: null == offers
          ? _value.offers
          : offers // ignore: cast_nullable_to_non_nullable
              as List<Offer>,
      priceHistory: freezed == priceHistory
          ? _value.priceHistory
          : priceHistory // ignore: cast_nullable_to_non_nullable
              as List<PriceHistoryPoint>?,
      comparisons: freezed == comparisons
          ? _value.comparisons
          : comparisons // ignore: cast_nullable_to_non_nullable
              as List<PriceComparison>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(readValue: _readName) String name,
      @JsonKey(readValue: _readPrice) double price,
      String currency,
      @JsonKey(readValue: _readRating) double rating,
      @JsonKey(readValue: _readImage) String image,
      @JsonKey(readValue: _readStores) int stores,
      String brand,
      @JsonKey(readValue: _readStringList) List<String> badges,
      @JsonKey(readValue: _readCategories) List<String> categories,
      String title,
      String description,
      @JsonKey(readValue: _readStringList) List<String> images,
      List<Offer> offers,
      List<PriceHistoryPoint>? priceHistory,
      List<PriceComparison>? comparisons});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? rating = null,
    Object? image = null,
    Object? stores = null,
    Object? brand = null,
    Object? badges = null,
    Object? categories = null,
    Object? title = null,
    Object? description = null,
    Object? images = null,
    Object? offers = null,
    Object? priceHistory = freezed,
    Object? comparisons = freezed,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as int,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      badges: null == badges
          ? _value._badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      offers: null == offers
          ? _value._offers
          : offers // ignore: cast_nullable_to_non_nullable
              as List<Offer>,
      priceHistory: freezed == priceHistory
          ? _value._priceHistory
          : priceHistory // ignore: cast_nullable_to_non_nullable
              as List<PriceHistoryPoint>?,
      comparisons: freezed == comparisons
          ? _value._comparisons
          : comparisons // ignore: cast_nullable_to_non_nullable
              as List<PriceComparison>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl(
      {required this.id,
      @JsonKey(readValue: _readName) required this.name,
      @JsonKey(readValue: _readPrice) required this.price,
      this.currency = '₹',
      @JsonKey(readValue: _readRating) required this.rating,
      @JsonKey(readValue: _readImage) required this.image,
      @JsonKey(readValue: _readStores) required this.stores,
      this.brand = '',
      @JsonKey(readValue: _readStringList) final List<String> badges = const [],
      @JsonKey(readValue: _readCategories)
      final List<String> categories = const [],
      this.title = '',
      this.description = '',
      @JsonKey(readValue: _readStringList) final List<String> images = const [],
      final List<Offer> offers = const [],
      final List<PriceHistoryPoint>? priceHistory,
      final List<PriceComparison>? comparisons})
      : _badges = badges,
        _categories = categories,
        _images = images,
        _offers = offers,
        _priceHistory = priceHistory,
        _comparisons = comparisons;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(readValue: _readName)
  final String name;
  @override
  @JsonKey(readValue: _readPrice)
  final double price;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(readValue: _readRating)
  final double rating;
  @override
  @JsonKey(readValue: _readImage)
  final String image;
  @override
  @JsonKey(readValue: _readStores)
  final int stores;
  @override
  @JsonKey()
  final String brand;
  final List<String> _badges;
  @override
  @JsonKey(readValue: _readStringList)
  List<String> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  final List<String> _categories;
  @override
  @JsonKey(readValue: _readCategories)
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  final List<String> _images;
  @override
  @JsonKey(readValue: _readStringList)
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<Offer> _offers;
  @override
  @JsonKey()
  List<Offer> get offers {
    if (_offers is EqualUnmodifiableListView) return _offers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_offers);
  }

  final List<PriceHistoryPoint>? _priceHistory;
  @override
  List<PriceHistoryPoint>? get priceHistory {
    final value = _priceHistory;
    if (value == null) return null;
    if (_priceHistory is EqualUnmodifiableListView) return _priceHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PriceComparison>? _comparisons;
  @override
  List<PriceComparison>? get comparisons {
    final value = _comparisons;
    if (value == null) return null;
    if (_comparisons is EqualUnmodifiableListView) return _comparisons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, currency: $currency, rating: $rating, image: $image, stores: $stores, brand: $brand, badges: $badges, categories: $categories, title: $title, description: $description, images: $images, offers: $offers, priceHistory: $priceHistory, comparisons: $comparisons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.stores, stores) || other.stores == stores) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            const DeepCollectionEquality().equals(other._badges, _badges) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._offers, _offers) &&
            const DeepCollectionEquality()
                .equals(other._priceHistory, _priceHistory) &&
            const DeepCollectionEquality()
                .equals(other._comparisons, _comparisons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      price,
      currency,
      rating,
      image,
      stores,
      brand,
      const DeepCollectionEquality().hash(_badges),
      const DeepCollectionEquality().hash(_categories),
      title,
      description,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_offers),
      const DeepCollectionEquality().hash(_priceHistory),
      const DeepCollectionEquality().hash(_comparisons));

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String id,
      @JsonKey(readValue: _readName) required final String name,
      @JsonKey(readValue: _readPrice) required final double price,
      final String currency,
      @JsonKey(readValue: _readRating) required final double rating,
      @JsonKey(readValue: _readImage) required final String image,
      @JsonKey(readValue: _readStores) required final int stores,
      final String brand,
      @JsonKey(readValue: _readStringList) final List<String> badges,
      @JsonKey(readValue: _readCategories) final List<String> categories,
      final String title,
      final String description,
      @JsonKey(readValue: _readStringList) final List<String> images,
      final List<Offer> offers,
      final List<PriceHistoryPoint>? priceHistory,
      final List<PriceComparison>? comparisons}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(readValue: _readName)
  String get name;
  @override
  @JsonKey(readValue: _readPrice)
  double get price;
  @override
  String get currency;
  @override
  @JsonKey(readValue: _readRating)
  double get rating;
  @override
  @JsonKey(readValue: _readImage)
  String get image;
  @override
  @JsonKey(readValue: _readStores)
  int get stores;
  @override
  String get brand;
  @override
  @JsonKey(readValue: _readStringList)
  List<String> get badges;
  @override
  @JsonKey(readValue: _readCategories)
  List<String> get categories;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(readValue: _readStringList)
  List<String> get images;
  @override
  List<Offer> get offers;
  @override
  List<PriceHistoryPoint>? get priceHistory;
  @override
  List<PriceComparison>? get comparisons;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Offer _$OfferFromJson(Map<String, dynamic> json) {
  return _Offer.fromJson(json);
}

/// @nodoc
mixin _$Offer {
  @JsonKey(readValue: _readMarketplace)
  String get marketplace => throw _privateConstructorUsedError;
  String get seller => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readOfferPrice)
  double get price => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get discount => throw _privateConstructorUsedError;
  String? get delivery => throw _privateConstructorUsedError;
  bool get isBestPrice => throw _privateConstructorUsedError;

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfferCopyWith<Offer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferCopyWith<$Res> {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) then) =
      _$OfferCopyWithImpl<$Res, Offer>;
  @useResult
  $Res call(
      {@JsonKey(readValue: _readMarketplace) String marketplace,
      String seller,
      @JsonKey(readValue: _readOfferPrice) double price,
      String url,
      String? currency,
      String? discount,
      String? delivery,
      bool isBestPrice});
}

/// @nodoc
class _$OfferCopyWithImpl<$Res, $Val extends Offer>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marketplace = null,
    Object? seller = null,
    Object? price = null,
    Object? url = null,
    Object? currency = freezed,
    Object? discount = freezed,
    Object? delivery = freezed,
    Object? isBestPrice = null,
  }) {
    return _then(_value.copyWith(
      marketplace: null == marketplace
          ? _value.marketplace
          : marketplace // ignore: cast_nullable_to_non_nullable
              as String,
      seller: null == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      isBestPrice: null == isBestPrice
          ? _value.isBestPrice
          : isBestPrice // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfferImplCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$$OfferImplCopyWith(
          _$OfferImpl value, $Res Function(_$OfferImpl) then) =
      __$$OfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(readValue: _readMarketplace) String marketplace,
      String seller,
      @JsonKey(readValue: _readOfferPrice) double price,
      String url,
      String? currency,
      String? discount,
      String? delivery,
      bool isBestPrice});
}

/// @nodoc
class __$$OfferImplCopyWithImpl<$Res>
    extends _$OfferCopyWithImpl<$Res, _$OfferImpl>
    implements _$$OfferImplCopyWith<$Res> {
  __$$OfferImplCopyWithImpl(
      _$OfferImpl _value, $Res Function(_$OfferImpl) _then)
      : super(_value, _then);

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marketplace = null,
    Object? seller = null,
    Object? price = null,
    Object? url = null,
    Object? currency = freezed,
    Object? discount = freezed,
    Object? delivery = freezed,
    Object? isBestPrice = null,
  }) {
    return _then(_$OfferImpl(
      marketplace: null == marketplace
          ? _value.marketplace
          : marketplace // ignore: cast_nullable_to_non_nullable
              as String,
      seller: null == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      discount: freezed == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      isBestPrice: null == isBestPrice
          ? _value.isBestPrice
          : isBestPrice // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OfferImpl implements _Offer {
  const _$OfferImpl(
      {@JsonKey(readValue: _readMarketplace) required this.marketplace,
      this.seller = 'Official Seller',
      @JsonKey(readValue: _readOfferPrice) required this.price,
      this.url = '',
      this.currency,
      this.discount,
      this.delivery,
      this.isBestPrice = false});

  factory _$OfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfferImplFromJson(json);

  @override
  @JsonKey(readValue: _readMarketplace)
  final String marketplace;
  @override
  @JsonKey()
  final String seller;
  @override
  @JsonKey(readValue: _readOfferPrice)
  final double price;
  @override
  @JsonKey()
  final String url;
  @override
  final String? currency;
  @override
  final String? discount;
  @override
  final String? delivery;
  @override
  @JsonKey()
  final bool isBestPrice;

  @override
  String toString() {
    return 'Offer(marketplace: $marketplace, seller: $seller, price: $price, url: $url, currency: $currency, discount: $discount, delivery: $delivery, isBestPrice: $isBestPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfferImpl &&
            (identical(other.marketplace, marketplace) ||
                other.marketplace == marketplace) &&
            (identical(other.seller, seller) || other.seller == seller) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            (identical(other.isBestPrice, isBestPrice) ||
                other.isBestPrice == isBestPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, marketplace, seller, price, url,
      currency, discount, delivery, isBestPrice);

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfferImplCopyWith<_$OfferImpl> get copyWith =>
      __$$OfferImplCopyWithImpl<_$OfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfferImplToJson(
      this,
    );
  }
}

abstract class _Offer implements Offer {
  const factory _Offer(
      {@JsonKey(readValue: _readMarketplace) required final String marketplace,
      final String seller,
      @JsonKey(readValue: _readOfferPrice) required final double price,
      final String url,
      final String? currency,
      final String? discount,
      final String? delivery,
      final bool isBestPrice}) = _$OfferImpl;

  factory _Offer.fromJson(Map<String, dynamic> json) = _$OfferImpl.fromJson;

  @override
  @JsonKey(readValue: _readMarketplace)
  String get marketplace;
  @override
  String get seller;
  @override
  @JsonKey(readValue: _readOfferPrice)
  double get price;
  @override
  String get url;
  @override
  String? get currency;
  @override
  String? get discount;
  @override
  String? get delivery;
  @override
  bool get isBestPrice;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfferImplCopyWith<_$OfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriceComparison _$PriceComparisonFromJson(Map<String, dynamic> json) {
  return _PriceComparison.fromJson(json);
}

/// @nodoc
mixin _$PriceComparison {
  String get store => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readComparisonPrice)
  double get price => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readComparisonNum)
  double? get shipping => throw _privateConstructorUsedError;
  @JsonKey(readValue: _readComparisonNum)
  double? get rating => throw _privateConstructorUsedError;

  /// Serializes this PriceComparison to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceComparisonCopyWith<PriceComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceComparisonCopyWith<$Res> {
  factory $PriceComparisonCopyWith(
          PriceComparison value, $Res Function(PriceComparison) then) =
      _$PriceComparisonCopyWithImpl<$Res, PriceComparison>;
  @useResult
  $Res call(
      {String store,
      @JsonKey(readValue: _readComparisonPrice) double price,
      @JsonKey(readValue: _readComparisonNum) double? shipping,
      @JsonKey(readValue: _readComparisonNum) double? rating});
}

/// @nodoc
class _$PriceComparisonCopyWithImpl<$Res, $Val extends PriceComparison>
    implements $PriceComparisonCopyWith<$Res> {
  _$PriceComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? store = null,
    Object? price = null,
    Object? shipping = freezed,
    Object? rating = freezed,
  }) {
    return _then(_value.copyWith(
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: freezed == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceComparisonImplCopyWith<$Res>
    implements $PriceComparisonCopyWith<$Res> {
  factory _$$PriceComparisonImplCopyWith(_$PriceComparisonImpl value,
          $Res Function(_$PriceComparisonImpl) then) =
      __$$PriceComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String store,
      @JsonKey(readValue: _readComparisonPrice) double price,
      @JsonKey(readValue: _readComparisonNum) double? shipping,
      @JsonKey(readValue: _readComparisonNum) double? rating});
}

/// @nodoc
class __$$PriceComparisonImplCopyWithImpl<$Res>
    extends _$PriceComparisonCopyWithImpl<$Res, _$PriceComparisonImpl>
    implements _$$PriceComparisonImplCopyWith<$Res> {
  __$$PriceComparisonImplCopyWithImpl(
      _$PriceComparisonImpl _value, $Res Function(_$PriceComparisonImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? store = null,
    Object? price = null,
    Object? shipping = freezed,
    Object? rating = freezed,
  }) {
    return _then(_$PriceComparisonImpl(
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      shipping: freezed == shipping
          ? _value.shipping
          : shipping // ignore: cast_nullable_to_non_nullable
              as double?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceComparisonImpl implements _PriceComparison {
  const _$PriceComparisonImpl(
      {required this.store,
      @JsonKey(readValue: _readComparisonPrice) required this.price,
      @JsonKey(readValue: _readComparisonNum) this.shipping,
      @JsonKey(readValue: _readComparisonNum) this.rating});

  factory _$PriceComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceComparisonImplFromJson(json);

  @override
  final String store;
  @override
  @JsonKey(readValue: _readComparisonPrice)
  final double price;
  @override
  @JsonKey(readValue: _readComparisonNum)
  final double? shipping;
  @override
  @JsonKey(readValue: _readComparisonNum)
  final double? rating;

  @override
  String toString() {
    return 'PriceComparison(store: $store, price: $price, shipping: $shipping, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceComparisonImpl &&
            (identical(other.store, store) || other.store == store) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, store, price, shipping, rating);

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceComparisonImplCopyWith<_$PriceComparisonImpl> get copyWith =>
      __$$PriceComparisonImplCopyWithImpl<_$PriceComparisonImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceComparisonImplToJson(
      this,
    );
  }
}

abstract class _PriceComparison implements PriceComparison {
  const factory _PriceComparison(
          {required final String store,
          @JsonKey(readValue: _readComparisonPrice) required final double price,
          @JsonKey(readValue: _readComparisonNum) final double? shipping,
          @JsonKey(readValue: _readComparisonNum) final double? rating}) =
      _$PriceComparisonImpl;

  factory _PriceComparison.fromJson(Map<String, dynamic> json) =
      _$PriceComparisonImpl.fromJson;

  @override
  String get store;
  @override
  @JsonKey(readValue: _readComparisonPrice)
  double get price;
  @override
  @JsonKey(readValue: _readComparisonNum)
  double? get shipping;
  @override
  @JsonKey(readValue: _readComparisonNum)
  double? get rating;

  /// Create a copy of PriceComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceComparisonImplCopyWith<_$PriceComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
