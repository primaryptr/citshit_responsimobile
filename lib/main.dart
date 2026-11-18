// ============================================================
//  main.dart
//  Entry point aplikasi. Inisialisasi Hive & jalankan app.
// ============================================================

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/app_config.dart';
import 'models/favorite_item.dart';
import 'screens/login_screen.dart';

// [GANTI SAAT RESPONSI: Import NotificationService jika soal meminta notifikasi]
// import 'services/notification_service.dart';

Future<void> main() async {
  // Pastikan Flutter binding siap sebelum async operations
  WidgetsFlutterBinding.ensureInitialized();

  // ─── INISIALISASI HIVE ───────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Jika menambah HiveType baru, daftarkan adapter-nya di sini]
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteItemAdapter()); // Auto-generated oleh build_runner
  await Hive.openBox<FavoriteItem>(AppConfig.hiveBoxFavorites);

  // ─── INISIALISASI NOTIFIKASI (Modul VII) ─────────────────────────────────
  // [GANTI SAAT RESPONSI: Uncomment baris ini jika soal meminta Notifikasi]
  // await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // [GANTI SAAT RESPONSI: Judul aplikasi di task switcher]
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: false,

      // ─── TEMA ───────────────────────────────────────────────────────────
      // [GANTI SAAT RESPONSI: Ganti primarySwatch dengan AppConfig.primaryColor]
      theme: ThemeData(
        primarySwatch: AppConfig.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConfig.primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        // [GANTI SAAT RESPONSI: Kustomisasi font global]
        // fontFamily: 'Poppins',

        // [GANTI SAAT RESPONSI: Kustomisasi AppBar theme global]
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // [GANTI SAAT RESPONSI: Kustomisasi InputDecoration global]
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),

        // [GANTI SAAT RESPONSI: Kustomisasi Card theme global]
        cardTheme: CardThemeData(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),

        // [GANTI SAAT RESPONSI: Kustomisasi ElevatedButton global]
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      // [GANTI SAAT RESPONSI: Mode gelap — uncomment untuk dark theme]
      // darkTheme: ThemeData.dark().copyWith(
      //   colorScheme: ColorScheme.dark(primary: AppConfig.primaryColor),
      // ),
      // themeMode: ThemeMode.system,

      // ─── HALAMAN AWAL ───────────────────────────────────────────────────
      // [GANTI SAAT RESPONSI: Ganti LoginScreen dengan screen lain jika soal
      //  tidak memerlukan login]
      home: const LoginScreen(),

      // ─── NAMED ROUTES (opsional) ─────────────────────────────────────────
      // [GANTI SAAT RESPONSI: Gunakan routes jika soal meminta navigasi bernama]
      // routes: {
      //   '/login': (context) => const LoginScreen(),
      //   '/home': (context) => const HomeScreen(),
      //   '/list': (context) => const ListScreen(title: '', endpoint: ''),
      //   '/favorite': (context) => const FavoriteScreen(),
      // },
    );
  }
}
