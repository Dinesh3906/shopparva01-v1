import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../models/kit.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/price_alert.dart';
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

// Home feed: category filter
final selectedHomePageCategoryProvider = StateProvider<String>((ref) => 'All');

// Home feed: smart deals grid
final smartDealsProvider = FutureProvider<List<Product>>((ref) async {
  final category = ref.watch(selectedHomePageCategoryProvider);
  final repo = ref.read(productRepositoryProvider);
  
  // Pass category to repository if it's not 'All'
  return repo.getProducts(
    limit: 20, 
    category: category == 'All' ? null : category,
  );
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

// Deal search query for navigating to Deal Tab with search context
final dealSearchQueryProvider = StateProvider<String?>((ref) => null);

// Kits
final currentCategoryProvider = StateProvider<String>((ref) => 'Cosmetics');

final optimizedKitProvider =
    FutureProvider.autoDispose<Kit?>((ref) async => null);

// Price tracker - managed with StateNotifier for dynamic updates
final trackedProductsNotifierProvider = StateNotifierProvider<TrackedProductsNotifier, AsyncValue<List<Product>>>((ref) {
  return TrackedProductsNotifier(ref.read(productRepositoryProvider));
});

class TrackedProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  TrackedProductsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTrackedProducts();
  }

  final ProductRepository _repository;

  Future<void> loadTrackedProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await _repository.getTrackedProducts();
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> trackProduct(Product product) async {
    try {
      await _repository.trackProduct(productId: product.id, userId: 'user123');
      await loadTrackedProducts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> untrackProduct(String productId) async {
    try {
      await _repository.untrackProduct(productId);
      await loadTrackedProducts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  bool isTracked(String productId) {
    return state.whenOrNull(
      data: (products) => products.any((p) => p.id == productId),
    ) ?? false;
  }
}

// Legacy provider for backwards compatibility
final trackedProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(trackedProductsNotifierProvider).when(
    data: (products) => products,
    loading: () => [],
    error: (_, __) => [],
  );
});

// Price alerts - in-memory storage
final priceAlertsProvider = StateNotifierProvider<PriceAlertsNotifier, List<PriceAlert>>((ref) {
  return PriceAlertsNotifier();
});

class PriceAlertsNotifier extends StateNotifier<List<PriceAlert>> {
  PriceAlertsNotifier() : super([]);

  void addAlert(PriceAlert alert) {
    state = [...state, alert];
  }

  void removeAlert(String alertId) {
    state = state.where((alert) => alert.id != alertId).toList();
  }

  void toggleAlert(String alertId) {
    state = state.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(isActive: !alert.isActive);
      }
      return alert;
    }).toList();
  }

  void updateCurrentPrice(String productId, double newPrice) {
    state = state.map((alert) {
      if (alert.productId == productId) {
        return alert.copyWith(currentPrice: newPrice);
      }
      return alert;
    }).toList();
  }
}

// Time range for price history chart (7, 30, or 90 days)
final selectedTimeRangeProvider = StateProvider<int>((ref) => 30);

// Selected product for tracker details
final selectedTrackedProductProvider = StateProvider<Product?>((ref) => null);

// Accessibility
final highContrastProvider = StateProvider<bool>((ref) => false);

// Navigation
final navigationIndexProvider = StateProvider<int>((ref) => 0);

