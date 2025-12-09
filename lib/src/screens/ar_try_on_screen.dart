import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../models/ar_asset.dart';
import '../state/app_providers.dart';

class ArTryOnScreen extends ConsumerStatefulWidget {
  const ArTryOnScreen({super.key});

  @override
  ConsumerState<ArTryOnScreen> createState() => _ArTryOnScreenState();
}

class _ArTryOnScreenState extends ConsumerState<ArTryOnScreen> {
  final List<String> _categories = const ['Glasses', 'Lipstick', 'T-Shirts', 'Jewellery'];
  int _selectedCategoryIndex = 0;

  late Future<List<ArAsset>> _futureAssets;
  int _selectedAssetIndex = 0;

  @override
  void initState() {
    super.initState();
    _futureAssets = _loadAssets();
  }

  Future<List<ArAsset>> _loadAssets() {
    final repo = ref.read(arRepositoryProvider);
    final key = _categories[_selectedCategoryIndex].toLowerCase();
    return repo.getAssets(key);
  }

  void _changeCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _futureAssets = _loadAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview stub (replace with real CameraPreview if needed)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Camera Preview',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ),

            // Top pill app bar
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18, color: Colors.white70),
                    SizedBox(width: 6),
                    Text(
                      'AR Try-On',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.flash_on_rounded,
                        size: 18, color: Colors.white70),
                  ],
                ),
              ),
            ),

            // Face alignment bounding box
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 220,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: ThemeTokens.accent.withOpacity(0.8),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Side controls
            Positioned(
              right: 16,
              top: 80,
              bottom: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _roundButton(icon: Icons.cameraswitch_rounded, label: 'Flip'),
                  _roundButton(icon: Icons.camera_rounded, label: 'Capture'),
                ],
              ),
            ),
            // Active AR product overlay card (centered like design)
            Positioned(
              left: 16,
              right: 16,
              bottom: 190,
              child: FutureBuilder<List<ArAsset>>(
                future: _futureAssets,
                builder: (context, snapshot) {
                  final assets = snapshot.data ?? const [];
                  final hasAsset = assets.isNotEmpty;
                  final asset =
                      hasAsset ? assets[_selectedAssetIndex.clamp(0, assets.length - 1)] : null;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeTokens.surfaceDark.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeTokens.accent.withOpacity(0.5),
                          blurRadius: 24,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    asset?.name ?? 'Aviator Sunglasses',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Golden Frame',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                _colorDot(Colors.yellowAccent),
                                const SizedBox(width: 6),
                                _colorDot(Colors.cyanAccent),
                                const SizedBox(width: 6),
                                _colorDot(Colors.pinkAccent),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              // Hook into Smart Deal Finder / Product detail
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              backgroundColor: ThemeTokens.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text('View Best Deal'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Category tabs and asset carousel
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 32,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final selected = index == _selectedCategoryIndex;
                          return ChoiceChip(
                            label: Text(_categories[index]),
                            selected: selected,
                            onSelected: (_) => _changeCategory(index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: FutureBuilder<List<ArAsset>>(
                        future: _futureAssets,
                        builder: (context, snapshot) {
                          final assets = snapshot.data ?? const [];
                          if (assets.isEmpty) {
                            return const Center(
                              child: Text(
                                'No AR assets found',
                                style: TextStyle(color: Colors.white54),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: assets.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final asset = assets[index];
                              final selected = index == _selectedAssetIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedAssetIndex = index);
                                },
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? ThemeTokens.accent
                                          : Colors.white24,
                                    ),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: ThemeTokens.accent
                                                  .withOpacity(0.6),
                                              blurRadius: 18,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: ThemeTokens.surfaceDark,
                                        ),
                                        child: Center(
                                          child: Text(
                                            asset.name.characters.first,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        asset.name,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Remove filter
                              },
                              child: const Text('Remove Filter'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                // Apply and continue
                              },
                              child: const Text('Apply & Continue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }
}
