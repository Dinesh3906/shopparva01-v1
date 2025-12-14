import 'package:meta/meta.dart';

@immutable
class PriceHistoryPoint {
  const PriceHistoryPoint({
    required this.date,
    required this.price,
    this.isLowest = false,
    this.isHighest = false,
  });

  final DateTime date;
  final double price;
  final bool isLowest;
  final bool isHighest;

  factory PriceHistoryPoint.fromJson(Map<String, dynamic> json) {
    return PriceHistoryPoint(
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toDouble(),
      isLowest: json['isLowest'] as bool? ?? false,
      isHighest: json['isHighest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'price': price,
        'isLowest': isLowest,
        'isHighest': isHighest,
      };

  PriceHistoryPoint copyWith({
    DateTime? date,
    double? price,
    bool? isLowest,
    bool? isHighest,
  }) {
    return PriceHistoryPoint(
      date: date ?? this.date,
      price: price ?? this.price,
      isLowest: isLowest ?? this.isLowest,
      isHighest: isHighest ?? this.isHighest,
    );
  }
}
