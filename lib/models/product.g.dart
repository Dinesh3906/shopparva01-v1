// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: _readId(json, 'id') as String,
      name: _readName(json, 'name') as String,
      price: (_readPrice(json, 'price') as num).toDouble(),
      currency: json['currency'] as String? ?? '₹',
      rating: (_readRating(json, 'rating') as num).toDouble(),
      image: _readImage(json, 'image') as String,
      stores: (_readStores(json, 'stores') as num).toInt(),
      brand: json['brand'] as String? ?? '',
      badges: (_readStringList(json, 'badges') as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categories: (_readCategories(json, 'categories') as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      images: (_readStringList(json, 'images') as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      priceHistory: (json['priceHistory'] as List<dynamic>?)
          ?.map((e) => PriceHistoryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      comparisons: (json['comparisons'] as List<dynamic>?)
          ?.map((e) => PriceComparison.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
      'rating': instance.rating,
      'image': instance.image,
      'stores': instance.stores,
      'brand': instance.brand,
      'badges': instance.badges,
      'categories': instance.categories,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'offers': instance.offers,
      'priceHistory': instance.priceHistory,
      'comparisons': instance.comparisons,
    };

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
      marketplace: _readMarketplace(json, 'marketplace') as String,
      seller: json['seller'] as String? ?? 'Official Seller',
      price: (_readOfferPrice(json, 'price') as num).toDouble(),
      url: json['url'] as String? ?? '',
      currency: json['currency'] as String?,
      discount: json['discount'] as String?,
      delivery: json['delivery'] as String?,
      isBestPrice: json['isBestPrice'] as bool? ?? false,
    );

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'marketplace': instance.marketplace,
      'seller': instance.seller,
      'price': instance.price,
      'url': instance.url,
      'currency': instance.currency,
      'discount': instance.discount,
      'delivery': instance.delivery,
      'isBestPrice': instance.isBestPrice,
    };

_$PriceComparisonImpl _$$PriceComparisonImplFromJson(
        Map<String, dynamic> json) =>
    _$PriceComparisonImpl(
      store: json['store'] as String,
      price: (_readComparisonPrice(json, 'price') as num).toDouble(),
      shipping: (_readComparisonNum(json, 'shipping') as num?)?.toDouble(),
      rating: (_readComparisonNum(json, 'rating') as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PriceComparisonImplToJson(
        _$PriceComparisonImpl instance) =>
    <String, dynamic>{
      'store': instance.store,
      'price': instance.price,
      'shipping': instance.shipping,
      'rating': instance.rating,
    };
