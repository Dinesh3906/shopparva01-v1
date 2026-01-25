import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/providers.dart';

import '../home/widgets/product_card.dart';
import 'widgets/smart_preferences_panel.dart';


class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  
  // Smart Preferences State
  String? _detectedCategory;
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final text = _controller.text;
    final lowerText = text.toLowerCase();
    
    String? newCategory;
    if (lowerText.contains('laptop')) {
      newCategory = 'Laptop';
    } else if (lowerText.contains('phone') || lowerText.contains('smartphone')) {
      newCategory = 'Phone';
    }

    // Only update state if category changes to avoid rebuilds
    if (newCategory != _detectedCategory) {
      setState(() {
        _detectedCategory = newCategory;
        // If query cleared or category lost, reset filters
        if (newCategory == null) {
          _currentFilters = {};
        }
      });
    }
    
    // Also update query for standard search if needed, but we rely on onSubmitted for that usually
    // However, detection needs live text.
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(filteredSearchProvider((query: _query, filters: _currentFilters)));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products (try "Laptop" or "Phone")...',
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: Column(
        children: [
          // Smart Preferences Panel
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: _detectedCategory != null
                ? Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 600), // Safety cap
                    child: SingleChildScrollView(
                      child: SmartPreferencesPanel(
                        category: _detectedCategory!,
                        onApply: _applyFilters,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          
          // Results Area
          Expanded(
            child: _query.isEmpty && _currentFilters.isEmpty
                ? const Center(child: Text('Type "Laptop" or "Phone" to test Smart Panel'))
                : searchAsync.when(
                    data: (results) {
                      if (results.isEmpty) return const Center(child: Text('No results found'));
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final product = results[index];
                          return ProductCard(
                            product: product,
                            onTap: () => context.push('/product/${product.id}'),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
          ),
        ],
      ),
    );
  }
}
