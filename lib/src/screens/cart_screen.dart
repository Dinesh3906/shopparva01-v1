import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme_tokens.dart';
import '../state/app_providers.dart';
import '../widgets/empty_and_loading.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = cartItems.fold<double>(
        0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      backgroundColor: ThemeTokens.backgroundDark,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.transparent,
      ),
      body: cartItems.isEmpty
          ? const EmptyStateCard(
              title: 'Your Cart is Empty',
              message: 'Looks like you haven\'t added any items yet.',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Dismissible(
                        key: ValueKey(item.product.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref
                              .read(cartProvider.notifier)
                              .removeFromCart(item.product.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeTokens.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: ThemeTokens.surfaceMuted,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(item.product.image.isNotEmpty
                                      ? item.product.image
                                      : 'https://via.placeholder.com/150'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              item.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Qty: ${item.quantity}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              '${item.product.currency.replaceAll('\$', '₹')}${item.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: ThemeTokens.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: ThemeTokens.surfaceDark,
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).clearCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order placed successfully! 🚀'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
