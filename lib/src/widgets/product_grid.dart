import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme_tokens.dart';
import '../state/app_providers.dart';
import 'package:shopparva/models/product.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        final crossAxisCount = isTablet ? 3 : 2;
        return GridView.builder(
          // Breathable spacing + bottom padding
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.56, // Taller cards to fit new action buttons
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return RepaintBoundary(
              child: ProductCard(
                product: product,
                onTap: () => onProductTap(product),
              ),
            );
          },
        );
      },
    );
  }
}

/// Wrapper that adds a subtle scale-down press animation for tap feedback
class _TappableCard extends StatefulWidget {
  const _TappableCard({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<_TappableCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final priceColor = ThemeTokens.accent;
    final vsStores = product.stores > 0 ? 'vs ${product.stores}' : '';

    return Semantics(
      button: true,
      label: product.name,
      child: _TappableCard(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeTokens.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 18,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, _) => Container(
                      color: ThemeTokens.surfaceMuted,
                    ),
                    errorWidget: (context, _, __) => Container(
                      color: ThemeTokens.surfaceMuted,
                      child: const Icon(Icons.image_not_supported_rounded,
                          color: Colors.white38),
                    ),
                  ),
                ),
              ),
              // Details Section
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.2,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 14, color: Colors.amber.shade400),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.white70, fontSize: 11),
                        ),
                        const Spacer(),
                        if (vsStores.isNotEmpty)
                          Text(
                            vsStores,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white38, fontSize: 10
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.currency.isNotEmpty ? product.currency.replaceAll('\$', '₹') : '₹'}${product.price.toStringAsFixed(0)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: priceColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions Section (Add to Cart / Buy Now)
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
                ),
                child: Row(
                  children: [
                    // Add to Cart Button
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          ref.read(cartProvider.notifier).addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.white70),
                        ),
                      ),
                    ),
                    Container(height: 24, width: 1, color: Colors.white.withOpacity(0.08)),
                    // Buy Now Button
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () async {
                          final comparisons = product.comparisons ?? const [];
                          String? cheapestUrl;
                          String cheapestStore = '';
                          double cheapestPrice = double.infinity;

                          if (comparisons.isNotEmpty) {
                            for (final c in comparisons) {
                              if (c.price < cheapestPrice) {
                                cheapestPrice = c.price;
                                cheapestStore = c.store;
                              }
                            }
                          }

                          if (cheapestStore.isNotEmpty) {
                            final query = Uri.encodeComponent('${product.name} $cheapestStore buy');
                            cheapestUrl = 'https://www.google.com/search?q=$query';
                          } else {
                            final query = Uri.encodeComponent(product.name);
                            cheapestUrl = 'https://www.google.com/search?q=$query&tbm=shop';
                          }

                          final url = Uri.parse(cheapestUrl);
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
                            }
                          }
                        },
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: ThemeTokens.accent.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.flash_on_rounded, size: 16, color: ThemeTokens.accent),
                              const SizedBox(width: 4),
                              Text(
                                'Buy Now',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: ThemeTokens.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
