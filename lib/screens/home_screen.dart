// ============================================================
//  home_screen.dart
//  Halaman Utama: Daftar menu kategori + tombol Logout.
//  Saat Responsi: Edit list 'menus' di bawah untuk mengubah
//  kategori/endpoint tanpa menyentuh UI Card.
// ============================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'login_screen.dart';
import 'list_screen.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username =
          prefs.getString(AppConfig.prefKeyUsername) ?? AppConfig.staticUsername;
    });
  }

  // ─── KONFIGURASI MENU ─────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Tambah/hapus/ubah item menu di sini sesuai soal]
  // Setiap item adalah satu navigasi ke ListScreen dengan endpoint berbeda.
  //
  // Format setiap Map:
  //   'title'    -> Nama menu yang tampil di Card
  //   'icon'     -> Ikon menu (Icons.xxx)
  //   'color'    -> Warna card/aksen
  //   'endpoint' -> Endpoint API (AppConfig.listEndpoint atau override di sini)
  //   'subtitle' -> Deskripsi singkat menu
  //
  // Contoh soal yang berbeda-beda:
  //   News    -> {'title': 'Berita', 'endpoint': 'articles'}
  //   SWAPI   -> {'title': 'People', 'endpoint': 'people'}
  //   Product -> {'title': 'Produk', 'endpoint': 'products'}
  //   Launch  -> {'title': 'Peluncuran', 'endpoint': 'launches'}
  static const List<Map<String, dynamic>> menus = [
    {
      // [GANTI SAAT RESPONSI: Menu pertama]
      'title': 'Daftar Item',
      'subtitle': 'Lihat semua item dari API',
      'icon': Icons.list_alt_rounded,
      'color': Colors.indigo,
      'endpoint': AppConfig.listEndpoint,
    },
    {
      // [GANTI SAAT RESPONSI: Menu kedua — hapus jika hanya 1 kategori]
      'title': 'Kategori 2',
      'subtitle': 'Deskripsi kategori kedua',
      'icon': Icons.category_rounded,
      'color': Colors.teal,
      'endpoint': 'second-endpoint', // [GANTI SAAT RESPONSI]
    },
    {
      // [GANTI SAAT RESPONSI: Menu ketiga — hapus jika tidak diperlukan]
      'title': 'Kategori 3',
      'subtitle': 'Deskripsi kategori ketiga',
      'icon': Icons.explore_rounded,
      'color': Colors.orange,
      'endpoint': 'third-endpoint', // [GANTI SAAT RESPONSI]
    },
  ];

  // ─── LOGOUT ────────────────────────────────────────────────────────────────
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      // [GANTI SAAT RESPONSI: Jika ingin clear semua data saat logout, gunakan prefs.clear()]
      await prefs.setBool(AppConfig.prefKeyIsLoggedIn, false);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  // ─── BUILD UI ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // [GANTI SAAT RESPONSI: Jika soal meminta BottomNavigationBar (Modul IV),
    //  ganti Scaffold ini dengan Scaffold + bottomNavigationBar + IndexedStack.
    //  Contoh implementasi ada di komentar di bawah build()]
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // [GANTI SAAT RESPONSI: Judul AppBar halaman home]
        // ignore: prefer_const_constructors
        title: Text(AppConfig.appTitle),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Tombol ke Halaman Favorit
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            tooltip: 'Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },
          ),

          // Tombol Logout
          // [GANTI SAAT RESPONSI: Tombol logout bisa dipindah ke Drawer jika soal meminta]
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Selamat Datang ────────────────────────────────────────
          // ignore: prefer_const_constructors
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // [GANTI SAAT RESPONSI: Pesan sambutan]
                  'Selamat Datang,',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _username.isEmpty ? 'Pengguna' : _username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              // [GANTI SAAT RESPONSI: Label di atas grid menu]
              'Pilih Kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Grid Menu ──────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                // [GANTI SAAT RESPONSI: Ubah crossAxisCount jika menu lebih dari 3]
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return _buildMenuCard(menu);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── CARD MENU ─────────────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Ubah tampilan card sesuai kebutuhan visual soal]
  Widget _buildMenuCard(Map<String, dynamic> menu) {
    final color = menu['color'] as Color? ?? AppConfig.primaryColor;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // [GANTI SAAT RESPONSI: Navigasi ke ListScreen dengan endpoint yang dipilih]
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListScreen(
                // [GANTI SAAT RESPONSI: Teruskan parameter yang diperlukan ListScreen]
                title: menu['title'] as String,
                endpoint: menu['endpoint'] as String,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(menu['icon'] as IconData, size: 44, color: color),
              const SizedBox(height: 10),
              Text(
                menu['title'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                menu['subtitle'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── TEMPLATE: BottomNavigationBar (Modul IV) ────────────────────────────────
// [GANTI SAAT RESPONSI: Jika soal meminta tab bawah, ganti return Scaffold
//  di atas dengan implementasi ini]
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = const [
//     // [GANTI SAAT RESPONSI: Isi sesuai halaman yang dibutuhkan]
//     ListScreen(title: 'Home', endpoint: AppConfig.listEndpoint),
//     FavoriteScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (i) => setState(() => _selectedIndex = i),
//         selectedItemColor: AppConfig.primaryColor,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
//         ],
//       ),
//     );
//   }
// }
