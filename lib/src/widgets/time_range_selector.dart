import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../state/app_providers.dart';

class TimeRangeSelector extends ConsumerWidget {
  const TimeRangeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(selectedTimeRangeProvider);

    return Container(
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TimeRangeButton(
            label: '7D',
            days: 7,
            isSelected: selectedRange == 7,
            onTap: () => ref.read(selectedTimeRangeProvider.notifier).state = 7,
          ),
          const SizedBox(width: 4),
          _TimeRangeButton(
            label: '30D',
            days: 30,
            isSelected: selectedRange == 30,
            onTap: () => ref.read(selectedTimeRangeProvider.notifier).state = 30,
          ),
          const SizedBox(width: 4),
          _TimeRangeButton(
            label: '90D',
            days: 90,
            isSelected: selectedRange == 90,
            onTap: () => ref.read(selectedTimeRangeProvider.notifier).state = 90,
          ),
        ],
      ),
    );
  }
}

class _TimeRangeButton extends StatelessWidget {
  const _TimeRangeButton({
    required this.label,
    required this.days,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int days;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ThemeTokens.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
