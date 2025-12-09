import 'package:flutter/material.dart';

import '../../core/theme_tokens.dart';

class FiltersDrawer extends StatefulWidget {
  const FiltersDrawer({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  final Map<String, dynamic> initialFilters;
  final ValueChanged<Map<String, dynamic>> onApply;

  @override
  State<FiltersDrawer> createState() => _FiltersDrawerState();
}

class _FiltersDrawerState extends State<FiltersDrawer> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.initialFilters);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 320,
        color: ThemeTokens.surfaceDark,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white.withOpacity(0.9)),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Brand'),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final brand in ['Any', 'Apple', 'Samsung', 'Sony'])
                          FilterChip(
                            label: Text(brand),
                            selected: (_filters['brand'] ?? 'Any') == brand,
                            onSelected: (_) {
                              setState(() => _filters['brand'] = brand);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Price Range'),
                    Column(
                      children: [
                        _buildRadio('Any', 'any'),
                        _buildRadio('< 500', '<500'),
                        _buildRadio('500 - 1000', '500-1000'),
                        _buildRadio('> 1000', '>1000'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Performance'),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final perf in ['Gaming', 'Work', 'Everyday'])
                          FilterChip(
                            label: Text(perf),
                            selected: (_filters['performance'] as List?)
                                    ?.contains(perf) ??
                                false,
                            onSelected: (selected) {
                              final list =
                                  List<String>.from(_filters['performance'] ?? []);
                              if (selected) {
                                list.add(perf);
                              } else {
                                list.remove(perf);
                              }
                              setState(() => _filters['performance'] = list);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Usage Type'),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final usage in ['Home', 'Office', 'Travel'])
                          ChoiceChip(
                            label: Text(usage),
                            selected: (_filters['usage'] ?? '') == usage,
                            onSelected: (_) {
                              setState(() => _filters['usage'] = usage);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onApply(_filters);
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: ThemeTokens.accent,
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, size: 16, color: Colors.white54),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String label, String value) {
    return RadioListTile<String>(
      dense: true,
      contentPadding: EdgeInsets.zero,
      value: value,
      groupValue: _filters['price_range'] as String?,
      activeColor: ThemeTokens.accent,
      onChanged: (val) => setState(() => _filters['price_range'] = val),
      title: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white70),
      ),
    );
  }
}
