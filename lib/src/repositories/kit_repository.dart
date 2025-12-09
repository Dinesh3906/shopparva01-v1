import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client.dart';
import '../models/kit.dart';

class KitRepository {
  KitRepository(this._client);

  final ApiClient _client;

  Future<List<Kit>> getKits() async {
    final Response<dynamic> response = await _client.dio.get('/kits');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((e) => Kit.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Kit> generateKit({
    required String userId,
    required String category,
    required List<Map<String, dynamic>> selections,
    required double budget,
  }) async {
    final Response<dynamic> response = await _client.dio.post(
      '/kits/generate',
      data: {
        'userId': userId,
        'category': category,
        'selections': selections,
        'budget': budget,
      },
    );

    final kit = Kit.fromJson(response.data as Map<String, dynamic>);

    // Persist last generated kit for quick offline preview.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_generated_kit', kit.toJson().toString());

    return kit;
  }
}
