import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

class ShoppingService {
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Generates a Google Shopping URL for the given product name,
  /// specifically sorted by price: low to high.
  Uri getCheapestProductSearchUrl(String productName) {
    // Construction:
    // tbm=shop -> Google Shopping
    // tbs=p_ord:p -> Sort by Price: Low to High
    final query = Uri.encodeComponent(productName);
    final urlString = 'https://www.google.com/search?q=$query&tbm=shop&tbs=p_ord:p';
    return Uri.parse(urlString);
  }

  /// Attempts to scrape the first (cheapest) product link from Google Shopping results.
  Future<String?> scrapeCheapestProductLink(String productName) async {
    try {
      final searchUrl = getCheapestProductSearchUrl(productName);
      final response = await _dio.get(searchUrl.toString());
      
      if (response.statusCode == 200) {
        final document = parser.parse(response.data);
        
        // Google Shopping result links often have specific patterns.
        // We look for direct store links or Google-wrapped outgoing links.
        
        // Pattern 1: .sh-dgr__grid-result containers (Grid view)
        final gridResults = document.querySelectorAll('.sh-dgr__grid-result');
        for (final result in gridResults) {
          final link = result.querySelector('a[href]');
          final href = link?.attributes['href'];
          if (href != null && !href.startsWith('/search')) {
             return _normalizeUrl(href);
          }
        }

        // Pattern 2: Generic links in shopping view
        final allLinks = document.querySelectorAll('a[href*="url?q="]');
        for (final link in allLinks) {
          final href = link.attributes['href'];
          if (href != null && href.contains('google.com/url')) {
            final normalized = _normalizeUrl(href);
            if (normalized != null && !normalized.contains('google.com')) {
              return normalized;
            }
          }
        }
      }
    } catch (e) {
      developer.log('Scraping error: $e', name: 'ShoppingService.scrapeCheapestProductLink');
    }
    return null;
  }

  String? _normalizeUrl(String href) {
    try {
      if (href.startsWith('/url?q=')) {
        final uri = Uri.parse('https://google.com$href');
        return uri.queryParameters['q'];
      }
      if (href.contains('url?q=')) {
        final uri = Uri.parse(href);
        return uri.queryParameters['q'];
      }
      return href;
    } catch (e) {
      return href;
    }
  }

  /// Opens the cheapest product search in an external browser or app.
  Future<bool> launchCheapestSearch(String productName) async {
    // 1. Try to scrape the direct link first for an "instant" experience
    final directLink = await scrapeCheapestProductLink(productName);
    
    if (directLink != null) {
      final directUri = Uri.parse(directLink);
      if (await canLaunchUrl(directUri)) {
        return await launchUrl(directUri, mode: LaunchMode.externalApplication);
      }
    }

    // 2. Fallback to the sorted search results if scraping fails
    final searchUrl = getCheapestProductSearchUrl(productName);
    try {
      return await launchUrl(searchUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }
}
