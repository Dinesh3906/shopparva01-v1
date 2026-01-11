
import 'package:flutter/material.dart';
import '../../../core/theme_tokens.dart';
import '../data/smart_preferences_data.dart';

class SmartPreferencesPanel extends StatefulWidget {
  final String category;
  final Function(Map<String, dynamic>) onApply;

  const SmartPreferencesPanel({
    super.key,
    required this.category,
    required this.onApply,
  });

  @override
  State<SmartPreferencesPanel> createState() => _SmartPreferencesPanelState();
}

class _SmartPreferencesPanelState extends State<SmartPreferencesPanel> {
  final Map<String, Set<String>> _selectedFilters = {};
  String? _selectedPrice;
  String? _primaryUsage; // Special "Smart Rule" filter for phones
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    // Initialize empty sets for known keys to be safe
    for (var key in SmartPreferencesData.phoneRam) {
       // Just ensuring keys exist if needed, but putIfAbsent handles it.
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleFilter(String category, String value) {
    setState(() {
      if (_selectedFilters[category]?.contains(value) ?? false) {
        _selectedFilters[category]?.remove(value);
      } else {
        _selectedFilters.putIfAbsent(category, () => {}).add(value);
      }
    });
  }

  void _setPrice(String price) {
    setState(() {
      if (_selectedPrice == price) {
        _selectedPrice = null;
      } else {
        _selectedPrice = price;
      }
    });
  }

  // Smart Rule: Selecting Primary Usage triggers auto-selection
  void _setPrimaryUsage(String usage) {
    setState(() {
      if (_primaryUsage == usage) {
        _primaryUsage = null; // Deselect
      } else {
        _primaryUsage = usage;
        _applySmartRules(usage);
      }
    });
  }

  void _applySmartRules(String usage) {
    final rules = SmartPreferencesData.phoneSmartRules[usage];
    if (rules != null) {
      // Auto-select features based on usage
      for (final rule in rules) {
        _addToCategoryIfExists('RAM', SmartPreferencesData.phoneRam, rule);
        _addToCategoryIfExists('Storage', SmartPreferencesData.phoneStorage, rule);
        _addToCategoryIfExists('Performance', SmartPreferencesData.phonePerformance, rule);
        _addToCategoryIfExists('Camera', SmartPreferencesData.phoneCamera, rule);
        _addToCategoryIfExists('Battery', SmartPreferencesData.phoneBattery, rule);
        _addToCategoryIfExists('Display', SmartPreferencesData.phoneDisplay, rule);
        _addToCategoryIfExists('Network / Extras', SmartPreferencesData.phoneNetwork, rule);
      }
    }
  }

  void _addToCategoryIfExists(String categoryName, List<String> options, [String? target]) {
     if (target != null) {
        // Simple fuzzy match or direct match
        final match = options.firstWhere(
            (opt) => opt.contains(target) || target.contains(opt), 
            orElse: () => ''
        );
        if (match.isNotEmpty) {
           _selectedFilters.putIfAbsent(categoryName, () => {}).add(match);
        }
     }
  }

  void _resetFilters() {
    setState(() {
      _selectedFilters.clear();
      _selectedPrice = null;
      _primaryUsage = null;
    });
  }

  void _handleApply() {
    final filters = <String, dynamic>{
      'category': widget.category,
      'brands': _selectedFilters['Brand']?.toList() ?? [],
      'attributes': [],
    };

    // Flatten all selected attributes
    _selectedFilters.forEach((key, value) {
      if (key != 'Brand') { 
        (filters['attributes'] as List).addAll(value);
      }
    });
    
    if (_primaryUsage != null) {
      (filters['attributes'] as List).add(_primaryUsage!);
    }

    if (_selectedPrice != null) {
       // Simple price logic
       if (_selectedPrice!.contains('Under')) {
         filters['max_price'] = 500 * 85; // Mock conversion
       } else if (_selectedPrice!.contains('Above')) {
         filters['min_price'] = 1000 * 85;
       } else {
         filters['min_price'] = 500 * 85;
         filters['max_price'] = 1000 * 85;
       }
    }

    widget.onApply(filters);
  }

  @override
  Widget build(BuildContext context) {
    final isLaptop = widget.category == 'Laptop';
    final screenHeight = MediaQuery.of(context).size.height;
    final maxPanelHeight = screenHeight * 0.70; // 70% Max Height

    return Container(
      width: double.infinity,
      // Removed fixed maxHeight to allow full layout in Sliver
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceMuted,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
        border: Border(
           bottom: BorderSide(color: ThemeTokens.primary.withOpacity(0.5), width: 1),
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Vital: Shrinks to fit content, up to maxHeight
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header (Fixed)
          InkWell(
            onTap: _toggleExpanded,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: ThemeTokens.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isLaptop ? 'Laptop Preferences' : 'Phone Specifications',
                      style: TextStyle(
                        fontFamily: ThemeTokens.titleLarge.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    GestureDetector(
                      onTap: () {
                        _resetFilters();
                        // Optional: Keep expanded or collapse on reset
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ThemeTokens.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(height: 1, color: Colors.white10),

            // 2. Content Area (Non-scrollable, let parent handle it)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: isLaptop ? _buildLaptopSections() : _buildPhoneSections(),
              ),
            ),

            // 3. Footer (Sticky)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeTokens.surfaceMuted,
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
              ),
              child: SizedBox(
                 width: double.infinity,
                 child: ElevatedButton(
                  onPressed: _handleApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeTokens.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Find Best Deals',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildLaptopSections() {
    return [
       _buildSection('Brand', SmartPreferencesData.laptopBrands),
       _buildSection('Price Range', SmartPreferencesData.laptopPriceRanges, isSingleSelect: true),
       _buildSection('Performance', SmartPreferencesData.laptopPerformance),
       _buildSection('Usage Type', SmartPreferencesData.laptopUsage),
    ];
  }

  List<Widget> _buildPhoneSections() {
    return [
      _buildSection(
        'Primary Usage', 
        SmartPreferencesData.phonePrimaryUsage, 
        isSingleSelect: true, 
        customSelectedValue: _primaryUsage,
        onCustomSelect: _setPrimaryUsage,
        isHighlight: true
      ),
      _buildSection('RAM', SmartPreferencesData.phoneRam),
      _buildSection('Storage', SmartPreferencesData.phoneStorage),
      _buildSection('Performance', SmartPreferencesData.phonePerformance),
      _buildSection('Camera', SmartPreferencesData.phoneCamera),
      _buildSection('Battery', SmartPreferencesData.phoneBattery),
      _buildSection('Display', SmartPreferencesData.phoneDisplay),
      _buildSection('Network / Extras', SmartPreferencesData.phoneNetwork),
    ];
  }

  Widget _buildSection(
    String title, 
    List<String> options, {
    bool isSingleSelect = false,
    String? customSelectedValue,
    Function(String)? onCustomSelect,
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 2.0),
            child: Row(
               children: [
                 Text(
                  title,
                  style: TextStyle(
                    color: isHighlight ? ThemeTokens.primary : Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                 ),
                 if (isHighlight) ...[
                   const SizedBox(width: 8),
                   Container(width: 4, height: 4, decoration: BoxDecoration(color: ThemeTokens.primary, shape: BoxShape.circle))
                 ]
               ],
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((opt) {
              bool isSelected;
              if (isSingleSelect) {
                if (customSelectedValue != null) {
                  isSelected = customSelectedValue == opt;
                } else {
                  isSelected = _selectedPrice == opt;
                }
              } else {
                isSelected = _selectedFilters[title]?.contains(opt) ?? false;
              }

              VoidCallback onTap;
              if (isSingleSelect) {
                 if (onCustomSelect != null) {
                   onTap = () => onCustomSelect(opt);
                 } else {
                   onTap = () => _setPrice(opt);
                 }
              } else {
                onTap = () => _toggleFilter(title, opt);
              }

              return _FilterChipWidget(
                label: opt,
                isSelected: isSelected,
                onTap: onTap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipWidget({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine strict width constraints for "Grid-like" look but flexible
    // Using constraint width can simulate a 2-column grid if needed, or wrap nicely
    final screenWidth = MediaQuery.of(context).size.width;
    // (Screen - Padding 32 - Spacing 10) / 2
    final itemWidth = (screenWidth - 32 - 12) / 2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: itemWidth,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected 
                ? ThemeTokens.primary.withOpacity(0.15) 
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ThemeTokens.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check_circle, size: 16, color: ThemeTokens.primary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
