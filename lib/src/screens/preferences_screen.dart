import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../models/user.dart';

import '../state/app_providers.dart';

final preferencesProvider = FutureProvider.autoDispose<UserPreferences>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getPreferences();
});

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  bool _isLoading = false;

  Future<void> _updatePreferences(UserPreferences preferences) async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.updatePreferences(preferences);
      ref.invalidate(preferencesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferencesAsync = ref.watch(preferencesProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: preferencesAsync.when(
        data: (preferences) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Notifications'),
            SwitchListTile(
              title: const Text('Push Notifications', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Receive push notifications', style: TextStyle(color: Colors.white54)),
              value: preferences.notifications,
              onChanged: _isLoading
                  ? null
                  : (value) => _updatePreferences(preferences.copyWith(notifications: value)),
              activeColor: ThemeTokens.accent,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Appearance'),
            RadioListTile<String>(
              title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
              value: 'dark',
              groupValue: preferences.theme,
              onChanged: _isLoading
                  ? null
                  : (value) => value != null
                      ? _updatePreferences(preferences.copyWith(theme: value))
                      : null,
              activeColor: ThemeTokens.accent,
            ),
            RadioListTile<String>(
              title: const Text('Light Mode', style: TextStyle(color: Colors.white)),
              value: 'light',
              groupValue: preferences.theme,
              onChanged: _isLoading
                  ? null
                  : (value) => value != null
                      ? _updatePreferences(preferences.copyWith(theme: value))
                      : null,
              activeColor: ThemeTokens.accent,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Shopping Preferences'),
            ListTile(
              title: const Text('Budget Preference', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                '₹${preferences.budget.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              onTap: () => _showBudgetDialog(context, preferences),
            ),
            ListTile(
              title: const Text('Category Preferences', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                preferences.categories.isEmpty
                    ? 'No preferences set'
                    : preferences.categories.join(', '),
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              onTap: () => _showCategoryDialog(context, preferences),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Language'),
            ListTile(
              title: const Text('Language', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                preferences.language.toUpperCase(),
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              onTap: () => _showLanguageDialog(context, preferences),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load preferences',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(preferencesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, UserPreferences preferences) {
    final controller = TextEditingController(text: preferences.budget.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeTokens.surfaceDark,
        title: const Text('Set Budget', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Budget (₹)',
            labelStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final budget = int.tryParse(controller.text) ?? 0;
              _updatePreferences(preferences.copyWith(budget: budget));
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: ThemeTokens.accent)),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, UserPreferences preferences) {
    final categories = ['Electronics', 'Fashion', 'Sports', 'Beauty', 'Home', 'Essentials'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeTokens.surfaceDark,
        title: const Text('Category Preferences', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setState) {
            final selected = List<String>.from(preferences.categories);
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selected.contains(category);
                  return CheckboxListTile(
                    title: Text(category, style: const TextStyle(color: Colors.white)),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selected.add(category);
                        } else {
                          selected.remove(category);
                        }
                      });
                    },
                    activeColor: ThemeTokens.accent,
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Get selected from dialog state
              Navigator.pop(context);
              // Note: This is simplified - in production, you'd get the selected list from the dialog
            },
            child: const Text('Save', style: TextStyle(color: ThemeTokens.accent)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, UserPreferences preferences) {
    final languages = ['en', 'hi', 'mr', 'ta'];
    final languageNames = {'en': 'English', 'hi': 'Hindi', 'mr': 'Marathi', 'ta': 'Tamil'};
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeTokens.surfaceDark,
        title: const Text('Select Language', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(languageNames[lang] ?? lang, style: const TextStyle(color: Colors.white)),
              value: lang,
              groupValue: preferences.language,
              onChanged: (value) {
                if (value != null) {
                  _updatePreferences(preferences.copyWith(language: value));
                  Navigator.pop(context);
                }
              },
              activeColor: ThemeTokens.accent,
            );
          }).toList(),
        ),
      ),
    );
  }
}

