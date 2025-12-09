import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/ar_asset.dart';

class ArRepository {
  ArRepository(this._client);

  final ApiClient _client;

  Future<List<ArAsset>> getAssets(String category) async {
    final Response<dynamic> response =
        await _client.dio.get('/ar-assets', queryParameters: {'category': category});
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((e) => ArAsset.fromJson(e as Map<String, dynamic>)).toList();
  }
}
