
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client.dart';
import 'package:shopparva/models/product.dart';
import '../models/product_deal.dart';

class ProductRepository {
  ProductRepository(this._client);

  final ApiClient _client;

  final Map<String, Product> _productCache = {};
  List<Product>? _allLocalProducts;

  Future<void> _ensureLocalProductsLoaded() async {
    if (_allLocalProducts != null) return;
    try {
      final jsonString = await rootBundle.loadString('assets/products.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _allLocalProducts = jsonList
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      
      for (final p in _allLocalProducts!) {
        _productCache[p.id] = p;
      }
    } catch (e) {
      print('Error loading local products: $e');
      _allLocalProducts = [];
    }
  }

  Future<Map<String, dynamic>> getFiltersMeta() async {
    // Return mock filters for offline mode
    return {
      'categories': ['Fashion', 'Electronics', 'Sports', 'Beauty', 'Essentials'],
      'brands': _allLocalProducts?.map((p) => p.brand).toSet().toList() ?? [],
    };
  }

  Future<List<Product>> getProducts({
    String? query,
    String? category,
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? filters,
  }) async {
    await _ensureLocalProductsLoaded();
    
    var filtered = _allLocalProducts!;

    // 1. Filter by Query
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(q) ||
               p.brand.toLowerCase().contains(q) ||
               p.description.toLowerCase().contains(q) ||
               p.categories.any((c) => c.toLowerCase().contains(q));
      }).toList();
    }

    // 2. Filter by Category
    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((p) => p.categories.any((c) => c.toLowerCase() == category.toLowerCase())).toList();
    }

    // 3. Simple pagination (optional)
    // final startIndex = (page - 1) * limit;
    // if (startIndex >= filtered.length) return [];
    // final endIndex = (startIndex + limit).clamp(0, filtered.length);
    // return filtered.sublist(startIndex, endIndex);
    
    return filtered;
  }

  Future<Product> getProductById(String id) async {
    if (_productCache.containsKey(id)) return _productCache[id]!;
    
    await _ensureLocalProductsLoaded();
    
    Product? localProduct;
    try {
      localProduct = _allLocalProducts?.firstWhere((p) => p.id == id);
    } catch (_) {
      // Not found locally
    }
    
    if (localProduct != null) {
      _productCache[id] = localProduct;
      return localProduct;
    }

    // Fallback to network if strictly needed, but mainly relying on offline for this build
    try {
      final Response<dynamic> response =
          await _client.dio.get('/products/$id');
      final p = Product.fromJson(response.data as Map<String, dynamic>);
      _productCache[id] = p;
      return p;
    } catch (e) {
      print('Error fetching product $id: $e');
      throw Exception('Product Not Found Locally or Remotely');
    }
  }

  Future<void> trackProduct({required String productId, required String userId}) async {
    // Offline mode: Just save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    if (!tracked.contains(productId)) {
      await prefs.setStringList('tracked_products', [...tracked, productId]);
    }
  }

  Future<void> untrackProduct(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    tracked.remove(productId);
    await prefs.setStringList('tracked_products', tracked);
  }

  Future<List<Product>> getTrackedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    if (tracked.isEmpty) return [];

    await _ensureLocalProductsLoaded();
    
    final results = <Product>[];
    for (final id in tracked) {
      try {
        final product = await getProductById(id);
        results.add(product);
      } catch (e) {
        print('Error loading tracked product $id: $e');
      }
    }
    return results;
  }

  /// Search for product deals with price comparison across platforms
  Future<List<ProductDeal>> searchForDeals(String query, {Map<String, dynamic>? filters}) async {
    // For offline mode, just return products wrapped as deals
    // In real app, this might have different logic
    final products = await getProducts(query: query, filters: filters);
    
    return products.map((p) {
      final deals = p.offers.map((o) => DealOffer(
        platform: o.marketplace,
        seller: o.seller,
        price: o.price,
        currency: o.currency ?? '₹',
        url: o.url,
        isBestPrice: o.isBestPrice,
        delivery: o.delivery,
        discount: o.discount,
      )).toList();
      
      if (deals.isEmpty) {
        deals.add(DealOffer(
          platform: 'Store',
          seller: 'Official',
          price: p.price,
          currency: p.currency,
        ));
      }

      return ProductDeal(
        productId: p.id,
        modelName: p.name,
        brand: p.brand,
        category: p.categories.isNotEmpty ? p.categories.first : 'General',
        rating: p.rating,
        image: p.image,
        deals: deals,
      );
    }).toList();
  }
}
