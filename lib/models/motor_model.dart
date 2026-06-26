class Motor {
  final String id;
  final String nama;
  final int tahun;
  final double harga;
  final int kilometer;
  final String warna;
  final String kondisi;
  final String tipe;
  final String merek;
  final String lokasi;
  final String showroom;
  final double rating;
  final String gambarUrl;
  bool isFavorit;

  Motor({
    required this.id,
    required this.nama,
    required this.tahun,
    required this.harga,
    required this.kilometer,
    required this.warna,
    required this.kondisi,
    required this.tipe,
    required this.merek,
    required this.lokasi,
    required this.showroom,
    required this.rating,
    required this.gambarUrl,
    this.isFavorit = false,
  });
}

class Showroom {
  final String id;
  final String nama;
  final String alamat;
  final String kota;
  final double rating;
  final int jumlahReview;
  final int stokMotor;
  final String telepon;
  final String jamBuka;
  final bool isVerified;
  final List<ReviewShowroom> reviews;

  Showroom({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.kota,
    required this.rating,
    required this.jumlahReview,
    required this.stokMotor,
    required this.telepon,
    required this.jamBuka,
    required this.isVerified,
    required this.reviews,
  });
}

class ReviewShowroom {
  final String nama;
  final double rating;
  final String komentar;
  final String tanggal;
  final String avatarUrl;

  ReviewShowroom({
    required this.nama,
    required this.rating,
    required this.komentar,
    required this.tanggal,
    required this.avatarUrl,
  });
}
