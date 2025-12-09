import 'package:meta/meta.dart';

@immutable
class ArAsset {
  const ArAsset({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.assetUrl,
  });

  final String id;
  final String name;
  final String thumbnailUrl;
  final String assetUrl;

  factory ArAsset.fromJson(Map<String, dynamic> json) {
    return ArAsset(
      id: json['id'] as String,
      name: json['name'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      assetUrl: json['asset'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'thumbnail': thumbnailUrl,
        'asset': assetUrl,
      };
}
