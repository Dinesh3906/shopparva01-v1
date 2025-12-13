import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client.dart';
import '../models/product.dart';

class ProductRepository {
  ProductRepository(this._client);

  final ApiClient _client;

  final Map<String, Product> _productCache = {};

  Future<Map<String, dynamic>> getFiltersMeta() async {
    final Response<dynamic> response =
        await _client.dio.get('/filters/meta');
    return response.data as Map<String, dynamic>;
  }

  Future<List<Product>> getProducts({
    String? query,
    String? category,
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) async {
    final params = <String, dynamic>{
      'q': query ?? '',
      if (category != null && category.isNotEmpty) 'category': category,
      // Backend doesn't support pagination yet, but keeping params for future
    };

    final Response<dynamic> response =
        await _client.dio.get('/products/search', queryParameters: params);

    // Backend returns a direct List<dynamic>
    final List<dynamic> items = response.data as List<dynamic>;

    final products = items
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();

    for (final p in products) {
      _productCache[p.id] = p;
    }

    return products;
  }

  Future<Product> getProductById(String id) async {
    if (_productCache.containsKey(id)) return _productCache[id]!;

    final Response<dynamic> response =
        await _client.dio.get('/products/$id');
    final product = Product.fromJson(response.data as Map<String, dynamic>);
    _productCache[id] = product;
    return product;
  }

  Future<void> trackProduct({required String productId, required String userId}) async {
    await _client.dio.post('/track', data: {
      'productId': productId,
      'userId': userId,
    });

    // Persist locally as part of price tracker.
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    if (!tracked.contains(productId)) {
      await prefs.setStringList('tracked_products', [...tracked, productId]);
    }
  }

  Future<List<Product>> getTrackedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    if (tracked.isEmpty) return [];

    final results = <Product>[];
    for (final id in tracked) {
      try {
        results.add(await getProductById(id));
      } catch (_) {
        // ignore individual failures
      }
    }
    return results;
  }
}
