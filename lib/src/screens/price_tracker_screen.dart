import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../models/product.dart';
import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';
import '../widgets/product_detail_modal.dart';

class PriceTrackerScreen extends ConsumerWidget {
  const PriceTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackedAsync = ref.watch(trackedProductsProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        title: const Text('Price Tracker'),
      ),
      body: trackedAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const EmptyStateCard(
              title: 'No price alerts yet',
              message:
                  'Tap the bell icon on a product to start tracking its price.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = products[index];
              return _TrackedProductCard(product: p);
            },
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
}

class _TrackedProductCard extends StatelessWidget {
  const _TrackedProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final buyWindowStart = now.add(const Duration(days: 3));
    final buyWindowEnd = now.add(const Duration(days: 10));

    return InkWell(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ProductDetailModal(product: product),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: ThemeTokens.surfaceDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: ThemeTokens.surfaceMuted,
                ),
                child: const Icon(Icons.notifications_active_rounded,
                    color: Colors.white70),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white.withOpacity(0.9)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current: \\${product.price.toStringAsFixed(0)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Expected buy window: ${_formatDate(buyWindowStart)} 897 ${_formatDate(buyWindowEnd)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: ThemeTokens.accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
