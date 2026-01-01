import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme_tokens.dart';
import '../models/product.dart';

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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20, // Increased spacing
            crossAxisSpacing: 20, // Increased spacing
            childAspectRatio: 0.80, // Shorter cards (25% reduction approx)
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => onProductTap(product),
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceColor = ThemeTokens.accent;
    final vsStores = product.stores > 0 ? 'vs ${product.stores}' : ''; // Shorter text

    return Semantics(
      button: true,
      label: product.name,
      child: InkWell(
        borderRadius: BorderRadius.circular(16), // Slightly tighter radius
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: ThemeTokens.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4), // Softer shadow
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Padding(
                padding: const EdgeInsets.all(10), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 13, // Reduced font
                        height: 1.2,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
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
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.currency.isNotEmpty ? product.currency.replaceAll('\$', '₹') : '₹'}${product.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith( // Smaller price title
                            color: priceColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15, 
                          ),
                        ),
                        if (vsStores.isNotEmpty)
                          Text(
                            vsStores,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white38, fontSize: 10
                            ),
                          ),
                      ],
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
