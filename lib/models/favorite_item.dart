// ============================================================
//  favorite_item.dart
//  Model Hive untuk menyimpan item favorit secara lokal.
//
//  !! PENTING !!
//  Setiap kali mengubah field @HiveField, WAJIB jalankan:
//    dart run build_runner build --delete-conflicting-outputs
//  Ini akan meng-generate ulang file favorite_item.g.dart
// ============================================================

// [GANTI SAAT RESPONSI: Import ini WAJIB ada]
import 'package:hive/hive.dart';

// [GANTI SAAT RESPONSI: Nama file yang di-generate oleh build_runner]
part 'favorite_item.g.dart';

// ─── ANOTASI HIVE ────────────────────────────────────────────────────────────
// [GANTI SAAT RESPONSI: typeId HARUS unik di seluruh aplikasi (integer 0-223)]
// Jika ada HiveType lain, gunakan typeId yang berbeda (0, 1, 2, ...)
@HiveType(typeId: 0)
class FavoriteItem extends HiveObject {

  // ─── FIELD HIVE ─────────────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Sesuaikan field dengan ItemModel di item_model.dart]
  // JANGAN mengubah fieldId (angka di @HiveField) setelah data sudah tersimpan!
  // Jika field BARU ditambahkan, gunakan fieldId integer berikutnya yang belum dipakai.

  @HiveField(0)
  // [GANTI SAAT RESPONSI: ID unik item dari API]
  late int itemId;

  @HiveField(1)
  // [GANTI SAAT RESPONSI: Judul/nama item]
  late String title;

  @HiveField(2)
  // [GANTI SAAT RESPONSI: Penulis/sumber/kategori]
  late String subtitleOrAuthor;

  @HiveField(3)
  // [GANTI SAAT RESPONSI: URL gambar untuk ditampilkan di FavoriteScreen]
  late String imageUrl;

  @HiveField(4)
  // [GANTI SAAT RESPONSI: Tanggal/harga/info tambahan]
  late String publishedAt;

  @HiveField(5)
  // [GANTI SAAT RESPONSI: Ringkasan/deskripsi singkat]
  late String summary;

  @HiveField(6)
  // [GANTI SAAT RESPONSI: URL situs resmi untuk url_launcher]
  late String webUrl;

  // [GANTI SAAT RESPONSI: Tambahkan @HiveField baru di sini jika model punya field tambahan]
  // @HiveField(7)
  // late String category;
  //
  // @HiveField(8)
  // late double price;

  // ─── CONSTRUCTOR ────────────────────────────────────────────────────────
  FavoriteItem({
    required this.itemId,
    required this.title,
    required this.subtitleOrAuthor,
    required this.imageUrl,
    required this.publishedAt,
    required this.summary,
    required this.webUrl,
  });

  // ─── Helper: Buat FavoriteItem dari ItemModel ────────────────────────────
  // [GANTI SAAT RESPONSI: Jika field ItemModel berubah, update factory ini juga]
  factory FavoriteItem.fromItemModel(dynamic item) {
    return FavoriteItem(
      itemId: item.id,
      title: item.title,
      subtitleOrAuthor: item.subtitleOrAuthor,
      imageUrl: item.imageUrl,
      publishedAt: item.publishedAt,
      summary: item.summary,
      webUrl: item.webUrl,
    );
  }

  @override
  String toString() => 'FavoriteItem(itemId: $itemId, title: $title)';
}
