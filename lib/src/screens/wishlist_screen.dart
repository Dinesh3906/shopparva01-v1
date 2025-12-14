import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../models/product.dart';
import '../models/user.dart';

import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';
import '../widgets/product_detail_modal.dart';

final wishlistProvider = FutureProvider.autoDispose<List<WishlistItem>>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getWishlist();
});

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: wishlistAsync.when(
        data: (wishlist) {
          if (wishlist.isEmpty) {
            return const EmptyStateCard(
              title: 'Your wishlist is empty',
              message: 'Add products to your wishlist to save them for later.',
            );
          }
          return FutureBuilder<List<_WishlistProduct>>(
            future: _loadWishlistProducts(ref, wishlist),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingShimmer();
              }
              final products = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _WishlistItemCard(
                  item: products[index],
                  onRemove: () => _removeFromWishlist(context, ref, products[index].wishlistId),
                  onTap: (product) => _showProductDetail(context, product),
                ),
              );
            },
          );
        },
        loading: () => const LoadingShimmer(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load wishlist',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(wishlistProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<_WishlistProduct>> _loadWishlistProducts(
    WidgetRef ref,
    List<WishlistItem> wishlist,
  ) async {
    final productRepo = ref.read(productRepositoryProvider);
    final products = <_WishlistProduct>[];

    for (final item in wishlist) {
      try {
        final product = await productRepo.getProductById(item.productId);
        products.add(_WishlistProduct(
          wishlistId: item.id,
          product: product,
          addedAt: item.addedAt,
        ));
      } catch (e) {
        // Skip products that can't be loaded
      }
    }

    return products;
  }

  void _removeFromWishlist(BuildContext context, WidgetRef ref, String wishlistId) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.removeFromWishlist(wishlistId);
      ref.invalidate(wishlistProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from wishlist')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showProductDetail(BuildContext context, product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailModal(product: product),
    );
  }
}

class _WishlistProduct {
  final String wishlistId;
  final Product product;
  final DateTime addedAt;

  _WishlistProduct({
    required this.wishlistId,
    required this.product,
    required this.addedAt,
  });
}

class _WishlistItemCard extends StatelessWidget {
  const _WishlistItemCard({
    required this.item,
    required this.onRemove,
    required this.onTap,
  });

  final _WishlistProduct item;
  final VoidCallback onRemove;
  final Function(Product) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item.product),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeTokens.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                color: ThemeTokens.surfaceMuted,
              ),
              child: item.product.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.network(
                        item.product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white54),
                      ),
                    )
                  : const Icon(Icons.image, color: Colors.white54),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: Colors.amber.shade400),
                        const SizedBox(width: 4),
                        Text(
                          item.product.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.product.currency}${item.product.price.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ThemeTokens.accent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

