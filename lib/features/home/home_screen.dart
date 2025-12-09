import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../state/providers.dart';
import 'widgets/product_card.dart';
import '../../core/theme_tokens.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'All';
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final homeFeed = ref.watch(homeFeedProvider);
    final user = ref.watch(userStateProvider);
    
    // Theme Colors from Tokens
    const backgroundColor = ThemeTokens.backgroundDark;
    const surfaceColor = ThemeTokens.surfaceDark;
    const accentColor = ThemeTokens.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Top Search Bar
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search, color: ThemeTokens.neutral500),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Search products...',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          fontFamily: GoogleFonts.inter().fontFamily,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.mic, color: ThemeTokens.neutral500),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // AI Assistant Bubble
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    accentColor,
                                    accentColor.withValues(alpha: 0.7),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (_) => AlertDialog(
                                    title: const Text("Shopping Assistant"),
                                    content: const Text("I can help you find the best deals! Try searching for a brand like 'Sony' or 'Apple'."),
                                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
                                  ));
                                },
                                child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // 2. Greeting Section (Dynamic)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello ${user?.name ?? 'Guest'} 👋',
                              style: ThemeTokens.headlineLarge.copyWith(color: Colors.white, fontSize: 28),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Let's find the best deals for you.",
                              style: ThemeTokens.bodyMedium.copyWith(
                                color: Colors.white.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // 3. Category Chips (Scrollable Row - Dynamic)
                        homeFeed.when(
                          data: (products) {
                            // Extract unique categories from products
                            final allCategories = {'All', ...products.expand((p) => p.categories)}.toList();
                            return SizedBox(
                              height: 40,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: allCategories.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final cat = allCategories[index];
                                  final isSelected = cat == _selectedCategory;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedCategory = cat),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? accentColor.withValues(
                                                alpha: 0.1,
                                              )
                                            : surfaceColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected ? accentColor : Colors.transparent,
                                          width: 1.5,
                                        ),
                                        boxShadow: isSelected ? [
                                          BoxShadow(
                                            color: accentColor.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 0,
                                          ) 
                                        ] : [],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          color: isSelected ? accentColor : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: GoogleFonts.inter().fontFamily,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => const SizedBox(height: 40),
                          error: (_, __) => const SizedBox(),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // 4. "Smart Deals For You" Section Title
                        Text(
                          "Smart Deals For You",
                          style: ThemeTokens.headlineMedium.copyWith(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Smart Deals Grid
                homeFeed.when(
                  data: (products) {
                     final filteredProducts = _selectedCategory == 'All'
                        ? products
                        : products.where((p) => p.categories.contains(_selectedCategory)).toList();
                        
                    if (filteredProducts.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Text(
                                'No products found.',
                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                           return ProductCard(
                             product: filteredProducts[index],
                             onTap: () => context.push('/product/${filteredProducts[index].id}'),
                           );
                        },
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                     child: SizedBox(
                       height: 200,
                       child: Center(child: CircularProgressIndicator(color: ThemeTokens.primary)),
                     )
                  ),
                  error: (e, s) => SliverToBoxAdapter(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
                ),
                
                // Bottom Spacing
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ],
        ),
      ),
      // 5. Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open settings/filter
        },
        backgroundColor: surfaceColor,
        foregroundColor: accentColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(
                  alpha: 0.2,
                ),
                blurRadius: 10,
              )
            ]
          ),
          child: const Icon(Icons.settings),
        ),
      ),
      // 6. Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF151925),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0, isActive: _bottomNavIndex == 0),
            _buildNavItem(Icons.local_offer, "Deals", 1, isActive: _bottomNavIndex == 1),
            _buildNavItem(Icons.inventory_2, "Kits", 2, isActive: _bottomNavIndex == 2),
            _buildNavItem(Icons.view_in_ar, "AR Try", 3, isActive: _bottomNavIndex == 3),
            _buildNavItem(Icons.person, "Profile", 4, isActive: _bottomNavIndex == 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isActive = false}) {
    final color = isActive
        ? ThemeTokens.primary
        : Colors.white.withValues(
            alpha: 0.5,
          );
    return InkWell(
      onTap: () {
        setState(() => _bottomNavIndex = index);
        if (index == 2) context.push('/kit-builder'); 
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
