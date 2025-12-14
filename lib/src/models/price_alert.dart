import 'package:meta/meta.dart';

@immutable
class PriceAlert {
  const PriceAlert({
    required this.id,
    required this.productId,
    required this.productName,
    required this.targetPrice,
    required this.currentPrice,
    required this.createdAt,
    this.isActive = true,
  });

  final String id;
  final String productId;
  final String productName;
  final double targetPrice;
  final double currentPrice;
  final DateTime createdAt;
  final bool isActive;

  bool get isTriggered => currentPrice <= targetPrice;
  
  double get savingsPercentage => 
      ((currentPrice - targetPrice) / currentPrice * 100).abs();

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      targetPrice: (json['targetPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'productName': productName,
        'targetPrice': targetPrice,
        'currentPrice': currentPrice,
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
      };

  PriceAlert copyWith({
    String? id,
    String? productId,
    String? productName,
    double? targetPrice,
    double? currentPrice,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return PriceAlert(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      targetPrice: targetPrice ?? this.targetPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
