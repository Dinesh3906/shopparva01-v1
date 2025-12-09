import 'package:flutter/material.dart';

import '../../core/theme_tokens.dart';

class KitItemRow extends StatelessWidget {
  const KitItemRow({
    super.key,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onSelectedChanged,
    required this.preferenceLabel,
    required this.preferenceValue,
    required this.onPreferenceTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final ValueChanged<bool> onSelectedChanged;
  final String preferenceLabel;
  final String? preferenceValue;
  final VoidCallback onPreferenceTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected
              ? ThemeTokens.primary.withOpacity(0.9)
              : Colors.white24,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: ThemeTokens.primary.withOpacity(0.5),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: selected,
                onChanged: (val) => onSelectedChanged(val ?? false),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                activeColor: ThemeTokens.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white.withOpacity(0.9)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selected) ...[
            const SizedBox(height: 8),
            PreferenceSelector(
              label: preferenceLabel,
              value: preferenceValue,
              onTap: onPreferenceTap,
            ),
          ],
        ],
      ),
    );
  }
}

class PreferenceSelector extends StatelessWidget {
  const PreferenceSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeTokens.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70),
            ),
            const Spacer(),
            Text(
              value ?? 'Select',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white.withOpacity(0.9)),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
