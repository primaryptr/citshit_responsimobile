// ============================================================
//  detail_screen.dart
//  Halaman Detail item: fetch by ID, url_launcher, toggle Favorit Hive.
//  Saat Responsi: Sesuaikan field yang ditampilkan dan tombol aksi.
// ============================================================

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_service.dart';
import '../config/app_config.dart';
import '../models/item_model.dart';
import '../models/favorite_item.dart';

class DetailScreen extends StatefulWidget {
  final int itemId;

  // [GANTI SAAT RESPONSI: Jika ingin skip fetch ulang, uncomment parameter ini
  //  dan kirim object dari ListScreen]
  // final ItemModel? preloadedItem;

  const DetailScreen({
    super.key,
    required this.itemId,
    // this.preloadedItem,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ItemModel? _item;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isFavorite = false;

  // Referensi Hive Box untuk favorit
  late Box<FavoriteItem> _favBox;

  @override
  void initState() {
    super.initState();
    _favBox = Hive.box<FavoriteItem>(AppConfig.hiveBoxFavorites);
    _fetchDetail();
  }

  // ─── FETCH DETAIL ──────────────────────────────────────────────────────────
  Future<void> _fetchDetail() async {
    // [GANTI SAAT RESPONSI: Jika pakai preloadedItem, skip fetch]
    // if (widget.preloadedItem != null) {
    //   setState(() { _item = widget.preloadedItem; _isLoading = false; });
    //   _checkFavoriteStatus();
    //   return;
    // }

    try {
      final item = await ApiService.fetchDetail(widget.itemId);
      if (mounted) {
        setState(() {
          _item = item;
          _isLoading = false;
        });
        _checkFavoriteStatus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // ─── FAVORITE LOGIC ────────────────────────────────────────────────────────
  void _checkFavoriteStatus() {
    // [GANTI SAAT RESPONSI: Key Hive menggunakan itemId sebagai key unik]
    setState(() {
      _isFavorite = _favBox.containsKey(widget.itemId);
    });
  }

  Future<void> _toggleFavorite() async {
    if (_item == null) return;

    if (_isFavorite) {
      // ── Hapus dari Favorit ─────────────────────────────────────────
      await _favBox.delete(widget.itemId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dihapus dari Favorit'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // ── Tambah ke Favorit ──────────────────────────────────────────
      final favItem = FavoriteItem.fromItemModel(_item!);
      await _favBox.put(widget.itemId, favItem);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ditambahkan ke Favorit!'),
            backgroundColor: AppConfig.primaryColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    _checkFavoriteStatus();
  }

  // ─── URL LAUNCHER ──────────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: _launchWeb membuka webUrl di browser eksternal]
  Future<void> _launchWeb() async {
    if (_item == null || _item!.webUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL tidak tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final uri = Uri.parse(_item!.webUrl);

    // [GANTI SAAT RESPONSI: mode launcher]
    // LaunchMode.externalApplication  -> buka di browser eksternal (umum)
    // LaunchMode.inAppBrowserView      -> buka di in-app browser
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak bisa membuka: ${_item!.webUrl}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─── BUILD UI ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // [GANTI SAAT RESPONSI: Judul AppBar detail]
        title: Text(_item?.title ?? 'Detail', maxLines: 1,
            overflow: TextOverflow.ellipsis),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // ── Tombol Favorit di AppBar ─────────────────────────────────
          // [GANTI SAAT RESPONSI: Pindahkan ke FAB atau tombol di body jika diminta]
          if (_item != null)
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(_isFavorite),
                  color: _isFavorite ? Colors.pinkAccent : Colors.white,
                ),
              ),
              tooltip: _isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
              onPressed: _toggleFavorite,
            ),
        ],
      ),

      body: _buildBody(),

      // ── Tombol Buka Web (FAB) ───────────────────────────────────────────
      // [GANTI SAAT RESPONSI: Jika soal meminta tombol url_launcher di body bukan FAB,
      //  pindahkan ElevatedButton ke dalam _buildDetailContent()]
      floatingActionButton: _item != null && _item!.webUrl.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _launchWeb,
              backgroundColor: AppConfig.primaryColor,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.open_in_browser_rounded),
              // [GANTI SAAT RESPONSI: Label tombol buka web]
              label: const Text('Buka Web'),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 12),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchDetail,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_item == null) return const SizedBox.shrink();

    return _buildDetailContent(_item!);
  }

  // ─── KONTEN DETAIL ─────────────────────────────────────────────────────────
  Widget _buildDetailContent(ItemModel item) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gambar Utama ─────────────────────────────────────────────────
          // [GANTI SAAT RESPONSI: Ubah tinggi gambar atau hapus jika tidak ada]
          if (item.imageUrl.isNotEmpty)
            Image.network(
              item.imageUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              // [GANTI SAAT RESPONSI: Placeholder saat gambar gagal]
              errorBuilder: (context, error, _) => Container(
                width: double.infinity,
                height: 220,
                color: AppConfig.primaryColor.shade100,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 72,
                  color: AppConfig.primaryColor.shade300,
                ),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Sumber/Kategori Badge ──────────────────────────────────
                // [GANTI SAAT RESPONSI: Ganti subtitleOrAuthor dengan field lain jika perlu]
                if (item.subtitleOrAuthor.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.subtitleOrAuthor,
                      style: TextStyle(
                        color: AppConfig.primaryColor.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // ── Judul ──────────────────────────────────────────────────
                // [GANTI SAAT RESPONSI: Field judul utama item]
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Tanggal / Info Tambahan ────────────────────────────────
                // [GANTI SAAT RESPONSI: Ganti publishedAt dengan field lain sesuai soal]
                if (item.publishedAt.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.publishedAt,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // ── Deskripsi / Summary ────────────────────────────────────
                // [GANTI SAAT RESPONSI: Field deskripsi/ringkasan konten]
                Text(
                  'Deskripsi', // [GANTI SAAT RESPONSI: label section]
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.summary.isEmpty
                      ? 'Deskripsi tidak tersedia.'
                      : item.summary,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // ── [GANTI SAAT RESPONSI: Tambahkan field tambahan di sini] ───
                // Contoh:
                // _buildInfoRow('Harga', item.price.toString()),
                // _buildInfoRow('Rating', item.rating.toString()),
                // _buildInfoRow('Status', item.status),

                // ── Tombol Buka Web (Alternatif di dalam body) ─────────────
                // [GANTI SAAT RESPONSI: Uncomment jika soal meminta tombol di body
                //  bukan sebagai FAB]
                // if (item.webUrl.isNotEmpty)
                //   SizedBox(
                //     width: double.infinity,
                //     child: ElevatedButton.icon(
                //       onPressed: _launchWeb,
                //       icon: const Icon(Icons.open_in_browser_rounded),
                //       label: const Text('Buka Situs Resmi'),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: AppConfig.primaryColor,
                //         foregroundColor: Colors.white,
                //         padding: const EdgeInsets.symmetric(vertical: 14),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //     ),
                //   ),

                // Spacer untuk FAB
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper: Baris Info ───────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Gunakan helper ini untuk menampilkan field tambahan]
  // Contoh penggunaan: _buildInfoRow('Harga', 'Rp 150.000')
  // ignore: unused_element
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
