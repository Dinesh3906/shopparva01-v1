import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../state/providers.dart';
import '../../core/theme_tokens.dart';
import 'widgets/comparison_table.dart';
import 'widgets/price_chart.dart';
import '../../services/shopping_service.dart';

// Helper provider to fetch fresh details including comparison
final productDetailsProvider = FutureProvider.family<Product?, String>((ref, id) async {
  return ref.read(apiServiceProvider).getProductComparison(id);
});

// Helper provider for mock price history
final priceHistoryProvider = FutureProvider.family<List<({String date, double price})>, String>((ref, id) async {
    // In real app, fetch from API
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      (date: '2023-01-01', price: 399.99),
      (date: '2023-02-01', price: 380.00),
      (date: '2023-03-01', price: 349.99),
      (date: '2023-04-01', price: 355.00),
      (date: '2023-05-01', price: 348.00),
      (date: '2023-06-01', price: 329.00),
    ];
});

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));
    final historyAsync = ref.watch(priceHistoryProvider(productId));
    final isWatched = ref.read(watchlistProvider.notifier).isWatched(productId);

    return Scaffold(
      body: productAsync.when(
        data: (product) {
          if (product == null) return const Center(child: Text('Product not found'));
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.contain, // Changed to contain for better product visibility
                      placeholder: (context, _) => Container(color: ThemeTokens.surfaceMuted),
                      errorWidget: (context, _, __) => Container(
                        color: ThemeTokens.surfaceMuted,
                        child: const Icon(Icons.image_not_supported, color: Colors.white24),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
                      child: Icon(isWatched ? Icons.favorite : Icons.favorite_border, color: isWatched ? Colors.red : Colors.black),
                    ),
                    onPressed: () {
                      ref.read(watchlistProvider.notifier).toggle(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isWatched ? 'Removed from Watchlist' : 'Added to Watchlist')),
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                         children: [
                           Expanded(
                             child: Text(
                               product.name,
                               style: ThemeTokens.headlineMedium.copyWith(color: Colors.white),
                             ),
                           ),
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                             decoration: BoxDecoration(
                               color: ThemeTokens.primary,
                               borderRadius: BorderRadius.circular(20),
                             ),
                             child: Text(
                               '₹${product.price.toStringAsFixed(0)}',
                               style: const TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18,
                               ),
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 8),
                       Text(product.brand, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white54)),
                       const SizedBox(height: 16),
                       if (product.description.isNotEmpty) ...[
                         Text(product.description, style: ThemeTokens.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                         const SizedBox(height: 32),
                       ],
                       
                       // Comparison Table
                       ComparisonTable(offers: product.offers),
                       const SizedBox(height: 32),

                       // Price History Chart
                       historyAsync.when(
                         data: (history) => PriceChart(history: history),
                         loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                         error: (_, __) => const SizedBox(),
                       ),
                       
                       const SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading details: $e')),
      ),
      bottomNavigationBar: productAsync.when(
        data: (product) => product == null 
          ? null 
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeTokens.surfaceDark,
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                           ref.read(cartProvider.notifier).addToCart(product);
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(seconds: 1)),
                           );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeTokens.surfaceMuted,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                           final success = await sc.launchCheapestSearch(product.name);
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flash_on_rounded, size: 18),
                            SizedBox(width: 4),
                            Text('Buy Cheapest', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}
