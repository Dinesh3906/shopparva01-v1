import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:shopparva/models/product.dart';
import 'package:shopparva/models/kit.dart';
import 'package:shopparva/core/constants.dart';
import 'package:shopparva/core/secrets.dart';

class ApiService {
  final Dio _dio;
  final bool _isTest;

  ApiService({Dio? dio, bool isTest = false}) 
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl)),
        _isTest = isTest;

  Future<List<Product>> searchProducts(String query, {Map<String, dynamic>? filters}) async {
    try {
      final queryParams = <String, dynamic>{'q': query};
      if (filters != null) {
        queryParams.addAll(filters);
      }
      
      final response = await _dio.get(
        '/products/search',
        queryParameters: queryParams,
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

  Future<List<Product>> fetchFakeStoreProducts() async {
    try {
      final response = await Dio().get(AppConstants.fakeStoreApiUrl);
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error fetching Fake Store products: $e', name: 'ApiService.fetchFakeStoreProducts');
      return [];
    }
  }

  Future<Product?> fetchFakeStoreProductById(int id) async {
    try {
      final response = await Dio().get('${AppConstants.fakeStoreApiUrl}/$id');
      return Product.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      developer.log('Error fetching Fake Store product $id: $e', name: 'ApiService.fetchFakeStoreProductById');
      return null;
    }
  }

  Future<List<Product>> fetchRapidAPIProducts(String category) async {
    try {
      final response = await Dio().get(
        '${AppConstants.rapidApiBaseUrl}/$category',
        options: Options(
          headers: {
            'x-rapidapi-key': AppConstants.rapidApiKey,
            'x-rapidapi-host': AppConstants.rapidApiHost,
          },
        ),
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error fetching RapidAPI products ($category): $e', name: 'ApiService.fetchRapidAPIProducts');
      return [];
    }
  }

  // --- NEW PUBLIC/NO-AUTH APIS ---

  Future<List<Product>> fetchPlatziProducts() async {
    try {
      final response = await _dio.get(AppConstants.platziBaseUrl);
      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      final List<dynamic> results = data;
      return results.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error fetching Platzi products: $e', name: 'ApiService.fetchPlatziProducts');
      return [];
    }
  }

  Future<List<Product>> fetchBeautyProducts({String? brand}) async {
    try {
      final url = brand != null 
          ? '${AppConstants.makeupBaseUrl}?brand=$brand' 
          : AppConstants.makeupBaseUrl;
      final response = await _dio.get(url);
      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      final List<dynamic> results = data;
      return results.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error fetching Makeup products: $e', name: 'ApiService.fetchBeautyProducts');
      return [];
    }
  }

  Future<List<Product>> fetchGroceries(String query) async {
    try {
      final response = await _dio.get(
        AppConstants.openFoodFactsBaseUrl,
        queryParameters: {
          'search_terms': query,
          'json': 1,
          'page_size': 20,
        },
      );
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      final List<dynamic> products = data['products'] ?? [];
      return products.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error fetching Open Food Facts: $e', name: 'ApiService.fetchGroceries');
      return [];
    }
  }

  Future<Map<String, double>> fetchExchangeRates({String base = 'USD'}) async {
    try {
      final response = await _dio.get('${AppConstants.frankfurterBaseUrl}/latest', queryParameters: {'from': base});
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      final rates = Map<String, dynamic>.from(data['rates']);
      return rates.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (e) {
      developer.log('Error fetching Exchange Rates: $e', name: 'ApiService.fetchExchangeRates');
      return {'INR': 83.0, 'EUR': 0.92}; // Fallback
    }
  }

  // --- NEW AUTH-REQUIRED APIS (STUBS/MOCKS) ---

  Future<List<Product>> fetchDummyProducts() async {
    try {
      final response = await _dio.get(AppConstants.dummyProductsBaseUrl);
      var data = response.data;
      if (data is String) data = jsonDecode(data);
      final List<dynamic> products = data['products'] ?? [];
      return products.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error fetching Dummy Products: $e', name: 'ApiService.fetchDummyProducts');
      return [];
    }
  }

  // --- AUTH-REQUIRED API SCROLLING (STUBS) ---

  Future<List<Product>> fetchBestBuyProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.bestBuyBaseUrl + '/products(search=$query)',
      {'apiKey': Secrets.bestBuyApiKey},
      'Best Buy',
    );
  }

  Future<List<Product>> fetchEbayProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.ebayBaseUrl + '/buy/browse/v1/item_summary/search',
      {'Authorization': 'Bearer ${Secrets.ebayToken}'},
      'eBay',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchEtsyProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.etsyBaseUrl + '/application/listings/active',
      {'x-api-key': Secrets.etsyToken},
      'Etsy',
      queryParams: {'keywords': query},
    );
  }

  Future<List<Product>> fetchWooCommerceProducts() async {
    return _fetchWithAuth(
      AppConstants.wooCommerceBaseUrl + '/products',
      {'Authorization': 'Basic ${Secrets.wooCommerceApiKey}'},
      'WooCommerce',
    );
  }

  Future<List<Product>> fetchFlipkartProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.flipkartBaseUrl + '/v1/search',
      {'Authorization': 'Bearer ${Secrets.flipkartToken}'},
      'Flipkart',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchLazadaProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.lazadaBaseUrl + '/products/search',
      {'apiKey': Secrets.lazadaApiKey},
      'Lazada',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchMercadolibreProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.mercadolibreBaseUrl + '/sites/MLA/search',
      {'apiKey': Secrets.mercadolibreApiKey},
      'Mercadolibre',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchOctopartProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.octopartBaseUrl + '/parts/search',
      {'apiKey': Secrets.octopartApiKey},
      'Octopart',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchOlxPolandProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.olxPolandBaseUrl + '/targeting/all-params',
      {'apiKey': Secrets.olxPolandApiKey},
      'OLX Poland',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchRappiProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.rappiBaseUrl + '/v2/search',
      {'Authorization': 'Bearer ${Secrets.rappiToken}'},
      'Rappi',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchShopeeProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.shopeeBaseUrl + '/product/get_item_list',
      {'apiKey': Secrets.shopeeApiKey},
      'Shopee',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchTokopediaProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.tokopediaBaseUrl + '/inventory/v1/fs/search',
      {'Authorization': 'Bearer ${Secrets.tokopediaToken}'},
      'Tokopedia',
      queryParams: {'q': query},
    );
  }

  Future<List<Product>> fetchDigiKeyProducts(String query) async {
    return _fetchWithAuth(
      AppConstants.digiKeyBaseUrl + '/Search/v3/Products',
      {'Authorization': 'Bearer ${Secrets.digiKeyToken}'},
      'Digi-Key',
      queryParams: {'q': query},
    );
  }

  // Generic helper for auth-required APIs
  Future<List<Product>> _fetchWithAuth(
    String url, 
    Map<String, String> headers, 
    String sourceName, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      if (headers.values.any((v) => v.startsWith('YOUR_'))) {
        developer.log('Missing API Key for $sourceName', name: 'ApiService._fetchWithAuth');
        return [];
      }
      final response = await _dio.get(
        url,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );
      final List<dynamic> data = response.data is List ? response.data : (response.data['items'] ?? response.data['products'] ?? []);
      return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error fetching from $sourceName: $e', name: 'ApiService._fetchWithAuth');
      return [];
    }
  }
}
