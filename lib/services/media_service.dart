import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../models/media_asset.dart';
import 'secure_storage_service.dart';
import '../config/constants.dart';

class MediaService {
  final SecureStorageService _storage;

  MediaService(this._storage);

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(AppConstants.accessTokenKey);
    return {
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<MediaAsset>> uploadFiles({
    required List<File> files,
    required String accountId,
    required String brandId,
    bool generateThumbnail = true,
  }) async {
    final uri = Uri.parse(Env.mediaUploadUrl);
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll(await _authHeaders());
    request.fields['accountId'] = accountId;
    request.fields['brandId'] = brandId;
    request.fields['generateThumbnail'] = generateThumbnail.toString();

    for (final file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('Upload failed: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    final successful = data['successful'] as List;
    return successful.map((e) => MediaAsset.fromJson(e)).toList();
  }

  Future<MediaAsset> importFromUrl({
    required String url,
    required String accountId,
    required String brandId,
  }) async {
    final uri = Uri.parse('${Env.mediaUrl}/from-url');
    final response = await http.post(
      uri,
      headers: {
        ...await _authHeaders(),
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'url': url,
        'accountId': accountId,
        'brandId': brandId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Import failed: ${response.statusCode}');
    }

    return MediaAsset.fromJson(json.decode(response.body));
  }

  Future<List<MediaAsset>> getAssets({
    required String accountId,
    required String brandId,
    String? type,
    int limit = 20,
    int offset = 0,
    String? search,
  }) async {
    final params = {
      'accountId': accountId,
      'brandId': brandId,
      'limit': limit.toString(),
      'offset': offset.toString(),
      if (type != null) 'type': type,
      if (search != null) 'search': search,
    };
    final uri = Uri.parse(Env.mediaUrl).replace(queryParameters: params);
    final response = await http.get(uri, headers: await _authHeaders());

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch assets: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    final assets = data['assets'] as List? ?? [];
    return assets.map((e) => MediaAsset.fromJson(e)).toList();
  }

  Future<void> deleteAsset({
    required String id,
    required String accountId,
    required String brandId,
  }) async {
    final uri = Uri.parse('${Env.mediaUrl}/$id');
    final response = await http.delete(
      uri,
      headers: {
        ...await _authHeaders(),
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'accountId': accountId,
        'brandId': brandId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Delete failed: ${response.statusCode}');
    }
  }
}
