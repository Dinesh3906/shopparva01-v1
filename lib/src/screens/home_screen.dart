import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../models/product.dart';
import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';
import '../widgets/product_detail_modal.dart';
import '../widgets/product_grid.dart';
import 'price_tracker_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = const [
    'All',
    'Electronics',
    'Fashion',
    'Sports',
    'Beauty',
    'Essentials',
  ];
  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);
    final dealsAsync = ref.watch(smartDealsProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildTopBar(context, userAsync),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBar(context),
            ),
            const SizedBox(height: 12),
            _buildCategoryChips(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Smart Deals For You',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                  IconButton(
                    tooltip: 'Price Tracker',
                    icon: const Icon(Icons.show_chart_rounded,
                        color: Colors.white70),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PriceTrackerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: dealsAsync.when(
                data: (products) => products.isEmpty
                    ? const EmptyStateCard(
                        title: 'No products found',
                        message:
                            'Try adjusting your filters or searching for something else.',
                      )
                    : ProductGrid(
                        products: products,
                        onProductTap: (product) => _openProductDetail(context, product),
                      ),
                loading: () => const LoadingShimmer(),
                error: (_, __) => const EmptyStateCard(
                  title: 'Something went wrong',
                  message: 'We could not load your deals. Please try again.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context, AsyncValue<dynamic> userAsync) {
    final greeting = userAsync.when<String>(
      data: (user) => 'Hello ${user.name} 👋',
      loading: () => 'Hello Luffy 👋',
      error: (_, __) => 'Hello Luffy 👋',
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "Let's find the best deals for you.",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 20,
          backgroundColor: ThemeTokens.surfaceMuted,
          child: const Icon(Icons.person_rounded, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ThemeTokens.surfaceDark,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Colors.white54),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search products…',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                      ref.read(searchQueryProvider.notifier).state = value;
                      // In a real app we would navigate to SearchScreen, but
                      // Antigravity can wire this via storybook routes.
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: ThemeTokens.surfaceDark,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.mic_none_rounded, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategoryIndex = index);
              // Category filtering could call ProductRepository with category
            },
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: selected ? 1.05 : 1.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected
                      ? ThemeTokens.surfaceDark
                      : ThemeTokens.surfaceMuted,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: selected
                        ? ThemeTokens.primary.withOpacity(0.8)
                        : Colors.white24,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: ThemeTokens.primary.withOpacity(0.5),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(
                    child: Text(
                      _categories[index],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openProductDetail(BuildContext context, Product product) {
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
}
