import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:shopparva/services/api_service.dart';
import 'package:shopparva/core/constants.dart';

// Simple Mock Adapter for Dio
class MockAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    print('DEBUG: MockAdapter fetching ${options.path}');
    String responseData = '';
    
    if (options.path.contains('escuelajs.co')) {
      responseData = jsonEncode([
        {'id': 1, 'title': 'Mock Platzi Product', 'price': 100, 'images': ['https://via.placeholder.com/150']}
      ]);
    } else if (options.path.contains('makeup-api')) {
      responseData = jsonEncode([
        {'id': 1, 'name': 'Mock Makeup', 'price': '10.5', 'image_link': 'https://via.placeholder.com/150', 'brand': 'maybelline'}
      ]);
    } else if (options.path.contains('frankfurter.app')) {
      responseData = jsonEncode({
        'base': 'USD',
        'rates': {'INR': 83.5, 'EUR': 0.92}
      });
    } else if (options.path.contains('dummyjson.com')) {
      responseData = jsonEncode({
        'products': [
          {'id': 1, 'title': 'Mock Dummy Product', 'price': 500}
        ]
      });
    }

    return ResponseBody.fromString(
      responseData,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('ApiService Integration Tests (Mocked)', () {
    late ApiService apiService;
    late Dio dio;

    setUp(() {
      dio = Dio();
      dio.httpClientAdapter = MockAdapter();
      apiService = ApiService(dio: dio, isTest: true);
    });

    test('fetchPlatziProducts maps correctly', () async {
      final products = await apiService.fetchPlatziProducts();
      expect(products, isNotEmpty);
      expect(products.first.name, equals('Mock Platzi Product'));
    });

    test('fetchBeautyProducts maps correctly', () async {
      final products = await apiService.fetchBeautyProducts(brand: 'maybelline');
      expect(products, isNotEmpty);
      expect(products.first.brand, equals('maybelline'));
    });

    test('fetchExchangeRates maps correctly', () async {
      final rates = await apiService.fetchExchangeRates();
      expect(rates, contains('INR'));
      expect(rates['INR'], equals(83.5));
    });

    test('fetchDummyProducts maps correctly', () async {
      final products = await apiService.fetchDummyProducts();
      expect(products, isNotEmpty);
      expect(products.first.price, equals(500.0));
    });
  });
}
