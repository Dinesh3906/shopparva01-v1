import 'package:meta/meta.dart';

@immutable
class ProductDeal {
  const ProductDeal({
    required this.productId,
    required this.modelName,
    required this.brand,
    required this.category,
    required this.rating,
    required this.image,
    required this.deals,
  });

  final String productId;
  final String modelName;
  final String brand;
  final String category;
  final double rating;
  final String image;
  final List<DealOffer> deals;

  factory ProductDeal.fromJson(Map<String, dynamic> json) {
    // Robust image extraction
    String image = json['image'] as String? ?? '';
    if (image.isEmpty && json['images'] is List && (json['images'] as List).isNotEmpty) {
      image = (json['images'] as List).first.toString();
    }

    // Robust deals mapping
    final list = (json['deals'] as List? ?? json['offers'] as List?);
    final deals = list != null
        ? list.map((e) => DealOffer.fromJson(e as Map<String, dynamic>)).toList()
        : <DealOffer>[];

    return ProductDeal(
      productId: json['productId']?.toString() ?? json['id']?.toString() ?? '',
      modelName: json['modelName'] as String? ?? json['title'] as String? ?? 'Unknown Product',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      image: image,
      deals: deals,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'modelName': modelName,
        'brand': brand,
        'category': category,
        'rating': rating,
        'image': image,
        'deals': deals.map((e) => e.toJson()).toList(),
      };
}

@immutable
class DealOffer {
  const DealOffer({
    required this.platform,
    required this.seller,
    required this.price,
    required this.currency,
    this.url,
    this.isBestPrice = false,
    this.delivery,
    this.discount,
  });

  final String platform;
  final String seller;
  final double price;
  final String currency;
  final String? url;
  final bool isBestPrice;
  final String? delivery;
  final String? discount;

  factory DealOffer.fromJson(Map<String, dynamic> json) {
    return DealOffer(
      platform: json['platform'] as String? ?? json['marketplace'] as String? ?? 'Unknown',
      seller: json['seller'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? '₹',
      url: json['url'] as String?,
      isBestPrice: json['isBestPrice'] as bool? ?? json['isBest'] as bool? ?? false,
      delivery: json['delivery'] as String?,
      discount: json['discount'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'seller': seller,
        'price': price,
        'currency': currency,
        if (url != null) 'url': url,
        'isBestPrice': isBestPrice,
        if (delivery != null) 'delivery': delivery,
        if (discount != null) 'discount': discount,
      };
}
