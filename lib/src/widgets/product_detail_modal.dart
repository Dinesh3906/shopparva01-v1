// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../models/product.dart';
import '../state/app_providers.dart';

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

        return Container(
          decoration: const BoxDecoration(
            color: ThemeTokens.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                        color: Colors.amber.shade400, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      p.rating.toStringAsFixed(1),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70),
                    ),
                    const Spacer(),
                    Text(
                      '${p.currency.isNotEmpty ? p.currency : '\u0000'}${p.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ThemeTokens.accent,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (p.priceHistory != null && p.priceHistory!.isNotEmpty)
                  _PriceSparkline(data: p.priceHistory!),
                const SizedBox(height: 16),
                Text(
                  'Price comparison',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (comparisons.isEmpty)
                  Text(
                    'No comparison data available.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  )
                else
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    if (c.shipping != null)
                                      Text(
                                        'Shipping: ${c.shipping!.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${p.currency.isNotEmpty ? p.currency : '\u0000'}${c.price.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            fontSize: 16,
                                            color: ThemeTokens.accent),
                                  ),
                                  if (c.rating != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            size: 14, color: Colors.amber),
                                        const SizedBox(width: 2),
                                        Text(
                                          c.rating!.toStringAsFixed(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          // Add to cart stub
                        },
                        child: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // View best deal stub
                        },
                        child: const Text('View Best Deal'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final userAsync = ref.watch(userProfileProvider);
                      return userAsync.when(
                        data: (user) => TextButton.icon(
                          onPressed: () async {
                            final repo = ref.read(productRepositoryProvider);
                            await repo.trackProduct(
                              productId: p.id,
                              userId: user.id,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tracking enabled for this product'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.notifications_active_rounded),
                          label: const Text('Track Price'),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ],
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

