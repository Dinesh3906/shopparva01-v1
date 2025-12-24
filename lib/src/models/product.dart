import 'package:meta/meta.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.currency = ' ',
    required this.rating,
    required this.image,
    required this.stores,
    this.badges = const [],
    this.priceHistory,
    this.comparisons,
  });

  final String id;
  final String name;
  final double price;
  final String currency;
  final double rating;
  final String image;
  final int stores;
  final List<String> badges;

  /// Optional: last 30 days of prices for sparkline.
  final List<double>? priceHistory;

  /// Optional: store price comparisons returned from GET /products/:id.
  final List<PriceComparison>? comparisons;

  factory Product.fromJson(Map<String, dynamic> json) {
    // Basic Field Mapping
    final String name = json['title'] as String? ?? json['name'] as String? ?? 'Unknown Product';
    
    // Price extraction
    double price = 0.0;
    if (json['offers'] is List && (json['offers'] as List).isNotEmpty) {
      final firstOffer = (json['offers'] as List).first;
      price = (firstOffer['price'] as num).toDouble();
    } else if (json['price'] != null) {
      price = (json['price'] as num).toDouble();
    }

    // Image extraction
    String image = '';
    if (json['images'] is List && (json['images'] as List).isNotEmpty) {
      image = (json['images'] as List).first as String;
    } else if (json['image'] is String) {
      image = json['image'] as String;
    }

    // Store count
    int stores = 0;
    if (json['offers'] is List) {
      stores = (json['offers'] as List).length;
    } else {
       stores = (json['stores'] as num?)?.toInt() ?? 0;
    }

    return Product(
      id: json['id'] as String,
      name: name,
      price: price,
      currency: (json['currency'] as String?) ?? '\$',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      image: image,
      stores: stores,
      badges: (json['badges'] as List?)?.cast<String>() ?? const [],
      priceHistory: (json['price_history'] is List)
          ? (json['price_history'] as List).map((e) => (e as num).toDouble()).toList()
          : null,
      comparisons: (json['offers'] is List)
          ? (json['offers'] as List).map((e) => PriceComparison.fromJson({
                'store': e['marketplace'] ?? e['seller'] ?? 'Unknown',
                'price': e['price'],
                'shipping': 0.0,
                'rating': 4.5, // Mock rating
              }))
          .toList()
          : (json['price_comparisons'] is List)
              ? (json['price_comparisons'] as List).map((e) => PriceComparison.fromJson(e as Map<String, dynamic>)).toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'currency': currency,
        'rating': rating,
        'image': image,
        'stores': stores,
        'badges': badges,
        if (priceHistory != null) 'price_history': priceHistory,
        if (comparisons != null)
          'price_comparisons': comparisons!.map((e) => e.toJson()).toList(),
      };
}

class PriceComparison {
  const PriceComparison({
    required this.store,
    required this.price,
    this.shipping,
    this.rating,
  });

  final String store;
  final double price;
  final double? shipping;
  final double? rating;

  factory PriceComparison.fromJson(Map<String, dynamic> json) {
    return PriceComparison(
      store: json['store'] as String,
      price: (json['price'] as num).toDouble(),
      shipping: (json['shipping'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'store': store,
        'price': price,
        if (shipping != null) 'shipping': shipping,
        if (rating != null) 'rating': rating,
      };
}
