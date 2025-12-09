import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../models/kit.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../repositories/ar_repository.dart';
import '../repositories/kit_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/user_repository.dart';

// Core singletons
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return ProductRepository(client);
});

final kitRepositoryProvider = Provider<KitRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return KitRepository(client);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return UserRepository(client);
});

final arRepositoryProvider = Provider<ArRepository>((ref) {
  final client = ref.read(apiClientProvider);
  return ArRepository(client);
});

// User profile
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getProfile();
});

// Home feed: smart deals grid
final smartDealsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getProducts(limit: 20);
});

// Search results with filters
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return const [];
  final repo = ref.read(productRepositoryProvider);
  return repo.getProducts(query: query, limit: 40);
});

// Kits
final currentCategoryProvider = StateProvider<String>((ref) => 'Cosmetics');

final optimizedKitProvider =
    FutureProvider.autoDispose<Kit?>((ref) async => null);

// Price tracker
final trackedProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getTrackedProducts();
});

// Accessibility
final highContrastProvider = StateProvider<bool>((ref) => false);
