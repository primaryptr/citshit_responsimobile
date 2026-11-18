// ============================================================
//  api_service.dart
//  Semua logika komunikasi dengan REST API terpusat di sini.
//  Saat Responsi: Sesuaikan endpoint, wrapper key, dan header auth.
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/item_model.dart';

class ApiService {
  ApiService._(); // private constructor

  // ─── TIMEOUT CONFIGURATION ────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Perpendek/panjangkan durasi timeout sesuai kebutuhan]
  static const Duration _timeout = Duration(seconds: 15);

  // ─── HEADER BUILDER ───────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Sesuaikan header dengan autentikasi API yang digunakan]
  static Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // [GANTI SAAT RESPONSI: Jika API tidak butuh key, hapus blok if ini]
    if (AppConfig.apiKey.isNotEmpty) {
      // Pilih salah satu format header sesuai API:

      // Format 1: Custom key header (NewsAPI, dll)
      // headers[AppConfig.apiKeyHeader] = AppConfig.apiKey;

      // Format 2: Bearer Token (JWT / OAuth2)
      // headers['Authorization'] = 'Bearer ${AppConfig.apiKey}';

      // Format 3: Google API Key (Gemini, Maps)
      // headers['x-goog-api-key'] = AppConfig.apiKey;

      // Default: custom header dari AppConfig
      headers[AppConfig.apiKeyHeader] = AppConfig.apiKey;
    }

    return headers;
  }

  // ─── FETCH LIST ───────────────────────────────────────────────────────────
  /// Mengambil daftar item dari API.
  /// Return: List<ItemModel>
  ///
  /// [GANTI SAAT RESPONSI: Tambahkan parameter opsional jika API butuh filter/search]
  /// Contoh: fetchList(category: 'sports', search: 'flutter', page: 1)
  /// Aktifkan dengan uncomment parameter di bawah ini:
  static Future<List<ItemModel>> fetchList(
    // [GANTI SAAT RESPONSI: Uncomment parameter jika dibutuhkan]
    // {String? category, String? search, int page = 1, int limit = 20}
  ) async {
    try {
      // [GANTI SAAT RESPONSI: Susun URL endpoint list]
      // Contoh 1 (sederhana): '${AppConfig.baseUrl}/${AppConfig.listEndpoint}/'
      // Contoh 2 (dengan param): '${AppConfig.baseUrl}/${AppConfig.listEndpoint}/?category=$category'
      // Contoh 3 (query API key): '${AppConfig.baseUrl}/${AppConfig.listEndpoint}?apiKey=${AppConfig.apiKey}'
      final uri = Uri.parse('${AppConfig.baseUrl}/${AppConfig.listEndpoint}/');

      final response = await http
          .get(uri, headers: _buildHeaders())
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // [GANTI SAAT RESPONSI: Sesuaikan cara parsing wrapper JSON]
        //
        // Jika API mengembalikan object dengan wrapper:
        //   { "results": [...] }       -> (data['results'] as List)
        //   { "data": [...] }          -> (data['data'] as List)
        //   { "articles": [...] }      -> (data['articles'] as List)
        //   { "products": [...] }      -> (data['products'] as List)
        //   { "launches": [...] }      -> (data['launches'] as List)
        //   { "response": { "docs": [...] } } -> (data['response']['docs'] as List)
        //
        // Jika API langsung mengembalikan array:
        //   [ {...}, {...} ]           -> (data as List)

        final List<dynamic> items = data['results'] ?? data; // [GANTI SAAT RESPONSI]

        return items
            .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException(
          'Gagal memuat data: HTTP ${response.statusCode}',
        );
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet');
    } catch (e) {
      rethrow;
    }
  }

  // ─── FETCH DETAIL BY ID ───────────────────────────────────────────────────
  /// Mengambil detail satu item berdasarkan ID.
  /// Return: ItemModel
  static Future<ItemModel> fetchDetail(int id) async {
    try {
      // [GANTI SAAT RESPONSI: Susun URL endpoint detail]
      // Contoh 1 (RESTful): '${AppConfig.baseUrl}/${AppConfig.listEndpoint}/$id/'
      // Contoh 2 (query param): '${AppConfig.baseUrl}/${AppConfig.listEndpoint}?id=$id'
      final uri = Uri.parse(
        '${AppConfig.baseUrl}/${AppConfig.listEndpoint}/$id/',
      );

      final response = await http
          .get(uri, headers: _buildHeaders())
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // [GANTI SAAT RESPONSI: Jika response detail dibungkus wrapper, sesuaikan]
        // Contoh: data['data'] as Map, data['article'] as Map
        // Default langsung parse Map:
        return ItemModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw HttpException('Item tidak ditemukan: HTTP ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet');
    } catch (e) {
      rethrow;
    }
  }

  // ─── TEMPLATE: REQUEST DENGAN API KEY (Modul V) ───────────────────────────
  // [GANTI SAAT RESPONSI: Uncomment dan sesuaikan jika soal meminta Gemini API
  //  atau API lain dengan autentikasi khusus]
  //
  // /// Contoh: Request ke Gemini API dengan POST
  // static Future<String> generateWithGemini(String prompt) async {
  //   const url =
  //       'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  //   final uri = Uri.parse(url);
  //
  //   final body = jsonEncode({
  //     'contents': [
  //       {
  //         'parts': [
  //           {'text': prompt}
  //         ]
  //       }
  //     ]
  //   });
  //
  //   final response = await http.post(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-goog-api-key': AppConfig.apiKey, // [GANTI SAAT RESPONSI: API key Gemini]
  //     },
  //     body: body,
  //   ).timeout(_timeout);
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data['candidates'][0]['content']['parts'][0]['text'] ?? '';
  //   } else {
  //     throw HttpException('Gemini error: HTTP ${response.statusCode}');
  //   }
  // }

  // ─── TEMPLATE: POST REQUEST ───────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Uncomment jika soal meminta POST data ke API]
  //
  // static Future<bool> postItem(Map<String, dynamic> body) async {
  //   final uri = Uri.parse('${AppConfig.baseUrl}/${AppConfig.listEndpoint}/');
  //   final response = await http.post(
  //     uri,
  //     headers: _buildHeaders(),
  //     body: jsonEncode(body),
  //   ).timeout(_timeout);
  //   return response.statusCode == 201 || response.statusCode == 200;
  // }
}
