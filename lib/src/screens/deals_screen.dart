import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

import '../../core/theme_tokens.dart';
import '../models/product_deal.dart';
import '../models/product.dart';
import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';
import '../widgets/product_detail_modal.dart';
import '../../features/search/widgets/smart_preferences_panel.dart';

class DealsScreen extends ConsumerStatefulWidget {
  const DealsScreen({super.key, this.searchQuery});

  final String? searchQuery;

  @override
  ConsumerState<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends ConsumerState<DealsScreen> {
  late Future<List<ProductDeal>> _futureDeals;
  late TextEditingController _searchController;
  
  // Smart Preferences State
  String? _detectedCategory;
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    final providerQuery = ref.read(dealSearchQueryProvider);
    final initialQuery = widget.searchQuery ?? providerQuery ?? '';
    _searchController = TextEditingController(text: initialQuery);
    _searchController.addListener(_onSearchChanged); // Add listener
    _loadDeals();
  }

  void _onSearchChanged() {
    final text = _searchController.text;
    final lowerText = text.toLowerCase();
    
    String? newCategory;
    if (lowerText.contains('laptop')) {
      newCategory = 'Laptop';
    } else if (lowerText.contains('phone') || lowerText.contains('smartphone')) {
      newCategory = 'Phone';
    }

    if (newCategory != _detectedCategory) {
      setState(() {
        _detectedCategory = newCategory;
        if (newCategory == null) {
          _currentFilters = {};
          // Optionally reload deals here if we want to clear filters immediately
        }
      });
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
    });
    _loadDeals(); // Reload with filters
  }

  void _loadDeals() {
    final repo = ref.read(productRepositoryProvider);
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _futureDeals = repo.searchForDeals(query, filters: _currentFilters);
    } else {
      _futureDeals = Future.value([]);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(dealSearchQueryProvider, (previous, next) {
      if (next != null && next.isNotEmpty && next != _searchController.text) {
        setState(() {
          _searchController.text = next;
        });
        _loadDeals();
        ref.read(dealSearchQueryProvider.notifier).state = null;
      }
    });

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        title: const Text('Price Comparison'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search products (type "Phone")...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                             _detectedCategory = null;
                             _currentFilters = {};
                          });
                          _loadDeals();
                        },
                      )
                    : null,
                filled: true,
                fillColor: ThemeTokens.surfaceDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _loadDeals(),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Smart Preferences Panel (Sliver)
          if (_detectedCategory != null)
            SliverToBoxAdapter(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: SmartPreferencesPanel(
                  category: _detectedCategory!,
                  onApply: _applyFilters,
                ),
              ),
            ),

          // 2. Results List (Sliver)
          FutureBuilder<List<ProductDeal>>(
            future: _futureDeals,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(child: LoadingShimmer());
              }

              final deals = snapshot.data!;
              if (deals.isEmpty) {
                return SliverToBoxAdapter(
                  child: EmptyStateCard(
                    title: _searchController.text.isEmpty
                        ? 'Start Your Search'
                        : 'No deals found',
                    message: _searchController.text.isEmpty
                        ? 'Search for a product to compare prices across platforms'
                        : 'Try a different search term or check filters',
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final deal = deals[index];
                      return _ProductComparisonCard(deal: deal);
                    },
                    childCount: deals.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductComparisonCard extends StatelessWidget {
  const _ProductComparisonCard({required this.deal});


  final ProductDeal deal;

  void _openDetail(BuildContext context) {
    // Convert ProductDeal to Product for the modal
    final product = Product(
      id: deal.productId,
      name: deal.modelName,
      brand: deal.brand,
      currency: deal.deals.isNotEmpty ? deal.deals.first.currency : '₹',
      price: deal.deals.isNotEmpty 
          ? deal.deals.map((e) => e.price).reduce(min) 
          : 0,
      image: deal.image,
      rating: deal.rating.toDouble(),
      stores: deal.deals.length,
      comparisons: deal.deals.map((d) => PriceComparison(
        store: d.platform,
        price: d.price,
        shipping: d.delivery == 'Free' ? 0.0 : null,
        rating: null, // DealOffer doesn't have individual rating
      )).toList(),
      priceHistory: [],
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: ProductDetailModal(product: product),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Reduced margin
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceDark,
        borderRadius: BorderRadius.circular(12), // Reduced radius
        boxShadow: [ // Added subtle shadow
          BoxShadow(
             color: Colors.black.withOpacity(0.2),
             blurRadius: 8,
             offset: const Offset(0, 2),
          )
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product header - Compact
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openDetail(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12), // Reduced padding
                child: Row(
                  children: [
                    Container(
                      width: 52, // Reduced image size (64->52)
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ThemeTokens.surfaceMuted,
                        image: deal.image.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(deal.image),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: deal.image.isEmpty
                          ? const Icon(Icons.devices, color: Colors.white54, size: 24)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal.modelName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith( // Reduced font
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                deal.brand,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white70, fontSize: 11),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.star_rounded,
                                  size: 12, color: Colors.amber.shade400),
                              const SizedBox(width: 2),
                              Text(
                                deal.rating.toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Compact badge
                      decoration: BoxDecoration(
                        color: ThemeTokens.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${deal.deals.length} offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: ThemeTokens.primary, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          // Platform comparison cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Reduced
            child: Column(
              children: deal.deals.map((offer) {
                return InkWell(
                  onTap: () async {
                    final urlString = offer.url ?? 'https://www.google.com/search?q=${Uri.encodeComponent('${deal.modelName} ${offer.platform}')}';
                    final url = Uri.parse(urlString);
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                         if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text('Could not open link')),
                            );
                         }
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: _PlatformOfferCard(offer: offer),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for individual platform offer
class _PlatformOfferCard extends StatelessWidget {
  const _PlatformOfferCard({required this.offer});

  final DealOffer offer;

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'amazon':
        return Icons.shopping_bag;
      case 'flipkart':
        return Icons.local_mall;
      case 'myntra':
        return Icons.checkroom;
      case 'croma':
        return Icons.electrical_services;
      case 'reliance digital':
        return Icons.store;
      case 'shopparva':
        return Icons.storefront;
      default:
        return Icons.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: offer.isBestPrice
            ? ThemeTokens.accent.withOpacity(0.1)
            : ThemeTokens.surfaceMuted.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: offer.isBestPrice
            ? Border.all(color: ThemeTokens.accent, width: 2)
            : null,
      ),
      child: Row(
        children: [
          // Platform icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getPlatformIcon(offer.platform),
              color: Colors.white70,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      offer.platform,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (offer.isBestPrice) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: ThemeTokens.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'BEST PRICE',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  offer.seller,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (offer.discount != null && offer.discount!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: ThemeTokens.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        offer.discount!,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: ThemeTokens.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  if (offer.discount != null && offer.discount!.isNotEmpty)
                    const SizedBox(width: 8),
                  Text(
                    '${offer.currency.replaceAll('\$', '₹')}${offer.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: offer.isBestPrice
                              ? ThemeTokens.accent
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              if (offer.delivery != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    offer.delivery!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white54, fontSize: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.open_in_new,
            size: 16,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
