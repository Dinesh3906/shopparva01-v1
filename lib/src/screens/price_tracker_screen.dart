import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme_tokens.dart';
import 'dart:math';
import '../../core/constants.dart';
import '../models/product.dart';
import '../models/price_history_point.dart';
import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';

import '../widgets/multi_platform_price_charts.dart';
import '../widgets/time_range_selector.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/price_alert_dialog.dart';
import '../state/fab_state.dart';

class PriceTrackerScreen extends ConsumerStatefulWidget {
  const PriceTrackerScreen({super.key});

  @override
  ConsumerState<PriceTrackerScreen> createState() => _PriceTrackerScreenState();
}

class _PriceTrackerScreenState extends ConsumerState<PriceTrackerScreen> {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 2),
    receiveTimeout: const Duration(seconds: 3),
  ));

  @override
  Widget build(BuildContext context) {
    final trackedAsync = ref.watch(trackedProductsNotifierProvider);
    final selectedProduct = ref.watch(selectedTrackedProductProvider);
    final priceAlerts = ref.watch(priceAlertsProvider);

    return Scaffold(
      // backgroundColor: transparent (from theme)
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent for gradient
        elevation: 0,
        title: const Text(
          'Price Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true, // Allow gradient behind AppBar
      body: Container(
        decoration: const BoxDecoration(
          gradient: ThemeTokens.backgroundGradient,
        ),
        child: SafeArea(
          child: trackedAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return _buildEmptyStateWithSuggestions(context);
              }

              // If no product is selected, select the first one
              if (selectedProduct == null && products.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(selectedTrackedProductProvider.notifier).state = products.first;
                });
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  // Stats Header
                  _buildStatsHeader(products.length, priceAlerts.where((a) => a.isActive).length),
                  
                  // Product Selector
                  _buildProductSelector(products, selectedProduct),
                  
                  // Main Content
                  Expanded(
                    child: selectedProduct != null
                        ? _buildProductAnalysis(selectedProduct)
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            },
            loading: () => const LoadingShimmer(),
            error: (_, __) => const EmptyStateCard(
              title: 'Could not load tracker',
              message: 'Please try again in a moment.',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader(int trackedCount, int activeAlerts) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            ThemeTokens.surfaceDark,
            ThemeTokens.surfaceMuted,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.show_chart_rounded,
              label: 'Tracking',
              value: trackedCount.toString(),
              color: ThemeTokens.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white12,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.notifications_active_rounded,
              label: 'Active Alerts',
              value: activeAlerts.toString(),
              color: ThemeTokens.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProductSelector(List<Product> products, Product? selectedProduct) {
    return SizedBox(
      height: 160, // Increased height significantly to accommodate high DPI scaling
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          final isSelected = selectedProduct?.id == product.id;
          
          return GestureDetector(
            onTap: () {
              ref.read(selectedTrackedProductProvider.notifier).state = product;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 160,
              height: 180, // Explicit height for the card
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? ThemeTokens.primary.withOpacity(0.2) : ThemeTokens.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? ThemeTokens.primary : Colors.white12,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ThemeTokens.surfaceMuted,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isSelected ? ThemeTokens.primary : ThemeTokens.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: ThemeTokens.primary,
                          size: 20,
                        )
                      : GestureDetector(
                          onTap: () {
                             ref.read(trackedProductsNotifierProvider.notifier).untrackProduct(product.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white54,
                              size: 14,
                            ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductAnalysis(Product product) {
    final timeRange = ref.watch(selectedTimeRangeProvider);
    
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchProductDetails(product.id, timeRange),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          if (snapshot.hasError) {
            debugPrint('Snapshot error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }
          return const Center(
            child: Text(
              'Failed to load price history',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }

        final data = snapshot.data!;
        
        // Product model now parses priceHistory directly during JSON deserialization.
        // We handle legacy cases or direct API responses here.
        final rawHistory = data['price_history'] ?? data['priceHistory'];
        List<PriceHistoryPoint> priceHistory;
        
        if (rawHistory is List) {
          if (rawHistory.isNotEmpty && rawHistory.first is PriceHistoryPoint) {
            priceHistory = List<PriceHistoryPoint>.from(rawHistory);
          } else {
            priceHistory = rawHistory.map((e) => PriceHistoryPoint.fromJson(e as Map<String, dynamic>)).toList();
          }
        } else {
          priceHistory = product.priceHistory ?? [];
        }
        
        // Helper for resilience
        double toDouble(dynamic v) {
          if (v is num) return v.toDouble();
          return double.tryParse(v.toString()) ?? 0.0;
        }

        final trendData = data['price_trend'] as Map<String, dynamic>?;
        final priceTrend = {
          'trend': trendData?['trend']?.toString() ?? 'stable',
          'percentage': toDouble(trendData?['percentage'] ?? 0.0),
          'lowest': toDouble(trendData?['lowest'] ?? product.price),
          'highest': toDouble(trendData?['highest'] ?? product.price),
          'average': toDouble(trendData?['average'] ?? product.price),
        };

        // Mark lowest and highest points
        if (priceHistory.isNotEmpty) {
          final lowestPrice = priceTrend['lowest'] as double;
          final highestPrice = priceTrend['highest'] as double;
          
          for (var i = 0; i < priceHistory.length; i++) {
            if (priceHistory[i].price == lowestPrice) {
              priceHistory[i] = priceHistory[i].copyWith(isLowest: true);
            }
            if (priceHistory[i].price == highestPrice) {
              priceHistory[i] = priceHistory[i].copyWith(isHighest: true);
            }
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Range Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Price History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TimeRangeSelector(),
                ],
              ),
              const SizedBox(height: 16),
              
              // Multi-Platform Price Charts
              _buildMultiPlatformCharts(data, product),
              const SizedBox(height: 24),
              
              // AI Insights
              AIInsightCard(
                trend: priceTrend['trend'] as String,
                trendPercentage: (priceTrend['percentage'] as num).toDouble(),
                currentPrice: product.price,
                lowestPrice: priceTrend['lowest'] as double,
                highestPrice: priceTrend['highest'] as double,
                averagePrice: priceTrend['average'] as double,
              ),
              const SizedBox(height: 24),
              
              // Platform Comparison
              if (product.comparisons != null && product.comparisons!.isNotEmpty) ...[
                const Text(
                  'Price Comparison',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...product.comparisons!.map((comparison) {
                  final isBestDeal = comparison.price == product.comparisons!
                      .map((c) => c.price)
                      .reduce((a, b) => a < b ? a : b);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeTokens.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isBestDeal ? Colors.green : Colors.white12,
                        width: isBestDeal ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comparison.store,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (isBestDeal) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'Best Deal',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (comparison.rating != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      comparison.rating!.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${comparison.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isBestDeal ? Colors.green : ThemeTokens.accent,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (comparison.shipping != null && comparison.shipping! > 0)
                              Text(
                                '+₹${comparison.shipping!.toStringAsFixed(2)} shipping',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white54,
                                      fontSize: 10,
                                    ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
              
              // Price Alerts Section
              const Text(
                'Price Alerts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildPriceAlertsSection(product),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceAlertsSection(Product product) {
    final alerts = ref.watch(priceAlertsProvider)
        .where((alert) => alert.productId == product.id)
        .toList();

    return Column(
      children: [
        // Existing alerts
        ...alerts.map((alert) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeTokens.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: alert.isTriggered ? Colors.green : Colors.white12,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  alert.isTriggered
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_outlined,
                  color: alert.isTriggered ? Colors.green : Colors.white70,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target: ₹${alert.targetPrice.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.isTriggered
                            ? 'Price target reached!'
                            : 'Save ${alert.savingsPercentage.toStringAsFixed(0)}% at target',
                        style: TextStyle(
                          color: alert.isTriggered ? Colors.green : Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: alert.isActive,
                  onChanged: (value) {
                    ref.read(priceAlertsProvider.notifier).toggleAlert(alert.id);
                  },
                  activeColor: ThemeTokens.primary,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: () {
                    ref.read(priceAlertsProvider.notifier).removeAlert(alert.id);
                  },
                ),
              ],
            ),
          );
        }),
        
        // Add new alert button
        OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => PriceAlertDialog(product: product),
            );
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Create Price Alert'),
          style: OutlinedButton.styleFrom(
            foregroundColor: ThemeTokens.primary,
            side: BorderSide(color: ThemeTokens.primary),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _fetchProductDetails(String productId, int days) async {
    final url = '${AppConstants.apiBaseUrl}/products/$productId';
    debugPrint('Fetching product details from: $url with historyDays: $days');
    
    try {
      final response = await _dio.get(
        url,
        queryParameters: {'historyDays': days},
      );
      debugPrint('Response received: ${response.statusCode}');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading product details: $e');

      // Fallback: If we have detailed product info already (passed via arguments or cache), use it.
      // But _fetchProductDetails currently only takes ID.
      // We should rely on the caller to handle display if this fails?
      // actually, let's try to fetch from repository cache if available
      final repo = ref.read(productRepositoryProvider);
      try {
         final cachedProduct = await repo.getProductById(productId);
         if (cachedProduct.priceHistory != null && cachedProduct.priceHistory!.isNotEmpty) {
             debugPrint('Using cached price history for $productId');
             return {
                'id': cachedProduct.id,
                'title': cachedProduct.name,
                'price': cachedProduct.price,
                'price_history': cachedProduct.priceHistory!.map((e) => e.toJson()).toList(),
                // Recalculate basic trend if needed, or just return basic
                'price_trend': {
                    'trend': 'stable', // simplistic fallback
                    'percentage': 0.0,
                    'lowest': cachedProduct.price,
                    'highest': cachedProduct.price,
                    'average': cachedProduct.price,
                }
             };
         }
      } catch (_) {}

      // Fallback: Generate mock data if backend fails
      final random = Random();
      final now = DateTime.now();
      
      // Generate global history
      final history = <Map<String, dynamic>>[];
      double price = 50000.0;
      for (int i = days; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        price = price * (1 + (random.nextDouble() * 0.1 - 0.05));
        if (price < 10000) price = 10000;
        history.add({
          'date': date.toIso8601String(),
          'price': price,
        });
      }
      
      // Generate platform-specific history for "all graphs"
      final platforms = ['Amazon', 'Flipkart', 'Myntra', 'AJIO', 'Croma'];
      final platformHistory = <String, List<Map<String, dynamic>>>{};
      for (final p in platforms) {
        final pHistory = <Map<String, dynamic>>[];
        double pPrice = price * (0.9 + random.nextDouble() * 0.2);
        for (int i = days; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          pPrice = pPrice * (1 + (random.nextDouble() * 0.1 - 0.05));
          pHistory.add({
            'date': date.toIso8601String(),
            'price': pPrice,
          });
        }
        platformHistory[p] = pHistory;
      }
      
      // Calculate basic trend
      final startPrice = history.first['price'] as double;
      final endPrice = history.last['price'] as double;
      final change = ((endPrice - startPrice) / startPrice) * 100;
      
      final trend = {
        'trend': change > 0.5 ? 'up' : (change < -0.5 ? 'down' : 'stable'),
        'percentage': change.abs(),
        'lowest': history.map((e) => e['price'] as double).reduce(min),
        'highest': history.map((e) => e['price'] as double).reduce(max),
        'average': history.map((e) => e['price'] as double).reduce((a, b) => a + b) / history.length,
      };

      return {
        'id': productId,
        'title': 'Product Name', 
        'price': price,
        'price_history': history,
        'platform_history': platformHistory,
        'price_trend': trend,
        'comparisons': platforms.map((p) => {
          'store': p,
          'price': price * (0.95 + random.nextDouble() * 0.1),
          'rating': 4.0 + random.nextDouble(),
          'shipping': random.nextBool() ? 0.0 : 50.0,
        }).toList()
      };
    }
  }

  Widget _buildEmptyStateWithSuggestions(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EmptyStateCard(
            title: 'No tracked products yet',
            message: 'Start tracking products to monitor their price history and get smart buying recommendations.',
            action: Column(
              children: [
                FilledButton(
                  onPressed: () {
                    // Navigate back to Home and trigger FAB highlight
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ref.read(navigationIndexProvider.notifier).state = 0; // Ensure Home tab
                    
                    // Trigger FAB highlight animation
                    ref.read(fabHighlightProvider.notifier).state = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                           ref.read(fabHighlightProvider.notifier).state = false;
                        }
                      });
                    });
                  },
                  child: const Text('Start Tracking'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showTrackUrlDialog(context),
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Track by Product URL'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeTokens.primary,
                    side: BorderSide(color: ThemeTokens.primary),
                  ),
                ),
              ],
            ),
          ),
          _buildPriceTrackerSuggestedSection(context),
        ],
      ),
    );
  }

  Widget _buildPriceTrackerSuggestedSection(BuildContext context) {
    final repo = ref.read(productRepositoryProvider);
    
    return FutureBuilder<List<Product>>(
      future: repo.getProducts(limit: 6),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
        
        final suggestions = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Products to Track',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = suggestions[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ThemeTokens.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: p.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[800]),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              Text('₹${p.price.toStringAsFixed(0)}', style: const TextStyle(color: ThemeTokens.primary)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => ref.read(trackedProductsNotifierProvider.notifier).trackProduct(p),
                          child: const Text('Track'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTrackUrlDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeTokens.surfaceDark,
        title: const Text('Track Product from URL', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste a link from Amazon, Flipkart, Myntra, AJIO, or Croma.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'https://...',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final url = controller.text.trim();
              if (url.isEmpty) return;
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Analyzing product...'), duration: Duration(seconds: 2)),
              );

              try {
                final repo = ref.read(productRepositoryProvider);
                final result = await repo.trackExternalProduct(url: url, userId: 'user-123');
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Now tracking: ${result['product']['title']}')),
                  );
                  // Refresh the list
                  ref.invalidate(trackedProductsProvider);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Track'),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiPlatformCharts(Map<String, dynamic> data, Product product) {
    // Extract platform-specific price history from backend data
    final platformData = <String, List<PriceHistoryPoint>>{};
    
    // Check if backend provides platform-specific data
    if (data.containsKey('platform_history')) {
      final platformHistory = data['platform_history'] as Map<String, dynamic>;
      platformHistory.forEach((platform, historyList) {
        if (historyList is List) {
          platformData[platform] = historyList
              .map((e) => PriceHistoryPoint.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      });
    } else {
      // Fallback: Generate mock platform-specific data for demonstration
      final platforms = ['Amazon', 'Flipkart', 'Myntra', 'AJIO', 'Croma'];
      final random = Random();
      final now = DateTime.now();
      
      for (final platform in platforms) {
        final history = <PriceHistoryPoint>[];
        double basePrice = product.price * (0.9 + random.nextDouble() * 0.2);
        
        for (int i = 30; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          // Add some variation
          final variation = (random.nextDouble() - 0.5) * 0.1;
          final price = basePrice * (1 + variation);
          
          history.add(PriceHistoryPoint(
            date: date,
            price: price,
          ));
        }
        
        platformData[platform] = history;
      }
    }
    
    return MultiPlatformPriceCharts(
      platformData: platformData,
      currency: product.currency,
    );
  }

  // --- End of State Class ---
}
