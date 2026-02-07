import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme_tokens.dart';
import '../state/app_providers.dart';
import 'package:shopparva/models/product.dart';

// --- Data Models ---

class KitVariantOption {
  final String title;
  final List<String> choices;
  const KitVariantOption(this.title, this.choices);
}

class KitItemDefinition {
  final String id;
  final String label;
  final String subtitle;
  final double estimatedCost;
  final String priority;
  final List<KitVariantOption> variants;

  const KitItemDefinition({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.estimatedCost,
    required this.priority,
    required this.variants,
  });
}

// --- Data Definitions ---
const Map<String, List<KitItemDefinition>> _categoryItems = {
  'Cosmetics': [
    KitItemDefinition(
      id: 'foundation',
      label: 'Foundation',
      subtitle: 'Base Layer',
      estimatedCost: 2200,
      priority: 'high',
      variants: [
        KitVariantOption('Shade Match', ['Fair', 'Light', 'Medium', 'Tan', 'Deep', 'Custom']),
        KitVariantOption('Skin Type', ['Oily', 'Dry', 'Combination']),
        KitVariantOption('Coverage', ['Light', 'Medium', 'Full']),
      ],
    ),
    KitItemDefinition(
      id: 'lipstick',
      label: 'Lipstick',
      subtitle: 'Color Pop',
      estimatedCost: 1500,
      priority: 'medium',
      variants: [
        KitVariantOption('Finish', ['Matte', 'Gloss', 'Cream']),
        KitVariantOption('Color Tone', ['Red', 'Nude', 'Pink', 'Wine']),
        KitVariantOption('Long-Wear', ['Yes', 'No']),
      ],
    ),
    KitItemDefinition(
      id: 'compact',
      label: 'Compact Powder',
      subtitle: 'Finish',
      estimatedCost: 950,
      priority: 'medium',
      variants: [
        KitVariantOption('Finish', ['Matte', 'HD', 'Natural']),
        KitVariantOption('Skin Type', ['Oily', 'Dry', 'Normal']),
      ],
    ),
    KitItemDefinition(
      id: 'blush',
      label: 'Blush',
      subtitle: 'Color',
      estimatedCost: 1200,
      priority: 'low',
      variants: [
        KitVariantOption('Texture', ['Powder', 'Cream', 'Liquid']),
        KitVariantOption('Tone', ['Peach', 'Pink', 'Coral']),
      ],
    ),
    KitItemDefinition(
      id: 'mascara',
      label: 'Mascara',
      subtitle: 'Lashes',
      estimatedCost: 800,
      priority: 'low',
      variants: [
        KitVariantOption('Type', ['Volumizing', 'Lengthening', 'Waterproof']),
      ],
    ),
  ],
};

// --- Providers ---
final kitBudgetProvider = StateProvider<double>((ref) => 5000);
// Store selected item IDs
final kitSelectionsProvider = StateProvider<Set<String>>((ref) => {});
// Store variant selections: ItemID -> { VariantTitle -> Choice }
final kitVariantSelectionsProvider = StateProvider<Map<String, Map<String, String>>>((ref) => {});

class MakeMyKitScreen extends ConsumerStatefulWidget {
  const MakeMyKitScreen({super.key});

  @override
  ConsumerState<MakeMyKitScreen> createState() => _MakeMyKitScreenState();
}

class _MakeMyKitScreenState extends ConsumerState<MakeMyKitScreen> {
  final String _selectedCategory = 'Cosmetics';

