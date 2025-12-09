import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/ar_try_on_screen.dart';
import 'src/screens/deals_screen.dart';
import 'src/screens/make_my_kit_screen.dart';
import 'src/screens/price_tracker_screen.dart';
import 'src/screens/search_screen.dart';
import 'src/state/app_providers.dart';
import 'src/widgets/bottom_nav_bar.dart';
import 'src/widgets/empty_and_loading.dart';
import 'src/widgets/floating_assistant_button.dart';

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
      darkTheme: isHighContrast
          ? AppTheme.highContrastDarkTheme
          : AppTheme.darkTheme,
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
  int _currentIndex = 0;

  late final AnimationController _assistantController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _assistantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const DealsScreen(),
      const MakeMyKitScreen(),
      const ArTryOnScreen(),
      const PriceTrackerScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingAssistantButton(
        controller: _assistantController,
        onPressed: () {
          // Placeholder for AI assistant panel
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
