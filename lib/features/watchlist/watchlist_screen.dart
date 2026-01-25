import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Watchlist')),
      body: watchlist.isEmpty
          ? const Center(child: Text('No items in watchlist'))
          : ListView.builder(
              itemCount: watchlist.length,
              itemBuilder: (context, index) {
                final product = watchlist[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: product.images.first,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  title: Text(product.title),
                  subtitle: Text('\$${product.offers.isNotEmpty ? product.offers.first.price : "?"}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(watchlistProvider.notifier).toggle(product);
                    },
                  ),
                  onTap: () => context.push('/product/${product.id}'),
                );
              },
            ),
    );
  }
}
