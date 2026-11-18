// ============================================================
//  app_config.dart
//  Pusat semua konstanta aplikasi.
//  Saat Responsi: HANYA FILE INI yang perlu diedit pertama kali.
// ============================================================

import 'package:flutter/material.dart';

class AppConfig {
  AppConfig._(); // private constructor — tidak perlu di-instantiate

  // ─── IDENTITAS APLIKASI ───────────────────────────────────────────────────

  // [GANTI SAAT RESPONSI: Judul aplikasi sesuai soal, tampil di AppBar & title bar]
  static const String appTitle = 'Responsi App';

  // [GANTI SAAT RESPONSI: Warna tema utama. Ganti Colors.indigo dengan warna soal]
  // Contoh: Colors.teal, Colors.deepPurple, Colors.orange, Colors.red, Colors.blue
  static const MaterialColor primaryColor = Colors.indigo;

  // ─── API CONFIGURATION ───────────────────────────────────────────────────

  // [GANTI SAAT RESPONSI: Base URL API dari soal tanpa trailing slash]
  // Contoh:
  //   SWAPI        -> 'https://swapi.dev/api'
  //   NewsAPI      -> 'https://newsapi.org/v2'
  //   Spaceflight  -> 'https://api.spaceflightnewsapi.net/v4'
  //   Hacker News  -> 'https://hacker-news.firebaseio.com/v0'
  //   JSONPlaceholder -> 'https://jsonplaceholder.typicode.com'
  static const String baseUrl = 'https://api.example.com/v1';

  // [GANTI SAAT RESPONSI: endpoint utama untuk daftar item, tanpa leading slash]
  // Contoh: 'articles', 'people', 'products', 'posts', 'launches'
  static const String listEndpoint = 'articles';

  // [GANTI SAAT RESPONSI: Jika API memerlukan API Key, isi di sini]
  // Jika tidak butuh API Key, biarkan kosong ('') dan hapus header di api_service.dart
  // Contoh: Gemini API Key, NewsAPI Key, OpenWeatherMap Key, dll.
  static const String apiKey = '';

  // [GANTI SAAT RESPONSI: Jenis autentikasi header API]
  // Pilih salah satu, comment yang tidak dipakai:
  //   'x-api-key'       -> untuk banyak REST API publik (misal NewsAPI: 'X-Api-Key')
  //   'Bearer'          -> untuk JWT / OAuth2 token
  //   'x-goog-api-key'  -> untuk Google API (Gemini, Maps, dll)
  static const String apiKeyHeader = 'x-api-key';

  // ─── SHARED PREFERENCES KEYS ─────────────────────────────────────────────

  // [GANTI SAAT RESPONSI: Key untuk menyimpan status login]
  static const String prefKeyIsLoggedIn = 'isLoggedIn';

  // [GANTI SAAT RESPONSI: Key untuk menyimpan username saat ini]
  static const String prefKeyUsername = 'username';

  // [GANTI SAAT RESPONSI: Prefix key untuk menyimpan password user (Mode Register)]
  // Password disimpan sebagai 'pass_<username>'
  static const String prefKeyPasswordPrefix = 'pass_';

  // ─── AUTENTIKASI ─────────────────────────────────────────────────────────

  // [GANTI SAAT RESPONSI: Mode autentikasi login]
  //   true  -> Login menggunakan akun yang sudah didaftarkan via Register screen
  //   false -> Login menggunakan akun STATIS/HARDCODED di bawah (seperti Modul III)
  static const bool useRegisterAuth = false;

  // [GANTI SAAT RESPONSI: Jika useRegisterAuth = false, isi kredensial statis di sini]
  static const String staticUsername = 'admin';
  static const String staticPassword = '12345';

  // ─── HIVE CONFIGURATION ──────────────────────────────────────────────────

  // [GANTI SAAT RESPONSI: Nama box Hive untuk menyimpan item favorit]
  static const String hiveBoxFavorites = 'favorites_box';

  // [GANTI SAAT RESPONSI: TypeId Hive untuk FavoriteItem (integer unik, 0-223)]
  // Jika menambahkan HiveType baru, gunakan typeId yang berbeda (1, 2, 3, ...)
  static const int hiveFavoriteTypeId = 0;

  // ─── NOTIFIKASI (Modul VII) ───────────────────────────────────────────────

  // [GANTI SAAT RESPONSI: Uncomment dan sesuaikan jika soal meminta Notifikasi]
  // static const String notifChannelId = 'responsi_channel';
  // static const String notifChannelName = 'Responsi Notifications';
  // static const String notifChannelDesc = 'Channel untuk notifikasi aplikasi';
  // static const int notifImmediateId = 1;
  // static const int notifScheduledId = 2;
}
