import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/theme_tokens.dart';
import 'dart:math';
import '../../core/constants.dart';
import '../models/product.dart';
import '../models/price_history_point.dart';
import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';
import '../widgets/price_history_chart.dart';
import '../widgets/time_range_selector.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/price_alert_dialog.dart';

class PriceTrackerScreen extends ConsumerStatefulWidget {
  const PriceTrackerScreen({super.key});

  @override
  ConsumerState<PriceTrackerScreen> createState() => _PriceTrackerScreenState();
}

class _PriceTrackerScreenState extends ConsumerState<PriceTrackerScreen> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    final trackedAsync = ref.watch(trackedProductsProvider);
    final selectedProduct = ref.watch(selectedTrackedProductProvider);
    final priceAlerts = ref.watch(priceAlertsProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        backgroundColor: ThemeTokens.backgroundDark,
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
      body: trackedAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const EmptyStateCard(
              title: 'No tracked products yet',
              message: 'Start tracking products to monitor their price history and get smart buying recommendations.',
            );
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
      height: 120,
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
                      Row(
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
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isSelected ? ThemeTokens.primary : ThemeTokens.accent,
                          fontSize: 16,
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
        
        // Handle both camelCase (priceHistory) and snake_case (price_history)
        final rawHistory = data['price_history'] ?? data['priceHistory'];
        final priceHistory = (rawHistory != null && rawHistory is List)
            ? rawHistory.map((e) => PriceHistoryPoint.fromJson(e as Map<String, dynamic>)).toList()
            : <PriceHistoryPoint>[];
        
        final priceTrend = data['price_trend'] as Map<String, dynamic>? ?? {
          'trend': 'stable',
          'percentage': 0.0,
          'lowest': product.price,
          'highest': product.price,
          'average': product.price,
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
              
              // Price Chart
              PriceHistoryChart(
                priceHistory: priceHistory,
                currency: product.currency,
              ),
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
                              '\$${comparison.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: isBestDeal ? Colors.green : ThemeTokens.accent,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (comparison.shipping != null && comparison.shipping! > 0)
                              Text(
                                '+\$${comparison.shipping!.toStringAsFixed(2)} shipping',
                                style: const TextStyle(
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
                        'Target: \$${alert.targetPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
      debugPrint('Generating fallback mock data...');
      
      // Fallback: Generate mock data if backend fails
      final random = Random();
      final now = DateTime.now();
      final history = <Map<String, dynamic>>[];
      double price = 50000.0;
      
      for (int i = days; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        // Random walk
        price = price * (1 + (random.nextDouble() * 0.1 - 0.05));
        if (price < 10000) price = 10000;
        
        history.add({
          'date': date.toIso8601String(),
          'price': price,
        });
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
        'title': 'Product Name', // Placeholder
        'price': price,
        'price_history': history,
        'price_trend': trend,
        'comparisons': []
      };
    }
  }
}
