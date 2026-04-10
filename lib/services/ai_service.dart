import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/env.dart';
import '../models/ai_generation.dart';
import 'secure_storage_service.dart';
import '../config/constants.dart';

class AiService {
  final SecureStorageService _storage;

  AiService(this._storage);

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(AppConstants.accessTokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<AiGenerationResult> generate({
    required String accountId,
    required String brandId,
    required String prompt,
    String? tone,
    String? platform,
    int? maxLength,
    int? responseCount,
    String? provider,
  }) async {
    final uri = Uri.parse(Env.aiGenerateUrl);
    final response = await http.post(
      uri,
      headers: await _authHeaders(),
      body: json.encode({
        'accountId': accountId,
        'brandId': brandId,
        'prompt': prompt,
        if (tone != null) 'tone': tone,
        if (platform != null) 'platform': platform,
        if (maxLength != null) 'maxLength': maxLength,
        if (responseCount != null) 'responseCount': responseCount,
        if (provider != null) 'provider': provider,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI generation failed: ${response.statusCode}');
    }

    return AiGenerationResult.fromJson(json.decode(response.body));
  }

  Future<List<AiTone>> getTones() async {
    final uri = Uri.parse(Env.aiTonesUrl);
    final response = await http.get(uri, headers: await _authHeaders());

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch tones: ${response.statusCode}');
    }

    final data = json.decode(response.body) as List;
    return data.map((e) => AiTone.fromJson(e)).toList();
  }

  Future<List<AiHistoryItem>> getHistory({
    required String accountId,
    required String brandId,
    int? limit,
    int? offset,
  }) async {
    final params = {
      'accountId': accountId,
      'brandId': brandId,
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
    };
    final uri = Uri.parse(Env.aiHistoryUrl).replace(queryParameters: params);
    final response = await http.get(uri, headers: await _authHeaders());

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch history: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    final history = data['history'] as List? ?? [];
    return history.map((e) => AiHistoryItem.fromJson(e)).toList();
  }

  Future<List<String>> getVariations({
    required String text,
    String? platform,
    int? count,
  }) async {
    final uri = Uri.parse(Env.aiSuggestUrl);
    final response = await http.post(
      uri,
      headers: await _authHeaders(),
      body: json.encode({
        'text': text,
        if (platform != null) 'platform': platform,
        if (count != null) 'count': count,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get variations: ${response.statusCode}');
    }

    final data = json.decode(response.body);
    return List<String>.from(data['suggestions'] ?? []);
  }
}
