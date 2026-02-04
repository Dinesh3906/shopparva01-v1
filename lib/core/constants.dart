import 'package:flutter/foundation.dart' show kIsWeb;
import 'secrets.dart';

class AppConstants {
  static const String appName = 'ShopParva';
  static const String geminiApiKey = 'AIzaSyDK53ZnkAFQWEREVAtm6jIeJkHa8yfQvBk';
  static const String currencySymbol = '₹';
  // Base URL points at the mock backend API root so that
  // ApiService paths like `/products/search` become
  // `http://localhost:3000/api/v1/products/search`.
  // For web, use localhost. For Android emulator, change to 'http://10.0.2.2:3000/api/v1'
  static const String apiBaseUrl = kIsWeb 
      ? 'http://localhost:3000/api/v1'  // Web (Chrome)
      : 'http://10.0.2.2:3000/api/v1';   // Android emulator (change to localhost for iOS/desktop)

  // New APIs
  static const String fakeStoreApiUrl = 'https://fakestoreapiserver.reactbd.org/api/products';
  static const String rapidApiBaseUrl = 'https://ecommerce-api3.p.rapidapi.com';
  static const String rapidApiKey = Secrets.rapidApiKey;
  static const String rapidApiHost = 'ecommerce-api3.p.rapidapi.com';
}
