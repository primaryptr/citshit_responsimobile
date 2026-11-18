// ============================================================
//  list_screen.dart
//  Halaman List dengan: loading indicator, filter chip dinamis,
//  search bar opsional, dan ListTile dengan gambar network.
//  Saat Responsi: Sesuaikan filter, field yang ditampilkan, dan navigasi detail.
// ============================================================

import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../config/app_config.dart';
import '../models/item_model.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  // [GANTI SAAT RESPONSI: Tambahkan parameter lain jika diperlukan]
  final String title;
  final String endpoint;

  const ListScreen({
    super.key,
    required this.title,
    required this.endpoint,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<ItemModel> _allItems = [];
  List<ItemModel> _filteredItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  // ── Filter & Search ─────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Jika tidak butuh filter/search, hapus bagian ini]
  String _selectedFilter = 'Semua'; // Label filter aktif
  List<String> _filterOptions = ['Semua']; // Opsi filter dinamis
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSearch = false; // Toggle tampil/sembunyikan search bar

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── FETCH DATA ────────────────────────────────────────────────────────────
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // [GANTI SAAT RESPONSI: ApiService.fetchList() sudah handle endpoint dari AppConfig]
      // Jika ListScreen dipanggil dengan endpoint berbeda-beda (multi-kategori),
      // pertimbangkan untuk menambah parameter ke fetchList()
      final items = await ApiService.fetchList();

      // ── Build filter options dari data ────────────────────────────────
      // [GANTI SAAT RESPONSI: Ganti 'subtitleOrAuthor' dengan field yang akan dijadikan filter]
      // Contoh: item.category, item.brand, item.type, item.status
      final filterSet = items.map((item) => item.subtitleOrAuthor).toSet();
      final filters = ['Semua', ...filterSet.toList()..sort()];

      setState(() {
        _allItems = items;
        _filteredItems = items;
        _filterOptions = filters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ─── FILTER LOGIC ──────────────────────────────────────────────────────────
  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilterAndSearch();
    });
  }

  void _applySearch(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilterAndSearch();
    });
  }

  void _applyFilterAndSearch() {
    _filteredItems = _allItems.where((item) {
      // [GANTI SAAT RESPONSI: Sesuaikan field yang dicari & difilter]

      // Filter chip berdasarkan subtitleOrAuthor
      final matchFilter = _selectedFilter == 'Semua' ||
          item.subtitleOrAuthor == _selectedFilter;

      // Search berdasarkan title dan subtitleOrAuthor
      final matchSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subtitleOrAuthor
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      return matchFilter && matchSearch;
    }).toList();
  }

  // ─── BUILD UI ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // [GANTI SAAT RESPONSI: Judul AppBar dari parameter widget.title]
        title: Text(widget.title),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // ── Toggle Search Bar ─────────────────────────────────────────
          // [GANTI SAAT RESPONSI: Hapus tombol ini jika soal tidak meminta Search]
          IconButton(
            icon: Icon(_showSearch ? Icons.search_off : Icons.search),
            tooltip: 'Cari',
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchController.clear();
                  _applySearch('');
                }
              });
            },
          ),
          // ── Refresh ───────────────────────────────────────────────────
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _fetchData,
          ),
        ],
      ),

      body: Column(
        children: [
          // ── Search Bar ───────────────────────────────────────────────────
          // [GANTI SAAT RESPONSI: Sembunyikan dengan menghapus blok AnimatedContainer ini]
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _showSearch ? 60 : 0,
            child: _showSearch
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _applySearch,
                      decoration: InputDecoration(
                        // [GANTI SAAT RESPONSI: Hint text search]
                        hintText: 'Cari item...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _applySearch('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Filter Chips ─────────────────────────────────────────────────
          // [GANTI SAAT RESPONSI: Sembunyikan dengan menghapus blok SizedBox ini
          //  jika soal tidak meminta filter]
          if (_filterOptions.length > 1)
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  final option = _filterOptions[index];
                  final isSelected = _selectedFilter == option;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (_) => _applyFilter(option),
                      selectedColor: AppConfig.primaryColor.shade100,
                      checkmarkColor: AppConfig.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppConfig.primaryColor
                            : Colors.grey.shade700,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),

          // ── Konten Utama ──────────────────────────────────────────────────
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        // [GANTI SAAT RESPONSI: Ganti dengan loading widget custom jika diminta]
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_filteredItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Tidak ada item ditemukan', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return _buildListTile(item);
        },
      ),
    );
  }

  // ─── LIST TILE ─────────────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Sesuaikan tampilan setiap item di list]
  Widget _buildListTile(ItemModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        // ── Gambar (leading) ────────────────────────────────────────────
        // [GANTI SAAT RESPONSI: Ubah ukuran/shape gambar sesuai kebutuhan]
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            // [GANTI SAAT RESPONSI: Ganti placeholder icon jika gambar gagal dimuat]
            errorBuilder: (context, error, stackTrace) => Container(
              width: 64,
              height: 64,
              color: AppConfig.primaryColor.shade100,
              // ignore: prefer_const_constructors
              child: Icon(
                Icons.broken_image_outlined, // [GANTI SAAT RESPONSI: ikon fallback]
                color: AppConfig.primaryColor,
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 64,
                height: 64,
                color: Colors.grey.shade200,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Judul ───────────────────────────────────────────────────────
        // [GANTI SAAT RESPONSI: Ganti item.title dengan field yang ingin ditampilkan]
        title: Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),

        // ── Subtitle ────────────────────────────────────────────────────
        // [GANTI SAAT RESPONSI: Ganti field subtitle sesuai data yang ingin tampil]
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.subtitleOrAuthor, // [GANTI SAAT RESPONSI: field subtitle]
              style: TextStyle(
                color: AppConfig.primaryColor.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.publishedAt, // [GANTI SAAT RESPONSI: field tanggal/harga/status]
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

        // ── Navigasi ke Detail ──────────────────────────────────────────
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {
          // [GANTI SAAT RESPONSI: Navigasi ke DetailScreen]
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(
                // [GANTI SAAT RESPONSI: Jika fetch detail by ID, kirim item.id]
                // Jika pass seluruh object, ubah DetailScreen untuk terima ItemModel
                itemId: item.id,
                // Opsional: kirim item langsung agar DetailScreen tidak perlu fetch ulang
                // preloadedItem: item,
              ),
            ),
          );
        },
      ),
    );
  }
}
