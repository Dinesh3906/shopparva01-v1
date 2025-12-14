import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../state/app_providers.dart';
import '../widgets/kit_item_row.dart';
import 'optimized_kit_screen.dart';

// --- Data Models ---
class KitItemDefinition {
  final String id;
  final String label;
  final String subtitle;
  final double price;
  final String preferenceLabel;
  final List<String> preferences;

  const KitItemDefinition({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.price,
    required this.preferenceLabel,
    required this.preferences,
  });
}

// --- Data Definitions ---
const Map<String, List<KitItemDefinition>> _categoryItems = {
  'Cosmetics': [
    KitItemDefinition(
      id: 'lipstick',
      label: 'Lipstick',
      subtitle: '₹1,500',
      price: 1500,
      preferenceLabel: 'Shade',
      preferences: ['Red', 'Nude', 'Pink', 'Berry'],
    ),
    KitItemDefinition(
      id: 'foundation',
      label: 'Foundation',
      subtitle: '₹2,200',
      price: 2200,
      preferenceLabel: 'Skin Tone',
      preferences: ['Fair', 'Light', 'Medium', 'Tan', 'Deep'],
    ),
    KitItemDefinition(
      id: 'compact',
      label: 'Compact Powder',
      subtitle: '₹950',
      price: 950,
      preferenceLabel: 'Finish',
      preferences: ['Matte', 'Natural', 'Dewy'],
    ),
    KitItemDefinition(
      id: 'blush',
      label: 'Blush',
      subtitle: '₹1,200',
      price: 1200,
      preferenceLabel: 'Color',
      preferences: ['Peach', 'Rose', 'Coral'],
    ),
    KitItemDefinition(
      id: 'mascara',
      label: 'Mascara',
      subtitle: '₹800',
      price: 800,
      preferenceLabel: 'Type',
      preferences: ['Volumizing', 'Lengthening', 'Waterproof'],
    ),
  ],
  'Gaming': [
    KitItemDefinition(
      id: 'console',
      label: 'Gaming Console',
      subtitle: '₹49,990',
      price: 49990,
      preferenceLabel: 'Edition',
      preferences: ['Standard', 'Digital'],
    ),
    KitItemDefinition(
      id: 'controller',
      label: 'Extra Controller',
      subtitle: '₹5,500',
      price: 5500,
      preferenceLabel: 'Color',
      preferences: ['Black', 'White', 'Red', 'Blue'],
    ),
    KitItemDefinition(
      id: 'headset',
      label: 'Gaming Headset',
      subtitle: '₹8,990',
      price: 8990,
      preferenceLabel: 'Type',
      preferences: ['Wired', 'Wireless'],
    ),
    KitItemDefinition(
      id: 'game_title',
      label: 'Top Game Title',
      subtitle: '₹4,500',
      price: 4500,
      preferenceLabel: 'Genre',
      preferences: ['Action', 'RPG', 'Sports', 'Shooter'],
    ),
    KitItemDefinition(
      id: 'monitor',
      label: 'Gaming Monitor',
      subtitle: '₹22,000',
      price: 22000,
      preferenceLabel: 'Size',
      preferences: ['24 inch', '27 inch', '32 inch'],
    ),
  ],
  'Fitness': [
    KitItemDefinition(
      id: 'yoga_mat',
      label: 'Yoga Mat',
      subtitle: '₹1,500',
      price: 1500,
      preferenceLabel: 'Thickness',
      preferences: ['4mm', '6mm', '10mm'],
    ),
    KitItemDefinition(
      id: 'dumbbells',
      label: 'Dumbbells Set',
      subtitle: '₹3,500',
      price: 3500,
      preferenceLabel: 'Weight',
      preferences: ['2kg', '5kg', '10kg'],
    ),
    KitItemDefinition(
      id: 'resistance_bands',
      label: 'Resistance Bands',
      subtitle: '₹800',
      price: 800,
      preferenceLabel: 'Strength',
      preferences: ['Light', 'Medium', 'Heavy'],
    ),
    KitItemDefinition(
      id: 'protein',
      label: 'Whey Protein',
      subtitle: '₹3,200',
      price: 3200,
      preferenceLabel: 'Flavor',
      preferences: ['Chocolate', 'Vanilla', 'Strawberry'],
    ),
    KitItemDefinition(
      id: 'smartwatch',
      label: 'Fitness Tracker',
      subtitle: '₹4,500',
      price: 4500,
      preferenceLabel: 'Color',
      preferences: ['Black', 'Blue', 'Pink'],
    ),
  ],
  'Travel': [
    KitItemDefinition(
      id: 'backpack',
      label: 'Travel Backpack',
      subtitle: '₹3,500',
      price: 3500,
      preferenceLabel: 'Capacity',
      preferences: ['30L', '40L', '50L'],
    ),
    KitItemDefinition(
      id: 'neck_pillow',
      label: 'Neck Pillow',
      subtitle: '₹900',
      price: 900,
      preferenceLabel: 'Material',
      preferences: ['Memory Foam', 'Microbeads'],
    ),
    KitItemDefinition(
      id: 'powerbank',
      label: 'Power Bank',
      subtitle: '₹2,000',
      price: 2000,
      preferenceLabel: 'Capacity',
      preferences: ['10000mAh', '20000mAh'],
    ),
    KitItemDefinition(
      id: 'adapter',
      label: 'Universal Adapter',
      subtitle: '₹1,200',
      price: 1200,
      preferenceLabel: 'Type',
      preferences: ['Type C', 'Multi-port'],
    ),
    KitItemDefinition(
      id: 'toiletry_bag',
      label: 'Toiletry Kit',
      subtitle: '₹800',
      price: 800,
      preferenceLabel: 'Size',
      preferences: ['Small', 'Large'],
    ),
  ],
};

