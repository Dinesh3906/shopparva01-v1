
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
      _allLocalProducts = await compute(parseProducts, jsonString);
      
      for (final p in _allLocalProducts!) {
        _productCache[p.id] = p;
      }
    } catch (e) {
      debugPrint('Error loading local products: $e');
      _allLocalProducts = [];
      rethrow; // Propagate error for debugging
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
      debugPrint('Error fetching product $id: $e');
      throw Exception('Product Not Found Locally or Remotely');
    }
  }

  Future<void> trackProduct({required String productId, required String userId, Product? product}) async {
    // Offline mode: Save to SharedPreferences with full product data if available
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    
    if (!tracked.contains(productId)) {
      await prefs.setStringList('tracked_products', [...tracked, productId]);
    }

    // Cache the full product data if provided, to support offline viewing
    if (product != null) {
      final cacheKey = 'product_cache_$productId';
      await prefs.setString(cacheKey, jsonEncode(product.toJson()));
    }
  }

  Future<void> untrackProduct(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    tracked.remove(productId);
    await prefs.setStringList('tracked_products', tracked);
    
    // Clean up cache
    await prefs.remove('product_cache_$productId');
  }

  Future<List<Product>> getTrackedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final tracked = prefs.getStringList('tracked_products') ?? <String>[];
    if (tracked.isEmpty) return [];

    await _ensureLocalProductsLoaded();
    
    final results = <Product>[];
    for (final id in tracked) {
      try {
        // 1. Try memory cache first
        if (_productCache.containsKey(id)) {
          results.add(_productCache[id]!);
          continue;
        }

        // 2. Try local assets (pre-loaded into _productCache or _allLocalProducts)
        // _ensureLocalProductsLoaded puts them in _productCache, so step 1 handles it.
        // But double check _allLocalProducts just in case
        final localMatch = _allLocalProducts?.where((p) => p.id == id).firstOrNull;
        if (localMatch != null) {
             results.add(localMatch);
             continue;
        }

        // 3. Try offline persistent cache
        final cacheKey = 'product_cache_$id';
        final cachedJson = prefs.getString(cacheKey);
        if (cachedJson != null) {
          try {
             final p = Product.fromJson(jsonDecode(cachedJson));
             _productCache[id] = p; // update mem cache
             results.add(p);
             continue;
          } catch (e) {
             debugPrint('Error parsing cached product $id: $e');
          }
        }
        
        // 4. Finally try Network
        // Only if we haven't found it yet.
        final product = await getProductById(id);
        results.add(product);
        
        // Update persistent cache on successful fetch
         await prefs.setString(cacheKey, jsonEncode(product.toJson()));

      } catch (e) {
        debugPrint('Error loading tracked product $id: $e');
        // If everything fails, we can't show this product.
      }
    }
    return results;
  }

  /// NEW: Track an external product from Amazon, Flipkart, etc.
  Future<Map<String, dynamic>> trackExternalProduct({required String url, required String userId}) async {
    try {
      final response = await _client.dio.post('/track-product', data: {
        'url': url,
        'userId': userId,
      });
      
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        // Optionally save to local tracked list if needed
        // Check if `product` is in data, otherwise use `trackProduct` without the object
        // NOTE: trackExternalProduct returns { success: true, product: {...} }
        final productMap = data['product'] as Map<String, dynamic>;
        final newProduct = Product.fromJson(productMap);
        
        await trackProduct(productId: newProduct.id, userId: userId, product: newProduct);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Tracking failed');
      }
    } catch (e) {
      debugPrint('Error tracking external product: $e');
      rethrow;
    }
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

// Top-level function for compute
List<Product> parseProducts(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList
      .map((item) => Product.fromJson(item as Map<String, dynamic>))
      .toList();
}
