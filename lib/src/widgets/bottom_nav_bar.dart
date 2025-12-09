import 'package:flutter/material.dart';

import '../../core/theme_tokens.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: ThemeTokens.surfaceMuted,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              index: 0,
              label: 'Home',
              icon: Icons.home_rounded,
              isSelected: currentIndex == 0,
              onTap: onTap,
              colorScheme: colorScheme,
            ),
            _NavItem(
              index: 1,
              label: 'Deals',
              icon: Icons.local_offer_rounded,
              isSelected: currentIndex == 1,
              onTap: onTap,
              colorScheme: colorScheme,
            ),
            _NavItem(
              index: 2,
              label: 'Kits',
              icon: Icons.apps_rounded,
              isSelected: currentIndex == 2,
              onTap: onTap,
              colorScheme: colorScheme,
            ),
            _NavItem(
              index: 3,
              label: 'AR Try',
              icon: Icons.camera_front_rounded,
              isSelected: currentIndex == 3,
              onTap: onTap,
              colorScheme: colorScheme,
            ),
            _NavItem(
              index: 4,
              label: 'Profile',
              icon: Icons.person_rounded,
              isSelected: currentIndex == 4,
              onTap: onTap,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final baseColor = isSelected ? ThemeTokens.primary : Colors.white70;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? ThemeTokens.primary.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ThemeTokens.primary.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: baseColor, size: 22),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: baseColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