class MakeMyKitScreen extends ConsumerStatefulWidget {
  const MakeMyKitScreen({super.key});

  @override
  ConsumerState<MakeMyKitScreen> createState() => _MakeMyKitScreenState();
}

class _MakeMyKitScreenState extends ConsumerState<MakeMyKitScreen> {
  final List<String> _categories = _categoryItems.keys.toList();
  int _selectedCategoryIndex = 0;
  
  // State: One map per category to persist selections when switching tabs? 
  // Requirement: "On category change: The previously selected category’s sub-options should be replaced."
  // Usually this means we track state PER category so user can jump back and forth, 
  // OR we reset. Let's persist for better UX.
  final Map<String, Set<String>> _selectedItemIds = {};
  final Map<String, Map<String, String>> _itemPreferences = {};
  
  static const double _maxBudget = 100000;

  @override
  void initState() {
    super.initState();
    // Initialize state containers
    for (final cat in _categories) {
      _selectedItemIds[cat] = {};
      _itemPreferences[cat] = {};
    }
    // Auto-select first category in provider if needed, or just sync local index
  }

  String get _currentCategory => _categories[_selectedCategoryIndex];

  List<KitItemDefinition> get _currentItems => 
      _categoryItems[_currentCategory] ?? [];

  Set<String> get _currentSelections => _selectedItemIds[_currentCategory]!;
  Map<String, String> get _currentPreferences => _itemPreferences[_currentCategory]!;

  double get _currentTotalCost {
    double total = 0;
    for (final item in _currentItems) {
      if (_currentSelections.contains(item.id)) {
        total += item.price;
      }
    }
    return total;
  }



  void _toggleItem(KitItemDefinition item, bool selected) {
    if (selected) {
      if (_currentTotalCost + item.price > _maxBudget) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Budget limit exceeded! Remove items to add this one.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }
      setState(() {
        _currentSelections.add(item.id);
      });
    } else {
      setState(() {
        _currentSelections.remove(item.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final budgetUsagePercent = (_currentTotalCost / _maxBudget).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        title: const Text('Make My Kit'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Category Selector
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Choose a category to build your kit.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < _categories.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(_categories[i]),
                              selected: _selectedCategoryIndex == i,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedCategoryIndex = i);
                                  // Update provider if needed downstream
                                  ref.read(currentCategoryProvider.notifier).state =
                                      _categories[i];
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Items',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        '${_currentSelections.length} Selected',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Dynamic Items List
                  if (_currentItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Coming soon for this category!', style: TextStyle(color: Colors.white54))),
                    )
                  else
                    ..._currentItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: KitItemRow(
                          label: item.label,
                          subtitle: item.subtitle, // Display formatted price
                          selected: _currentSelections.contains(item.id),
                          onSelectedChanged: (v) => _toggleItem(item, v),
                          preferenceLabel: item.preferenceLabel,
                          preferenceValue: _currentPreferences[item.id],
                          onPreferenceTap: () => _selectPreference(
                            context,
                            key: item.id,
                            options: item.preferences,
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),

            // Bottom Section: Budget & Action
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeTokens.surfaceDark,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Budget Used',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '₹${_currentTotalCost.toStringAsFixed(0)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: budgetUsagePercent > 0.9 ? Colors.redAccent : ThemeTokens.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' / ₹${_maxBudget.toStringAsFixed(0)}',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: budgetUsagePercent,
                    backgroundColor: Colors.white10,
                    color: budgetUsagePercent > 0.9 ? Colors.redAccent : ThemeTokens.accent,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: userAsync.when(
                      data: (user) => FilledButton(
                        onPressed: _currentSelections.isEmpty
                            ? null
                            : () => _generateKit(context, user.id),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: ThemeTokens.accent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Generate ${_categories[_selectedCategoryIndex]} Kit'),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Text('Error loading profile'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPreference(
    BuildContext context, {
    required String key,
    required List<String> options,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: ThemeTokens.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Select Option', style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final o in options)
              ListTile(
                title: Text(o),
                onTap: () => Navigator.of(context).pop(o),
              ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() => _currentPreferences[key] = selected);
    }
  }

  Future<void> _generateKit(BuildContext context, String userId) async {
    final repo = ref.read(kitRepositoryProvider);

    final selections = <Map<String, dynamic>>[];
    for (final id in _currentSelections) {
      selections.add({
        'itemId': id,
        'preferences': _currentPreferences[id],
        // Pass price so backend knows (optional, depending on backend logic)
        'estimatedPrice': _currentItems.firstWhere((i) => i.id == id).price,
      });
    }

    try {
      // Show loading? The button doesn't toggle loading state here but async gap protects it slightly
      
      final kit = await repo.generateKit(
        userId: userId,
        category: _categories[_selectedCategoryIndex],
        selections: selections,
        budget: _currentTotalCost, // Using actual cost as the budget input for generation logic
      );

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => OptimizedKitScreen(kit: kit),
        ),
      );
    } catch (e) {
      debugPrint('Error generating kit: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Failed to generate kit: $e')),
      );
    }
  }
}
