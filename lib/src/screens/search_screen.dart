import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../state/app_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    // If there's an initial query, navigate to Deal Tab immediately
    if (widget.initialQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToDealTab(widget.initialQuery);
      });
    }
  }

  void _navigateToDealTab(String query) {
    // Set the search query for Deal Tab
    ref.read(dealSearchQueryProvider.notifier).state = query;
    // Navigate back to home which will switch to Deal Tab (index 1)
    // The listener in main.dart will handle the tab switch
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _runSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    _navigateToDealTab(query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search products…',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          onSubmitted: (_) => _runSearch(),
        ),
        actions: const [],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                size: 64,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Search for products to compare prices',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter a product name and press search to see price comparisons across platforms',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

