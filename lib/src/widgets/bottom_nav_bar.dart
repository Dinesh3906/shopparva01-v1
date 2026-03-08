import 'package:flutter/material.dart';
import '../../core/theme_tokens.dart';
import 'glass_container.dart';

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
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: GlassContainer(
          height: 72,
          borderRadius: BorderRadius.circular(36),
          opacity: 0.1,
          blur: 20,
          borderOpacity: 0.1,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                icon: Icons.home_rounded,
                selectedIcon: Icons.home_rounded,
                isSelected: currentIndex == 0,
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                icon: Icons.local_offer_outlined,
                selectedIcon: Icons.local_offer_rounded,
                isSelected: currentIndex == 1,
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                icon: Icons.grid_view_rounded,
                selectedIcon: Icons.grid_view_rounded,
                isSelected: currentIndex == 2,
                onTap: onTap,
              ),
              _NavItem(
                index: 3,
                icon: Icons.view_in_ar_rounded,
                selectedIcon: Icons.view_in_ar_rounded,
                isSelected: currentIndex == 3,
                onTap: onTap,
              ),
              _NavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                isSelected: currentIndex == 4,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? ThemeTokens.primary : Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ThemeTokens.primary.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: -2,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.white : Colors.white60,
            size: 24,
          ),
        ),
      ),
    );
  }
}
