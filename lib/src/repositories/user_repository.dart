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

    final Response<dynamic> response = await _client.dio.get('/user/profile');
    final profile = UserProfile.fromJson(response.data as Map<String, dynamic>);
    _cachedProfile = profile;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', profile.name);

    return profile;
  }

  Future<String?> getCachedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }
}
