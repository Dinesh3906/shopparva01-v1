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
    this.brand = '',
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
  final String brand;
  final List<String> badges;

  /// Optional: last 30 days of prices for sparkline.
  final List<double>? priceHistory;

  /// Optional: store price comparisons returned from GET /products/:id.
  final List<PriceComparison>? comparisons;

  factory Product.fromJson(Map<String, dynamic> json) {
    // Basic Field Mapping - Safer with toString() fallback for ID
    final String id = json['id']?.toString() ?? 'unknown_${DateTime.now().millisecondsSinceEpoch}';
    final String name = json['title'] as String? ?? json['name'] as String? ?? 'Unknown Product';
    
    // Price extraction - Robust
    double price = 0.0;
    try {
      if (json['offers'] is List && (json['offers'] as List).isNotEmpty) {
        final firstOffer = (json['offers'] as List).first;
        if (firstOffer != null && firstOffer is Map && firstOffer['price'] != null) {
          price = (firstOffer['price'] as num).toDouble();
        }
      } else if (json['price'] != null) {
        price = (json['price'] as num).toDouble();
      }
    } catch (e) {
      print('Error parsing price for $id: $e');
    }

    // Image extraction - Robust
    String image = '';
    try {
      if (json['images'] is List && (json['images'] as List).isNotEmpty) {
        final img = (json['images'] as List).first;
        if (img is String) image = img;
      } else if (json['image'] is String) {
        image = json['image'] as String;
      }
    } catch (e) {
      // Ignore image errors
    }

    // Store count
    int stores = 0;
    if (json['offers'] is List) {
      stores = (json['offers'] as List).length;
    } else {
       stores = (json['stores'] as num?)?.toInt() ?? 0;
    }
    
    // Robust Comparison Parsing
    List<PriceComparison>? comparisons;
    if (json['offers'] is List) {
      comparisons = [];
      for (var e in (json['offers'] as List)) {
        if (e is Map) {
           double? p;
           try { p = (e['price'] as num?)?.toDouble(); } catch(_){}
           if (p != null) {
             comparisons.add(PriceComparison.fromJson({
                'store': e['marketplace'] ?? e['seller'] ?? 'Unknown',
                'price': p,
                'shipping': 0.0,
                'rating': 4.5,
              }));
           }
        }
      }
    } else if (json['price_comparisons'] is List) {
      comparisons = (json['price_comparisons'] as List)
         .whereType<Map<String, dynamic>>()
         .map((e) => PriceComparison.fromJson(e))
         .toList();
    }

    // Robust Price History parsing without crashing on Objects
    List<double>? priceHistory;
    if (json['price_history'] is List) {
       // Only map actual numbers. specific logic for objects could be added if needed,
       // but for now we ensure it doesn't crash on objects.
       priceHistory = (json['price_history'] as List)
          .whereType<num>()
          .map((e) => e.toDouble())
          .toList();
    }

    return Product(
      id: id,
      name: name,
      price: price,
      brand: (json['brand'] as String?) ?? 'Brand',
      currency: (json['currency'] as String?) ?? '₹',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      image: image,
      stores: stores,
      badges: (json['badges'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      priceHistory: priceHistory,
      comparisons: comparisons,
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
        'brand': brand,
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
