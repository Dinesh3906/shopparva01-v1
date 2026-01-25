// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import '../src/models/price_history_point.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    @JsonKey(readValue: _readName) required String name,
    @JsonKey(readValue: _readPrice) required double price,
    @Default('₹') String currency,
    @JsonKey(readValue: _readRating) required double rating,
    @JsonKey(readValue: _readImage) required String image,
    @JsonKey(readValue: _readStores) required int stores,
    @Default('') String brand,
    @JsonKey(readValue: _readStringList) @Default([]) List<String> badges,
    @JsonKey(readValue: _readCategories) @Default([]) List<String> categories,
    @Default('') String title,
    @Default('') String description,
    @JsonKey(readValue: _readStringList) @Default([]) List<String> images,
    @Default([]) List<Offer> offers,
    List<PriceHistoryPoint>? priceHistory,
    List<PriceComparison>? comparisons,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

Object? _readName(Map json, String key) => json['name'] ?? json['title'] ?? 'Unknown';

Object? _readPrice(Map json, String key) {
  final val = json['price'];
  if (val != null) return _toDouble(val);
  
  final offers = json['offers'] as List?;
  if (offers != null && offers.isNotEmpty) {
    return _toDouble(offers.first['price']);
  }
  return 0.0;
}

Object? _readImage(Map json, String key) {
  if (json['image'] != null && json['image'] != "") return json['image'].toString();
  final images = json['images'] as List?;
  if (images != null && images.isNotEmpty) {
    return images.first.toString();
  }
  return 'https://via.placeholder.com/150';
}

Object? _readStores(Map json, String key) {
  final val = json['stores'];
  if (val != null) return _toInt(val);
  final offers = json['offers'] as List?;
  return offers?.length ?? 0;
}

Object? _readRating(Map json, String key) {
  final val = json['rating'];
  if (val != null) return _toDouble(val);
  return 0.0;
}

double _toDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString()) ?? 0.0;
}

int _toInt(dynamic val) {
  if (val == null) return 0;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString()) ?? 0;
}

Object? _readCategories(Map json, String key) {
  final val = json['categories'] ?? json['category'];
  if (val == null) return [];
  if (val is List) return val.map((e) => e.toString()).toList();
  return [val.toString()];
}

Object? _readStringList(Map json, String key) {
  final val = json[key];
  if (val == null) return [];
  if (val is List) return val.map((e) => e.toString()).toList();
  return [val.toString()];
}

@freezed
class Offer with _$Offer {
  const factory Offer({
    @JsonKey(readValue: _readMarketplace) required String marketplace,
    @Default('Official Seller') String seller,
    @JsonKey(readValue: _readOfferPrice) required double price,
    @Default('') String url,
    String? currency,
    String? discount,
    String? delivery,
    @Default(false) bool isBestPrice,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

Object? _readMarketplace(Map json, String key) {
  return json['marketplace'] ?? json['platform'] ?? json['store'] ?? 'Unknown Store';
}

Object? _readOfferPrice(Map json, String key) => _toDouble(json['price']);

@freezed
class PriceComparison with _$PriceComparison {
  const factory PriceComparison({
    required String store,
    @JsonKey(readValue: _readComparisonPrice) required double price,
    @JsonKey(readValue: _readComparisonNum) double? shipping,
    @JsonKey(readValue: _readComparisonNum) double? rating,
  }) = _PriceComparison;

  factory PriceComparison.fromJson(Map<String, dynamic> json) => _$PriceComparisonFromJson(json);
}

Object? _readComparisonPrice(Map json, String key) => _toDouble(json['price']);
Object? _readComparisonNum(Map json, String key) => json[key] != null ? _toDouble(json[key]) : null;
