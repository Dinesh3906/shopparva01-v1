import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider, FutureProvider;
import '../services/api_service.dart';
import '../models/product.dart';
import '../models/user.dart';

part 'providers.g.dart';

// Service Provider
@riverpod
ApiService apiService(ref) => ApiService();

// User State
@riverpod
class UserState extends _$UserState {
  @override
  User? build() => null;

  void login(String email, String password) {
    // Mock login
    state = User(id: 'u1', email: email, name: 'Test User');
  }

  void logout() {
    state = null;
  }
}

// Watchlist Provider
@riverpod
class Watchlist extends _$Watchlist {
  @override
  List<Product> build() => [];

  void toggle(Product product) {
    if (state.any((p) => p.id == product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }
  
  bool isWatched(String id) => state.any((p) => p.id == id);
}

// Search Provider
@riverpod
class SearchResults extends _$SearchResults {
  @override
  FutureOr<List<Product>> build(String query) async {
    if (query.isEmpty) return [];
    final api = ref.read(apiServiceProvider);
    return api.searchProducts(query);
  }
}

/// Global accessibility setting: whether to use the high-contrast theme.
final highContrastProvider = StateProvider<bool>((ref) => false);

/// Home feed used on the dashboard: fetch all products so the grid is always populated.
final homeFeedProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.read(apiServiceProvider);
  // Empty query returns the full catalog from the mock backend.
  return api.searchProducts('');
});