  @override
  Widget build(BuildContext context) {
    final budget = ref.watch(kitBudgetProvider);
    final selections = ref.watch(kitSelectionsProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, budget),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                   Text(
                    'SELECT ESSENTIALS',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...(_categoryItems[_selectedCategory] ?? []).map((item) {
                    return _KitItemCard(item: item);
                  }),
                ],
              ),
            ),
            _buildGenerateButton(context, budget, selections),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double budget) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: ThemeTokens.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Make My Kit',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeTokens.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ThemeTokens.primary.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: ThemeTokens.primary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'AI Powered',
                      style: GoogleFonts.inter(
                          color: ThemeTokens.primary, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL BUDGET', style: GoogleFonts.inter(color: Colors.white54, fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w400, color: ThemeTokens.primary)),
                  const SizedBox(width: 4),
                  Text(budget.toStringAsFixed(0), style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ThemeTokens.primary,
              inactiveTrackColor: ThemeTokens.surfaceMuted,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              thumbColor: Colors.white,
              overlayColor: ThemeTokens.primary.withOpacity(0.2),
            ),
            child: Slider(
              value: budget,
              min: 500,
              max: 50000,
              divisions: 100,
              onChanged: (value) => ref.read(kitBudgetProvider.notifier).state = value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context, double budget, Set<String> selections) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      decoration: BoxDecoration(
        color: ThemeTokens.backgroundDark,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: selections.isEmpty ? null : () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _KitPreviewModal(budget: budget, selections: selections),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeTokens.primary,
            foregroundColor: Colors.black,
            disabledBackgroundColor: ThemeTokens.surfaceMuted,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            shadowColor: ThemeTokens.primary.withOpacity(0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Generate Kit', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              if (selections.isNotEmpty) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class _KitItemCard extends ConsumerWidget {
  final KitItemDefinition item;

  const _KitItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selections = ref.watch(kitSelectionsProvider);
    final variantSelections = ref.watch(kitVariantSelectionsProvider);
    final isSelected = selections.contains(item.id);

    return GestureDetector(
      onTap: () {
        final current = ref.read(kitSelectionsProvider);
        if (current.contains(item.id)) {
           // Deselect logic if needed, or just stay to expand
           // Requirement says: "The user can select any combination... selected options should glow"
           // Let's implement toggle.
           ref.read(kitSelectionsProvider.notifier).state = {...current}..remove(item.id);
        } else {
           ref.read(kitSelectionsProvider.notifier).state = {...current, item.id};
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? ThemeTokens.primary.withOpacity(0.08) : ThemeTokens.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? ThemeTokens.primary : Colors.white.withOpacity(0.05),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: ThemeTokens.primary.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ThemeTokens.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory_2_outlined, color: Colors.white54, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      Text(item.subtitle, style: GoogleFonts.inter(fontSize: 11, color: Colors.white54)),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? ThemeTokens.primary : Colors.transparent,
                    border: Border.all(color: isSelected ? ThemeTokens.primary : Colors.white24, width: 1.5),
                  ),
                  child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.black) : null,
                ),
              ],
            ),
            
            // Accordion for Variants
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: isSelected ? null : 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 8),
                      ...item.variants.map((v) {
                         final currentMap = variantSelections[item.id] ?? {};
                         final currentChoice = currentMap[v.title];
                         
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(v.title, style: GoogleFonts.inter(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                             const SizedBox(height: 8),
                             Wrap(
                               spacing: 8,
                               runSpacing: 8,
                               children: v.choices.map((choice) {
                                 final isChoiceSelected = currentChoice == choice;
                                 return GestureDetector(
                                   onTap: () {
                                     // Update Variant Selection
                                     final oldMap = ref.read(kitVariantSelectionsProvider);
                                     final newMap = Map<String, Map<String, String>>.from(oldMap);
                                     
                                     if (!newMap.containsKey(item.id)) newMap[item.id] = {};
                                     newMap[item.id]![v.title] = choice;
                                     
                                     ref.read(kitVariantSelectionsProvider.notifier).state = newMap;
                                   },
                                   child: AnimatedContainer(
                                     duration: const Duration(milliseconds: 200),
                                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                     decoration: BoxDecoration(
                                       color: isChoiceSelected ? ThemeTokens.primary.withOpacity(0.2) : Colors.transparent,
                                       borderRadius: BorderRadius.circular(20),
                                       border: Border.all(
                                         color: isChoiceSelected ? ThemeTokens.primary : Colors.white24,
                                       ),
                                     ),
                                     child: Text(
                                       choice,
                                       style: GoogleFonts.inter(
                                         color: isChoiceSelected ? ThemeTokens.primary : Colors.white70,
                                         fontSize: 10,
                                         fontWeight: isChoiceSelected ? FontWeight.w600 : FontWeight.normal,
                                       ),
                                     ),
                                   ),
                                 );
                               }).toList(),
                             ),
                             const SizedBox(height: 12),
                           ],
                         );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KitPreviewModal extends ConsumerWidget {
  final double budget;
  final Set<String> selections;
  const _KitPreviewModal({required this.budget, required this.selections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _categoryItems['Cosmetics']!.where((i) => selections.contains(i.id)).toList();
    final variants = ref.watch(kitVariantSelectionsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: ThemeTokens.backgroundDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: ThemeTokens.primary, size: 48),
                const SizedBox(height: 16),
                Text('Perfect Match Found!', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Optimized for your ₹${budget.toStringAsFixed(0)} budget', style: GoogleFonts.inter(color: ThemeTokens.primary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final itemVariants = variants[item.id] ?? {};
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                            color: ThemeTokens.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12)),
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white54),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                            if (itemVariants.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Wrap(
                                  spacing: 4,
                                  children: itemVariants.entries.map((e) => Text(
                                    '${e.value} · ',
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
                                  )).toList(),
                                ),
                              )
                            else 
                               Text('Optimized · ${item.priority.toUpperCase()}', style: GoogleFonts.inter(fontSize: 12, color: Colors.white54)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_outline, color: ThemeTokens.success),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {
                // Add items to cart
                final cartNotifier = ref.read(cartProvider.notifier);
                
                for (final item in items) {
                  // Create a mock product from the kit item definition
                  final product = Product(
                    id: 'kit-${item.id}', // unique prefix
                    name: item.label,
                    brand: 'ShopParva Kit', // Mock brand
                    price: item.estimatedCost,
                    image: '', // Placeholder, will show default icon
                    rating: 5.0,
                    stores: 1,
                    description: 'Part of your custom makeup kit: ${item.subtitle}',
                    categories: ['Kit', 'Cosmetics'], // Mock categories
                    offers: [],
                    priceHistory: [],
                  );
                  cartNotifier.addToCart(product);
                }

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${items.length} items to cart!'),
                      backgroundColor: ThemeTokens.success,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: Text('Add Kit to Cart', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
