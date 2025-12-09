import 'package:meta/meta.dart';

@immutable
class KitItem {
  const KitItem({
    required this.id,
    required this.name,
    required this.price,
    this.preference,
    this.image,
  });

  final String id;
  final String name;
  final double price;
  final String? preference;
  final String? image;

  factory KitItem.fromJson(Map<String, dynamic> json) {
    return KitItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      preference: json['preference'] as String?,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        if (preference != null) 'preference': preference,
        if (image != null) 'image': image,
      };
}

@immutable
class Kit {
  const Kit({
    required this.id,
    required this.category,
    required this.items,
    required this.totalPrice,
  });

  final String id;
  final String category;
  final List<KitItem> items;
  final double totalPrice;

  factory Kit.fromJson(Map<String, dynamic> json) {
    return Kit(
      id: (json['kitId'] ?? json['id']) as String,
      category: (json['category'] as String?) ?? '',
      items: (json['items'] as List<dynamic>)
          .map((e) => KitItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'kitId': id,
        'category': category,
        'items': items.map((e) => e.toJson()).toList(),
        'totalPrice': totalPrice,
      };
}
