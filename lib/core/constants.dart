import 'package:flutter/foundation.dart' show kIsWeb;
import 'secrets.dart';

class AppConstants {
  static const String appName = 'ShopParva';
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

  // New Shopping & Utility APIs
  static const String frankfurterBaseUrl = 'https://api.frankfurter.app';
  static const String makeupBaseUrl = 'https://makeup-api.herokuapp.com/api/v1/products.json';
  static const String platziBaseUrl = 'https://api.escuelajs.co/api/v1/products';
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org/api/v2/search';
  static const String bestBuyBaseUrl = 'https://api.bestbuy.com/v1';
  static const String dummyProductsBaseUrl = 'https://dummyjson.com/products';
  static const String ebayBaseUrl = 'https://api.ebay.com';
  static const String etsyBaseUrl = 'https://openapi.etsy.com/v3';
  static const String flipkartBaseUrl = 'https://api.flipkart.net/sellers';
  static const String lazadaBaseUrl = 'https://api.lazada.com/restapi';
  static const String mercadolibreBaseUrl = 'https://api.mercadolibre.com';
  static const String octopartBaseUrl = 'https://octopart.com/api/v4';
  static const String olxPolandBaseUrl = 'https://www.olx.pl/api/v1';
  static const String rappiBaseUrl = 'https://api.rappi.com';
  static const String shopeeBaseUrl = 'https://partner.shopeemobile.com/api/v2';
  static const String tokopediaBaseUrl = 'https://fs.tokopedia.net';
  static const String wooCommerceBaseUrl = 'https://example.com/wp-json/wc/v3';
  static const String digiKeyBaseUrl = 'https://api.digikey.com';
}

enum ProductSource {
  local,
  fakeStore,
  rapidApi,
  platzi,
  makeup,
  openFoodFacts,
  bestBuy,
  dummyProducts,
  ebay,
  etsy,
  flipkart,
  lazada,
  mercadolibre,
  octopart,
  olxPoland,
  rappi,
  shopee,
  tokopedia,
  wooCommerce,
  digiKey,
}
