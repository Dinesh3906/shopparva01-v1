import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/shopping_service.dart';

import '../../core/theme_tokens.dart';
import 'package:shopparva/models/product.dart';
import '../state/app_providers.dart';
import '../screens/price_tracker_screen.dart';
import 'glass_container.dart';

class ProductDetailModal extends ConsumerWidget {
  const ProductDetailModal({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = product;
    final comparisons = p.comparisons ?? const [];

    // Calculate potential discount or mock it for the "deal" look
    final double currentPrice = p.price;
    final double mockMrp = currentPrice * 1.4; 
    final int discountPercent = 40;

    return Container(
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceDark.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          // Content
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // PROMINENT IMAGE SECTION
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Transparent so background blends natively
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CachedNetworkImage(
                        imageUrl: p.image,
                        fit: BoxFit.contain, // Maintain aspect ratio without cropping
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(color: Colors.grey.shade300),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Brand & Title
                  if (p.brand.isNotEmpty)
                    Text(
                      p.brand.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeTokens.labelLarge.copyWith(
                        color: ThemeTokens.primary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 50.ms),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    p.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeTokens.headlineMedium.copyWith(
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  
                  const SizedBox(height: 12),

                  if (p.description.isNotEmpty) ...[
                    Text(
                      p.description,
                      style: ThemeTokens.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.85),
                        height: 1.4,
                      ),
                    ).animate().fadeIn(delay: 120.ms),
                    const SizedBox(height: 16),
                  ],

                  // Ratings
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              p.rating.toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${p.stores * 32} reviews', 
                        style: ThemeTokens.bodySmall.copyWith(color: Colors.white54),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // PRICE BLOCK
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeTokens.surfaceMuted,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${p.currency.isEmpty ? '₹' : p.currency.replaceAll('\$', '₹')}${p.price.toStringAsFixed(0)}',
                          style: ThemeTokens.headlineLarge.copyWith(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '${p.currency.isEmpty ? '₹' : p.currency.replaceAll('\$', '₹')}${mockMrp.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.white30,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white30,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: ThemeTokens.secondary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: ThemeTokens.secondary.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            '-$discountPercent%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // CHART SECTION
                  if (p.priceHistory != null && p.priceHistory!.isNotEmpty) ...[
                     Text(
                      'Price Trend',
                      style: ThemeTokens.titleLarge.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder(
                      future: Future.delayed(const Duration(milliseconds: 400)),
                      builder: (context, snapshot) {
                        return AnimatedOpacity(
                          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            height: 120,
                            child: snapshot.connectionState == ConnectionState.done 
                                ? _PriceSparkline(data: p.priceHistory!.map((e) => e.price).toList())
                                : const SizedBox.shrink(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],

                  // COMPARISON SECTION
                  if (comparisons.isNotEmpty) ...[
                    Text(
                      'Best Prices',
                      style: ThemeTokens.titleLarge.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comparisons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final c = comparisons[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: ThemeTokens.surfaceMuted,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.storefront, color: Colors.white70, size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.store,
                                      style: ThemeTokens.labelLarge.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    if (c.shipping != null)
                                      Text(
                                        'Shipping: ${c.shipping!.toStringAsFixed(2)}',
                                        style: ThemeTokens.bodySmall.copyWith(color: Colors.white38),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                '${p.currency.isEmpty ? '₹' : p.currency.replaceAll('\$', '₹')}${c.price.toStringAsFixed(0)}',
                                style: ThemeTokens.titleLarge.copyWith(fontSize: 18, color: ThemeTokens.accent),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                  
                  // ACTIONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                             // .. existing log
                            ref.read(cartProvider.notifier).addToCart(p);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${p.name} added to cart'), duration: const Duration(seconds: 1)),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final sc = ShoppingService();
                            final success = await sc.launchCheapestSearch(p.name);
                            if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open shopping search')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeTokens.accent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 8,
                            shadowColor: ThemeTokens.accent.withOpacity(0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.flash_on_rounded, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                comparisons.isNotEmpty
                                    ? 'Buy Cheapest'
                                    : 'Buy Now',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // TRACKING
                  SizedBox(
                    width: double.infinity,
                    child: Consumer(
                      builder: (context, ref, _) {
                        final trackedNotifier = ref.watch(trackedProductsNotifierProvider.notifier);
                        final isTracked = trackedNotifier.isTracked(p.id);

                        return TextButton.icon(
                          onPressed: () async {
                            if (isTracked) {
                              await trackedNotifier.untrackProduct(p.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product removed from tracking')));
                              }
                            } else {
                              await trackedNotifier.trackProduct(p);
                              if (context.mounted) {
                                ref.read(selectedTrackedProductProvider.notifier).state = p;
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PriceTrackerScreen()));
                              }
                            }
                          },
                          icon: Icon(
                            isTracked ? Icons.notifications_active : Icons.notifications_none,
                            color: isTracked ? ThemeTokens.primary : Colors.white54,
                          ),
                          label: Text(
                            isTracked ? 'Tracking Active' : 'Track Price',
                            style: TextStyle(
                              color: isTracked ? ThemeTokens.primary : Colors.white54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Close Button (Floating)
          Positioned(
            top: 20, // Align top with the content scroll padding
            right: 20, // Align exactly with the edge of the image container
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Darker for better contrast against white images when overlapping
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _PriceSparkline extends StatelessWidget {
  const _PriceSparkline({
    required this.data,
  });

  final List<double> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    // Normalize data for chart
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value);
    }).toList();
    
    final minPrice = data.reduce((curr, next) => curr < next ? curr : next);
    final maxPrice = data.reduce((curr, next) => curr > next ? curr : next);
    final range = maxPrice - minPrice;
    final padding = range * 0.2; // Add 20% padding

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minY: minPrice - padding,
        maxY: maxPrice + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: ThemeTokens.accent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  ThemeTokens.accent.withOpacity(0.3),
                  ThemeTokens.accent.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: ThemeTokens.surfaceDark,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.toStringAsFixed(0),
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

