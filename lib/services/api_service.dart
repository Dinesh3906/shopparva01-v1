import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/kit.dart';
import '../core/constants.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        '/products/search',
        queryParameters: {'q': query},
      );

      final data = response.data;
      List<dynamic> results;
      if (data is List) {
        results = data;
      } else if (data is Map<String, dynamic> && data['results'] is List) {
        // Backwards compatibility if the backend ever wraps results.
        results = data['results'] as List<dynamic>;
      } else {
        return [];
      }

      return results
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback/Mock behavior if backend is unreachable
      developer.log('Error searching products: $e', name: 'ApiService.searchProducts');
      return [];
    }
  }

  Future<Product?> getProductComparison(String id) async {
    try {
      final response = await _dio.get(
        '/products/compare',
        queryParameters: {'id': id},
      );
      return Product.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<Kit> generateKit(String type, double budget) async {
    try {
      final response = await _dio.post(
        '/kits/generate',
        data: {
          'type': type,
          'budget': budget,
        },
      );
      return Kit.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Fallback stub
      throw Exception('Failed to generate kit');
    }
  }
}
