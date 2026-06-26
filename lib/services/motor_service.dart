import '../models/motor_model.dart';
import 'api_service.dart';

class MotorService {
  static final MotorService _instance = MotorService._();
  factory MotorService() => _instance;
  MotorService._();

  final ApiService _api = ApiService();

  final List<Motor> _localMotors = [
    Motor(id: '1', nama: 'Honda Vario 160', tahun: 2022, harga: 18500000, kilometer: 12000, warna: 'Putih', kondisi: 'Sangat Baik', tipe: 'Matic', merek: 'Honda', lokasi: 'Bandung', showroom: 'Showroom Maju Jaya', rating: 4.8, gambarUrl: 'https://picsum.photos/seed/vario/400/280', isFavorit: true),
    Motor(id: '2', nama: 'Yamaha NMAX 155', tahun: 2021, harga: 22000000, kilometer: 18500, warna: 'Hitam', kondisi: 'Baik', tipe: 'Matic', merek: 'Yamaha', lokasi: 'Jakarta', showroom: 'Showroom Berkah Motor', rating: 4.5, gambarUrl: 'https://picsum.photos/seed/nmax/400/280', isFavorit: false),
    Motor(id: '3', nama: 'Kawasaki KLX 150', tahun: 2020, harga: 26000000, kilometer: 9800, warna: 'Hijau', kondisi: 'Sangat Baik', tipe: 'Trail', merek: 'Kawasaki', lokasi: 'Bandung', showroom: 'Showroom Garuda Motor', rating: 4.9, gambarUrl: 'https://picsum.photos/seed/klx/400/280', isFavorit: false),
    Motor(id: '4', nama: 'Honda CB150R', tahun: 2021, harga: 19800000, kilometer: 15200, warna: 'Merah', kondisi: 'Baik', tipe: 'Sport', merek: 'Honda', lokasi: 'Depok', showroom: 'Showroom Maju Jaya', rating: 4.6, gambarUrl: 'https://picsum.photos/seed/cb150r/400/280', isFavorit: true),
    Motor(id: '5', nama: 'Yamaha Mio M3', tahun: 2023, harga: 13500000, kilometer: 5000, warna: 'Biru', kondisi: 'Sangat Baik', tipe: 'Matic', merek: 'Yamaha', lokasi: 'Bekasi', showroom: 'Showroom Berkah Motor', rating: 4.7, gambarUrl: 'https://picsum.photos/seed/miom3/400/280', isFavorit: false),
    Motor(id: '6', nama: 'Suzuki GSX-R150', tahun: 2020, harga: 24500000, kilometer: 20000, warna: 'Hitam-Biru', kondisi: 'Baik', tipe: 'Sport', merek: 'Suzuki', lokasi: 'Tangerang', showroom: 'Showroom Garuda Motor', rating: 4.4, gambarUrl: 'https://picsum.photos/seed/gsx/400/280', isFavorit: false),
  ];

  List<Motor> _motors = [];
  bool _isFromApi = false;

  Motor? _fromJson(Map<String, dynamic> json) {
    try {
      final images = json['image_urls'];
      final gambarUrl = (images is List && images.isNotEmpty)
          ? images.first.toString()
          : 'https://picsum.photos/seed/${json['id']}/400/280';
      return Motor(
        id: json['id'].toString(),
        nama: json['name'] ?? '',
        tahun: json['year'] ?? 0,
        harga: (json['price'] ?? 0).toDouble(),
        kilometer: json['kilometer'] ?? 0,
        warna: json['color'] ?? '',
        kondisi: json['condition'] ?? '',
        tipe: json['type'] ?? '',
        merek: json['brand'] ?? '',
        lokasi: json['location'] ?? '',
        showroom: (json['showroom'] is Map) ? (json['showroom']['name'] ?? '') : '',
        rating: (json['rating'] ?? (json['showroom'] is Map ? json['showroom']['rating'] : 0)).toDouble(),
        gambarUrl: gambarUrl,
        isFavorit: false,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<Motor>> getMotors({String? kategori, String? search}) async {
    if (_motors.isEmpty) {
      await _fetchFromApi();
    }

    final source = _isFromApi ? _motors : _localMotors;
    return source.where((m) {
      final cocokKategori = kategori == null || kategori == 'Semua' || m.tipe == kategori;
      final cocokCari = search == null || search.isEmpty ||
          m.nama.toLowerCase().contains(search.toLowerCase()) ||
          m.merek.toLowerCase().contains(search.toLowerCase());
      return cocokKategori && cocokCari;
    }).toList();
  }

  Future<void> _fetchFromApi() async {
    try {
      final res = await _api.get('/motors');
      if (res['success'] == true && res['data'] != null) {
        final list = res['data'] as List;
        _motors = list.map((e) => _fromJson(e as Map<String, dynamic>)).whereType<Motor>().toList();
        _isFromApi = true;
        return;
      }
    } catch (_) {}
    _isFromApi = false;
  }

  Motor? getMotorById(String id) {
    final source = _isFromApi ? _motors : _localMotors;
    try {
      return source.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Motor> getMotorsByShowroom(String showroomNama) {
    final source = _isFromApi ? _motors : _localMotors;
    return source.where((m) => m.showroom == showroomNama).toList();
  }

  void toggleFavorit(String id) {
    final motor = getMotorById(id);
    if (motor != null) {
      motor.isFavorit = !motor.isFavorit;
    }
  }

  List<Motor> getFavoritMotors() {
    final source = _isFromApi ? _motors : _localMotors;
    return source.where((m) => m.isFavorit).toList();
  }
}
