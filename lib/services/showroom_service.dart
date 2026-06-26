import '../models/motor_model.dart';
import 'api_service.dart';

class ShowroomService {
  static final ShowroomService _instance = ShowroomService._();
  factory ShowroomService() => _instance;
  ShowroomService._();

  final ApiService _api = ApiService();

  final List<Showroom> _localShowrooms = [
    Showroom(id: '1', nama: 'Showroom Maju Jaya', alamat: 'Jl. Raya Purwakarta No. 88, Purwakarta', kota: 'Purwakarta', rating: 4.8, jumlahReview: 124, stokMotor: 32, telepon: '0812-3456-7890', jamBuka: 'Senin – Sabtu, 08.00 – 17.00', isVerified: true, reviews: [
      ReviewShowroom(nama: 'Andi Pratama', rating: 5, komentar: 'Pelayanan sangat ramah...', tanggal: '20 Jun 2025', avatarUrl: 'https://i.pravatar.cc/50?img=1'),
      ReviewShowroom(nama: 'Siti Rahayu', rating: 4, komentar: 'Proses beli cepat...', tanggal: '15 Jun 2025', avatarUrl: 'https://i.pravatar.cc/50?img=5'),
      ReviewShowroom(nama: 'Budi Santoso', rating: 5, komentar: 'BPKB dan STNK langsung diurus...', tanggal: '10 Jun 2025', avatarUrl: 'https://i.pravatar.cc/50?img=3'),
      ReviewShowroom(nama: 'Dewi Lestari', rating: 4, komentar: 'Tempatnya bersih dan rapi...', tanggal: '5 Jun 2025', avatarUrl: 'https://i.pravatar.cc/50?img=9'),
      ReviewShowroom(nama: 'Rizky Fahmi', rating: 5, komentar: 'Udah ke-3 kalinya beli motor disini...', tanggal: '1 Jun 2025', avatarUrl: 'https://i.pravatar.cc/50?img=7'),
    ]),
    Showroom(id: '2', nama: 'Showroom Berkah Motor', alamat: 'Jl. Merdeka No. 45, Jakarta Pusat', kota: 'Jakarta', rating: 4.5, jumlahReview: 89, stokMotor: 24, telepon: '0813-9876-5432', jamBuka: 'Senin – Sabtu, 09.00 – 18.00', isVerified: true, reviews: []),
    Showroom(id: '3', nama: 'Showroom Garuda Motor', alamat: 'Jl. Asia Afrika No. 120, Bandung', kota: 'Bandung', rating: 4.9, jumlahReview: 156, stokMotor: 41, telepon: '0821-5555-8888', jamBuka: 'Senin – Minggu, 08.00 – 20.00', isVerified: true, reviews: []),
  ];

  List<Showroom> _showrooms = [];
  bool _isFromApi = false;

  Showroom? _fromJson(Map<String, dynamic> json) {
    try {
      return Showroom(
        id: json['id'].toString(),
        nama: json['name'] ?? '',
        alamat: json['address'] ?? '',
        kota: json['city'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        jumlahReview: json['review_count'] ?? 0,
        stokMotor: json['stock_count'] ?? json['motors_count'] ?? 0,
        telepon: json['phone'] ?? '',
        jamBuka: json['operating_hours'] ?? '',
        isVerified: json['is_verified'] ?? false,
        reviews: [],
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<Showroom>> getShowrooms() async {
    if (_showrooms.isEmpty) {
      await _fetchFromApi();
    }
    return _isFromApi ? _showrooms : _localShowrooms;
  }

  Future<void> _fetchFromApi() async {
    try {
      final res = await _api.get('/showrooms');
      if (res['success'] == true && res['data'] != null) {
        final list = res['data'] as List;
        _showrooms = list.map((e) => _fromJson(e as Map<String, dynamic>)).whereType<Showroom>().toList();
        _isFromApi = true;
      }
    } catch (_) {}
  }

  Showroom? getShowroomById(String id) {
    final source = _isFromApi ? _showrooms : _localShowrooms;
    try {
      return source.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Showroom? getShowroomByName(String nama) {
    final source = _isFromApi ? _showrooms : _localShowrooms;
    try {
      return source.firstWhere((s) => s.nama == nama);
    } catch (_) {
      return null;
    }
  }
}
