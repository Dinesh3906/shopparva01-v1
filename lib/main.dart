import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/ar_try_on_screen.dart';
import 'core/theme_tokens.dart';
import 'src/screens/deals_screen.dart';
import 'src/screens/make_my_kit_screen.dart';
import 'src/screens/profile_screen.dart';
import 'src/screens/search_screen.dart';
import 'src/screens/cart_screen.dart';
import 'src/screens/price_tracker_screen.dart';
import 'src/state/app_providers.dart';
import 'src/widgets/bottom_nav_bar.dart';
import 'src/widgets/empty_and_loading.dart';
import 'src/widgets/floating_assistant_button.dart';
import 'package:shopparva/models/product.dart';
import 'src/state/fab_state.dart';
import 'src/widgets/assistant_sheet.dart';

void main() {
  runApp(const ProviderScope(child: ShopparvaApp()));
}

class ShopparvaApp extends ConsumerWidget {
  const ShopparvaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHighContrast = ref.watch(highContrastProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: isHighContrast
          ? AppTheme.highContrastLightTheme
          : AppTheme.lightTheme,
      darkTheme:
          isHighContrast ? AppTheme.highContrastDarkTheme : AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const _RootShell(),
      routes: {
        // Storybook-style preview routes
        '/storybook/home': (_) => const HomeScreen(),
        '/storybook/search': (_) => const SearchScreen(initialQuery: 'Laptop'),
        '/storybook/make-my-kit': (_) => const MakeMyKitScreen(),
        '/storybook/ar-try': (_) => const ArTryOnScreen(),
        '/storybook/empty': (_) => const Scaffold(
              body: EmptyStateCard(
                title: 'No products found',
                message: 'This is the empty state preview.',
              ),
            ),
        '/storybook/loading': (_) => const Scaffold(body: LoadingShimmer()),
      },
    );
  }
}

class _RootShell extends ConsumerStatefulWidget {
  const _RootShell();

  @override
  ConsumerState<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends ConsumerState<_RootShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _assistantController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    // Listen to dealSearchQueryProvider to switch to Deals tab
    ref.listenManual(dealSearchQueryProvider, (previous, next) {
      if (next != null && next.isNotEmpty) {
        ref.read(navigationIndexProvider.notifier).state = 1; // Switch to Deals tab
      }
    });
  }

  @override
  void dispose() {
    _assistantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final shouldHighlightFab = ref.watch(fabHighlightProvider);
    
    final pages = [
      const HomeScreen(),
      const DealsScreen(),
      const MakeMyKitScreen(),
      const ArTryOnScreen(),
      const ProfileScreen(),
      const CartScreen(),
      const PriceTrackerScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: currentIndex == 0
          ? _buildHomeFab(shouldHighlightFab)
          : FloatingAssistantButton(
              controller: _assistantController,
              onPressed: _showAssistant,
            ),
    );
  }

  Widget _buildHomeFab(bool highlight) {
    return Container(
      decoration: highlight ? BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ThemeTokens.primary.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 4,
          )
        ],
        shape: BoxShape.circle,
      ) : null,
      child: FloatingActionButton(
        onPressed: () {
          // Add a dummy product or show modal
          // For demo: Add "iPhone 16" to tracker if not tracked
          _simulateAddProduct();
        },
        backgroundColor: ThemeTokens.primary, // Teal
        shape: const CircleBorder(),
        child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
      ),
    );
  }
  
  void _simulateAddProduct() {
    // Demo implementation: Find a product and track it
    // In real app: Open camera or search
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulating Scan... Product added to Price Tracker!')),
    );
    
    // Track a dummy product for demo
    final product = Product(
        id: 'demo-tracked-${DateTime.now().millisecondsSinceEpoch}',
        name: 'Scanned Product ${DateTime.now().second}',
        price: 45000,
        image: 'https://via.placeholder.com/150',
        brand: 'Demo Brand',
        categories: ['Electronics'],
        description: 'Scanned item',
        rating: 4.5,
        stores: 1,
    );
    
    ref.read(trackedProductsNotifierProvider.notifier).trackProduct(product);
  }

  void _showAssistant() {
    // AI Assistant Chat Interface
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ThemeTokens.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const AssistantSheet(),
    );
  }
}
