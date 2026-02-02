import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme_tokens.dart';
import 'package:shopparva/models/product.dart';
import '../state/app_providers.dart';
import '../screens/price_tracker_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailModal extends ConsumerWidget {
  const ProductDetailModal({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(productRepositoryProvider);

    return FutureBuilder<Product>(
      future: repo.getProductById(product.id),
      initialData: product,
      builder: (context, snapshot) {
        final p = snapshot.data ?? product;
        final comparisons = p.comparisons ?? const [];

        // Calculate potential discount or mock it for the "deal" look
        // If we don't have real MRP, assume current price is discounted by 40% for the visual
        final double currentPrice = p.price;
        final double mockMrp = currentPrice * 1.4; // 40% off calculation reverse
        final int discountPercent = 40;

        return Container(
          decoration: const BoxDecoration(
            color: ThemeTokens.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Close Button Row
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  
                  // PROMINENT IMAGE SECTION (Amazon Style)
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: CachedNetworkImage(
                      imageUrl: p.image,
                      fit: BoxFit.contain,
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
                  const SizedBox(height: 16),

                  // Brand & Title
                  if (p.brand.isNotEmpty)
                    Text(
                      p.brand,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  Text(
                    p.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Ratings
                  Row(
                    children: [
                      Text(
                        p.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        children: List.generate(5, (index) {
                          if (index < p.rating.floor()) {
                            return const Icon(Icons.star, color: Colors.amber, size: 16);
                          } else if (index < p.rating && (p.rating - index) >= 0.5) {
                            return const Icon(Icons.star_half, color: Colors.amber, size: 16);
                          } else {
                            return const Icon(Icons.star_border, color: Colors.amber, size: 16);
                          }
                        }),
                      ),
                      const SizedBox(width: 8),
                      // Mock review count as we don't have it in model usually, or use stores count
                      Text(
                        '(${p.stores * 32})', // Fake correlation for density
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue.shade300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // DEAL BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCC0C39), // Amazon Deal Red
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Limited time deal',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // PRICE BLOCK
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        '-$discountPercent%',
                        style: const TextStyle(
                          color: Color(0xFFCC0C39), // Amazon Red
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Currency Symbol Superscript
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          p.currency.isEmpty ? '₹' : p.currency.replaceAll('\$', '₹'),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        p.price.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '00', // Mock cents/paisa
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // MRP Strike-through
                  Row(
                    children: [
                      Text(
                        'M.R.P.: ',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        '${p.currency.isEmpty ? '₹' : p.currency.replaceAll('\$', '₹')}${mockMrp.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Prime Mock
                  Row(
                    children: [
                      const Icon(Icons.check, color: Colors.orange, size: 18),
                      const Text(
                        'prime',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'FREE delivery',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32, color: Colors.white10),

                  // CHART SECTION (Keep functionality)
                  if (p.priceHistory != null && p.priceHistory!.isNotEmpty) ...[
                     Text(
                      'Price History',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _PriceSparkline(data: p.priceHistory!.map((e) => e.price).toList()),
                    const SizedBox(height: 24),
                  ],

                  // COMPARISON SECTION
                  Text(
                    'Price comparison',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (comparisons.isEmpty)
                    Text(
                      'No comparison data available.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comparisons.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final c = comparisons[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ThemeTokens.surfaceMuted,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.store,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    if (c.shipping != null)
                                      Text(
                                        'Shipping: ${c.shipping!.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${p.currency.isNotEmpty ? p.currency.replaceAll('\$', '₹') : '₹'}${c.price.toStringAsFixed(0)}',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, color: ThemeTokens.accent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                  
                  // ACTIONS ROW
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).addToCart(p);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${p.name} added to cart'), duration: const Duration(seconds: 1)),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          // Amazon yellow button style mock
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF7CA00),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton( // Changed to Filled for Buy Now style
                          onPressed: () async {
                             final query = Uri.encodeComponent(p.name);
                             final url = Uri.parse('https://www.google.com/search?q=$query&tbm=shop');
                             if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
                                }
                             }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFA8900), // Amazon orange
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('View Deal'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // TRACKING BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: Consumer(
                      builder: (context, ref, _) {
                        final trackedNotifier = ref.watch(trackedProductsNotifierProvider.notifier);
                        final isTracked = trackedNotifier.isTracked(p.id);

                        return OutlinedButton.icon(
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
                            // color: isTracked ? ThemeTokens.primary : Colors.white70,
                          ),
                          label: Text(isTracked ? 'Tracking Active' : 'Track Price'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white30),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    // charts_flutter is broken on newer Flutter versions.
    // Placeholder for future fl_chart implementation.
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        'Price History Chart',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white30),
      ),
    );
  }
}

