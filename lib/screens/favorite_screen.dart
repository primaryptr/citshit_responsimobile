// ============================================================
//  favorite_screen.dart
//  Halaman Favorit: sinkron real-time dengan Hive Box
//  menggunakan ValueListenableBuilder.
// ============================================================

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';
import '../models/favorite_item.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // [GANTI SAAT RESPONSI: Judul AppBar halaman favorit]
        title: const Text('Favorit Saya'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // ── Tombol Hapus Semua ─────────────────────────────────────────
          // [GANTI SAAT RESPONSI: Hapus tombol ini jika tidak diperlukan]
          ValueListenableBuilder<Box<FavoriteItem>>(
            valueListenable:
                Hive.box<FavoriteItem>(AppConfig.hiveBoxFavorites).listenable(),
            builder: (context, box, _) {
              if (box.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Hapus Semua Favorit',
                onPressed: () => _confirmClearAll(context, box),
              );
            },
          ),
        ],
      ),

      // ── ValueListenableBuilder: Otomatis rebuild saat Hive Box berubah ──
      // [GANTI SAAT RESPONSI: Ini adalah cara standar membaca Hive Box secara reaktif]
      body: ValueListenableBuilder<Box<FavoriteItem>>(
        valueListenable:
            Hive.box<FavoriteItem>(AppConfig.hiveBoxFavorites).listenable(),
        builder: (context, box, _) {
          // Konversi Box values ke List
          final favorites = box.values.toList().cast<FavoriteItem>();

          if (favorites.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final fav = favorites[index];
              return _buildFavoriteTile(context, fav);
            },
          );
        },
      ),
    );
  }

  // ─── EMPTY STATE ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            // [GANTI SAAT RESPONSI: Warna ikon kosong]
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            // [GANTI SAAT RESPONSI: Pesan saat belum ada favorit]
            'Belum ada item favorit',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan item dari halaman Detail',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ─── TILE FAVORIT ──────────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Sesuaikan tampilan setiap item favorit]
  Widget _buildFavoriteTile(BuildContext context, FavoriteItem fav) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        // ── Gambar ──────────────────────────────────────────────────────
        // [GANTI SAAT RESPONSI: Ubah tampilan gambar sesuai kebutuhan]
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: fav.imageUrl.isNotEmpty
              ? Image.network(
                  fav.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildImageFallback(),
                )
              : _buildImageFallback(),
        ),

        // ── Judul & Subtitle ─────────────────────────────────────────────
        // [GANTI SAAT RESPONSI: Field yang ditampilkan di tile favorit]
        title: Text(
          fav.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              fav.subtitleOrAuthor, // [GANTI SAAT RESPONSI: field subtitle]
              style: TextStyle(
                color: AppConfig.primaryColor.shade700,
                fontSize: 12,
              ),
            ),
            if (fav.publishedAt.isNotEmpty)
              Text(
                fav.publishedAt, // [GANTI SAAT RESPONSI: field tanggal/harga]
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
          ],
        ),

        // ── Tombol Hapus ────────────────────────────────────────────────
        // [GANTI SAAT RESPONSI: Ganti dengan Swipe-to-delete jika diminta]
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
          tooltip: 'Hapus dari Favorit',
          onPressed: () async {
            final box = Hive.box<FavoriteItem>(AppConfig.hiveBoxFavorites);
            await box.delete(fav.itemId);
          },
        ),

        // ── Navigasi ke Detail ──────────────────────────────────────────
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(itemId: fav.itemId),
            ),
          );
        },
      ),
    );
  }

  // ─── IMAGE FALLBACK ────────────────────────────────────────────────────────
  Widget _buildImageFallback() {
    return Container(
      width: 56,
      height: 56,
      color: AppConfig.primaryColor.shade100,
      child: Icon(
        Icons.favorite_rounded, // [GANTI SAAT RESPONSI: ikon fallback favorit]
        color: AppConfig.primaryColor.shade300,
      ),
    );
  }

  // ─── HAPUS SEMUA ───────────────────────────────────────────────────────────
  Future<void> _confirmClearAll(
      BuildContext context, Box<FavoriteItem> box) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semua Favorit?'),
        content: const Text(
          'Semua item favorit akan dihapus. Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Hapus Semua', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await box.clear();
    }
  }
}
