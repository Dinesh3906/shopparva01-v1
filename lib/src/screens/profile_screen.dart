import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../models/user.dart';

import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';
import 'addresses_screen.dart';
import 'edit_profile_screen.dart';
import 'orders_screen.dart';
import 'preferences_screen.dart';
import 'wishlist_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      body: profileAsync.when(
        data: (profile) => _buildProfileContent(profile),
        loading: () => const LoadingShimmer(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load profile',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.refresh(userProfileProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserProfile profile) {
    return CustomScrollView(
      slivers: [
        // Header with profile info
        SliverToBoxAdapter(
          child: _buildProfileHeader(profile),
        ),
        // Account & Orders Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Account & Orders'),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            subtitle: 'View and track your orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.local_shipping_outlined,
            title: 'Order Tracking',
            subtitle: 'Track your shipments',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen(showTracking: true)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.history,
            title: 'Order History',
            subtitle: 'View past orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.assignment_return_outlined,
            title: 'Returns & Refunds',
            subtitle: 'Manage returns and refunds',
            onTap: () => _showComingSoon(context),
          ),
        ),
        // Saved & Shopping Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Saved & Shopping'),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.favorite_border,
            title: 'Wishlist',
            subtitle: 'Your saved items',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishlistScreen()),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.bookmark_border,
            title: 'Saved Items',
            subtitle: 'Items you saved for later',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishlistScreen()),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.remove_red_eye_outlined,
            title: 'Recently Viewed',
            subtitle: 'Products you viewed',
            onTap: () => _showRecentlyViewed(context),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.apps_outlined,
            title: 'Saved Kits',
            subtitle: 'Your saved Make My Kit builds',
            onTap: () => _showSavedKits(context),
          ),
        ),
        // Payments & Addresses Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Payments & Addresses'),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            subtitle: 'Manage your delivery addresses',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddressesScreen()),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Manage payment options',
            onTap: () => _showPaymentMethods(context),
          ),
        ),
        // Preferences & Settings Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Preferences & Settings'),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.settings_outlined,
            title: 'Preferences',
            subtitle: 'Category, budget, and more',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PreferencesScreen()),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PreferencesScreen()),
            ),
          ),
        ),
        // Support & Info Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Support & Info'),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get help and support',
            onTap: () => _showHelpCenter(context),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.support_agent_outlined,
            title: 'Contact Support',
            subtitle: 'Reach out to our team',
            onTap: () => _showContactSupport(context),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.quiz_outlined,
            title: 'FAQs',
            subtitle: 'Frequently asked questions',
            onTap: () => _showFAQs(context),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.info_outline,
            title: 'About ShopParva',
            subtitle: 'App version and info',
            onTap: () => _showAbout(context),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we protect your data',
            onTap: () => _showPrivacyPolicy(context),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Terms of service',
            onTap: () => _showTerms(context),
          ),
        ),
        // Auth Actions
        SliverToBoxAdapter(
          child: _buildSectionHeader('Account Actions'),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () => _showLogoutDialog(context),
            textColor: Colors.orange,
          ),
        ),
        SliverToBoxAdapter(
          child: _buildMenuTile(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: () => _showDeleteAccountDialog(context),
            textColor: Colors.red,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeTokens.primary.withOpacity(0.3),
            ThemeTokens.accent.withOpacity(0.2),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: ThemeTokens.surfaceMuted,
                backgroundImage: profile.avatar != null
                    ? NetworkImage(profile.avatar!)
                    : null,
                child: profile.avatar == null
                    ? Text(
                        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ThemeTokens.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: ThemeTokens.backgroundDark, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          if (profile.phone != null) ...[
            const SizedBox(height: 4),
            Text(
              profile.phone!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfileScreen(profile: profile),
              ),
            ),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeTokens.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
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

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ThemeTokens.surfaceMuted.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: textColor ?? ThemeTokens.accent, size: 24),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white54,
            ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white54,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature coming soon!')),
    );
  }

  void _showRecentlyViewed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Recently Viewed')),
          body: const Center(child: Text('Recently viewed products will appear here')),
        ),
      ),
    );
  }

  void _showSavedKits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Saved Kits')),
          body: const Center(child: Text('Your saved kits will appear here')),
        ),
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeTokens.surfaceDark,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Payment Methods',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No payment methods saved.\nAdd a payment method during checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Help Center')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHelpItem('How to place an order?', 'Follow these steps...'),
              _buildHelpItem('How to track my order?', 'Go to Orders section...'),
              _buildHelpItem('How to return an item?', 'Contact support...'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return Card(
      color: ThemeTokens.surfaceMuted,
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(color: Colors.white)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ThemeTokens.surfaceDark,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact Support',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.email, color: ThemeTokens.accent),
              title: const Text('Email', style: TextStyle(color: Colors.white)),
              subtitle: const Text('support@shopparva.com', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: ThemeTokens.accent),
              title: const Text('Phone', style: TextStyle(color: Colors.white)),
              subtitle: const Text('+91 1800-123-4567', style: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showFAQs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('FAQs')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHelpItem('What is ShopParva?', 'ShopParva is a price comparison app...'),
              _buildHelpItem('How does price comparison work?', 'We compare prices across platforms...'),
              _buildHelpItem('Is my data safe?', 'Yes, we follow strict privacy policies...'),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'ShopParva',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.shopping_bag, size: 48),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Privacy Policy')),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Text(
              'Privacy Policy content goes here...',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

  void _showTerms(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Terms & Conditions')),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Text(
              'Terms & Conditions content goes here...',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeTokens.surfaceDark,
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(userRepositoryProvider);
              await repo.logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeTokens.surfaceDark,
        title: const Text('Delete Account', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(userRepositoryProvider);
              await repo.deleteAccount();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

