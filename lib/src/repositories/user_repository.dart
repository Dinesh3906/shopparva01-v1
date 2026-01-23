import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client.dart';
import '../models/user.dart';

class UserRepository {
  UserRepository(this._client);

  final ApiClient _client;

  UserProfile? _cachedProfile;

  Future<UserProfile> getProfile() async {
    if (_cachedProfile != null) return _cachedProfile!;

    try {
      final Response<dynamic> response = await _client.dio.get('/user/profile');
      final profile = UserProfile.fromJson(response.data as Map<String, dynamic>);
      _cachedProfile = profile;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', profile.name);
      
      return profile;
    } catch (e) {
      // Mock profile for offline mode
      const mockProfile = UserProfile(
        id: 'user_offline',
        name: 'Guest User',
        email: 'guest@shopparva.com',
        phone: '+91 98765 43210',
        avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fit=crop&w=200&h=200',
      );
      _cachedProfile = mockProfile;
      return mockProfile;
    }
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    final Response<dynamic> response = await _client.dio.put(
      '/user/profile',
      data: profile.toJson(),
    );
    final updated = UserProfile.fromJson(response.data as Map<String, dynamic>);
    _cachedProfile = updated;
    return updated;
  }

  Future<String?> getCachedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<List<Order>> getOrders() async {
    final Response<dynamic> response = await _client.dio.get('/user/orders');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<WishlistItem>> getWishlist() async {
    final Response<dynamic> response = await _client.dio.get('/user/wishlist');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((e) => WishlistItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<WishlistItem> addToWishlist(String productId) async {
    final Response<dynamic> response = await _client.dio.post(
      '/user/wishlist',
      data: {'productId': productId},
    );
    return WishlistItem.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> removeFromWishlist(String wishlistId) async {
    await _client.dio.delete('/user/wishlist/$wishlistId');
  }

  Future<List<Address>> getAddresses() async {
    final Response<dynamic> response = await _client.dio.get('/user/addresses');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Address> addAddress(Address address) async {
    final Response<dynamic> response = await _client.dio.post(
      '/user/addresses',
      data: address.toJson(),
    );
    return Address.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Address> updateAddress(Address address) async {
    final Response<dynamic> response = await _client.dio.put(
      '/user/addresses/${address.id}',
      data: address.toJson(),
    );
    return Address.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteAddress(String addressId) async {
    await _client.dio.delete('/user/addresses/$addressId');
  }

  Future<UserPreferences> getPreferences() async {
    final Response<dynamic> response = await _client.dio.get('/user/preferences');
    return UserPreferences.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserPreferences> updatePreferences(UserPreferences preferences) async {
    final Response<dynamic> response = await _client.dio.put(
      '/user/preferences',
      data: preferences.toJson(),
    );
    return UserPreferences.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _client.dio.post('/user/logout');
    _cachedProfile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> deleteAccount() async {
    await _client.dio.delete('/user/delete');
    _cachedProfile = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<List<Map<String, dynamic>>> getRecentlyViewed() async {
    final Response<dynamic> response = await _client.dio.get('/user/recently-viewed');
    return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getSavedKits() async {
    final Response<dynamic> response = await _client.dio.get('/user/saved-kits');
    return (response.data as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
