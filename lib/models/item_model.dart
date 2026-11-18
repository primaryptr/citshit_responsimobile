// ============================================================
//  item_model.dart
//  Model data utama yang di-parse dari response JSON API.
//  Saat Responsi: Sesuaikan nama field fromJson dengan key JSON asli.
// ============================================================

class ItemModel {
  final int id;
  final String title;
  final String subtitleOrAuthor;
  final String imageUrl;
  final String publishedAt;
  final String summary;
  final String webUrl;

  // [GANTI SAAT RESPONSI: Tambahkan field tambahan di sini jika JSON punya lebih banyak data]
  // Contoh:
  //   final String category;
  //   final double price;
  //   final int rating;
  //   final bool isFeatured;

  const ItemModel({
    required this.id,
    required this.title,
    required this.subtitleOrAuthor,
    required this.imageUrl,
    required this.publishedAt,
    required this.summary,
    required this.webUrl,
  });

  // ─── FACTORY fromJson ───────────────────────────────────────────────────
  // [GANTI SAAT RESPONSI: Sesuaikan setiap key string dengan JSON response asli]

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      // [GANTI SAAT RESPONSI: key id dari JSON — biasanya 'id', 'ID', atau 'article_id']
      id: json['id'] ?? 0,

      // [GANTI SAAT RESPONSI: key judul/nama — misal 'title', 'name', 'headline']
      title: json['title'] ?? 'Tanpa Judul',

      // [GANTI SAAT RESPONSI: key penulis/kategori/sumber]
      // Contoh: 'news_site', 'author', 'category', 'clan', 'brand', 'channel'
      subtitleOrAuthor: json['news_site'] ?? json['author'] ?? 'Unknown',

      // [GANTI SAAT RESPONSI: key URL gambar]
      // Contoh 1 (string langsung): json['image_url'] ?? json['urlToImage'] ?? ''
      // Contoh 2 (dalam list): (json['images'] as List?)?.isNotEmpty == true
      //                          ? json['images'][0]['url'] ?? ''
      //                          : ''
      imageUrl: json['image_url'] ?? json['urlToImage'] ?? '',

      // [GANTI SAAT RESPONSI: key tanggal/harga/status/info tambahan]
      // Contoh: 'published_at', 'createdAt', 'price', 'launch_date', 'status'
      publishedAt: json['published_at'] ?? json['createdAt'] ?? '',

      // [GANTI SAAT RESPONSI: key deskripsi/ringkasan konten]
      // Contoh: 'summary', 'description', 'content', 'body', 'overview'
      summary: json['summary'] ?? json['description'] ?? '',

      // [GANTI SAAT RESPONSI: key URL situs resmi untuk url_launcher]
      // Contoh: 'url', 'link', 'web_url', 'article_url', 'homepage'
      webUrl: json['url'] ?? json['link'] ?? '',
    );
  }

  // ─── toJson (opsional, untuk debugging atau local storage) ───────────────
  // [GANTI SAAT RESPONSI: Sesuaikan key dengan fromJson jika digunakan]
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'news_site': subtitleOrAuthor,
      'image_url': imageUrl,
      'published_at': publishedAt,
      'summary': summary,
      'url': webUrl,
    };
  }

  @override
  String toString() => 'ItemModel(id: $id, title: $title)';
}
