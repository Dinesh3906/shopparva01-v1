import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../state/app_providers.dart';
import '../widgets/kit_item_row.dart';
import 'optimized_kit_screen.dart';

class MakeMyKitScreen extends ConsumerStatefulWidget {
  const MakeMyKitScreen({super.key});

  @override
  ConsumerState<MakeMyKitScreen> createState() => _MakeMyKitScreenState();
}

class _MakeMyKitScreenState extends ConsumerState<MakeMyKitScreen> {
  final List<String> _categories = const [
    'Cosmetics',
    'Gaming',
    'Fitness',
    'Travel',
  ];
  int _selectedCategoryIndex = 0;

  final Map<String, bool> _selectedItems = {
    'lipstick': true,
    'foundation': false,
    'compact': false,
    'blush': false,
  };

  final Map<String, String?> _preferences = {
    'lipstick': null,
    'foundation': null,
    'compact': null,
    'blush': null,
  };

  double _budget = 80;

  int get _selectedCount =>
      _selectedItems.values.where((selected) => selected).length;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        title: const Text('Make My Kit'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose the category you want to build your kit for.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              _buildCategoryChips(context),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Build Your Cosmetics Kit',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white.withOpacity(0.9)),
                  ),
                  Text(
                    '$_selectedCount/5 Selected',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      KitItemRow(
                        label: 'Lipstick',
                        subtitle: 'Choose Shade',
                        selected: _selectedItems['lipstick']!,
                        onSelectedChanged: (v) => setState(() =>
                            _selectedItems['lipstick'] = v),
                        preferenceLabel: 'Choose Shade',
                        preferenceValue: _preferences['lipstick'],
                        onPreferenceTap: () => _selectPreference(
                          context,
                          key: 'lipstick',
                          options: const ['Red', 'Nude', 'Pink'],
                        ),
                      ),
                      KitItemRow(
                        label: 'Foundation',
                        subtitle: 'Skin Tone',
                        selected: _selectedItems['foundation']!,
                        onSelectedChanged: (v) => setState(() =>
                            _selectedItems['foundation'] = v),
                        preferenceLabel: 'Skin Tone',
                        preferenceValue: _preferences['foundation'],
                        onPreferenceTap: () => _selectPreference(
                          context,
                          key: 'foundation',
                          options: const ['Light', 'Medium', 'Dark'],
                        ),
                      ),
                      KitItemRow(
                        label: 'Compact Powder',
                        subtitle: 'Finish',
                        selected: _selectedItems['compact']!,
                        onSelectedChanged: (v) => setState(() =>
                            _selectedItems['compact'] = v),
                        preferenceLabel: 'Finish',
                        preferenceValue: _preferences['compact'],
                        onPreferenceTap: () => _selectPreference(
                          context,
                          key: 'compact',
                          options: const ['Matte', 'Natural'],
                        ),
                      ),
                      KitItemRow(
                        label: 'Blush',
                        subtitle: 'Color',
                        selected: _selectedItems['blush']!,
                        onSelectedChanged: (v) => setState(() =>
                            _selectedItems['blush'] = v),
                        preferenceLabel: 'Color',
                        preferenceValue: _preferences['blush'],
                        onPreferenceTap: () => _selectPreference(
                          context,
                          key: 'blush',
                          options: const ['Peach', 'Rose'],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Budget: \\$_budget',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                      Slider(
                        value: _budget,
                        min: 40,
                        max: 200,
                        divisions: 16,
                        activeColor: ThemeTokens.accent,
                        label: '\\$_budget',
                        onChanged: (v) => setState(() => _budget = v),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: userAsync.when(
                  data: (user) => FilledButton(
                    onPressed: _selectedCount == 0
                        ? null
                        : () => _generateKit(context, user.id),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      backgroundColor: ThemeTokens.accent,
                    ),
                    child: const Text('Generate My Cosmetics'),
                  ),
                  loading: () => const FilledButton(
                    onPressed: null,
                    child: Text('Loading user…'),
                  ),
                  error: (_, __) => const FilledButton(
                    onPressed: null,
                    child: Text('Profile unavailable'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _categories.length; i++)
          Padding(
            padding: EdgeInsets.only(right: i == _categories.length - 1 ? 0 : 8),
            child: ChoiceChip(
              label: Text(_categories[i]),
              selected: _selectedCategoryIndex == i,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategoryIndex = i);
                  ref.read(currentCategoryProvider.notifier).state =
                      _categories[i];
                }
              },
            ),
          ),
      ],
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
      builder: (_) => ListView(
        shrinkWrap: true,
        children: [
          for (final o in options)
            ListTile(
              title: Text(o),
              onTap: () => Navigator.of(context).pop(o),
            ),
        ],
      ),
    );

    if (selected != null) {
      setState(() => _preferences[key] = selected);
    }
  }

  Future<void> _generateKit(BuildContext context, String userId) async {
    final repo = ref.read(kitRepositoryProvider);

    final selections = <Map<String, dynamic>>[];
    _selectedItems.forEach((key, selected) {
      if (!selected) return;
      selections.add({
        'itemId': key,
        'preferences': _preferences[key],
      });
    });

    try {
      final kit = await repo.generateKit(
        userId: userId,
        category: _categories[_selectedCategoryIndex],
        selections: selections,
        budget: _budget,
      );

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => OptimizedKitScreen(kit: kit),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate kit.')),
      );
    }
  }
}
