import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../auth/auth_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  int _tabIdx = 0;
  int get tabIdx => _tabIdx;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _stats = {};
  Map<String, dynamic> get stats => _stats;

  List<Map<String, dynamic>> _motorList = [];
  List<Map<String, dynamic>> get motorList => _motorList;

  List<Map<String, dynamic>> _transaksi = [];
  List<Map<String, dynamic>> get transaksi => _transaksi;

  final List<Map<String, dynamic>> _localMotors = [
    {'nama': 'Honda Vario 160', 'harga': 18500000, 'status': 'Tersedia', 'tahun': 2022, 'tipe': 'Matic', 'img': 'https://picsum.photos/seed/vario/200/140'},
    {'nama': 'Honda CB150R', 'harga': 19800000, 'status': 'Terjual', 'tahun': 2021, 'tipe': 'Sport', 'img': 'https://picsum.photos/seed/cb150r/200/140'},
    {'nama': 'Yamaha Aerox 155', 'harga': 21000000, 'status': 'Tersedia', 'tahun': 2022, 'tipe': 'Matic', 'img': 'https://picsum.photos/seed/aerox/200/140'},
    {'nama': 'Kawasaki KLX 150', 'harga': 26000000, 'status': 'Diproses', 'tahun': 2020, 'tipe': 'Trail', 'img': 'https://picsum.photos/seed/klx/200/140'},
  ];

  final List<Map<String, dynamic>> _localTransaksi = [
    {'nama': 'Andi Pratama', 'motor': 'Honda Vario 160', 'harga': 18500000, 'status': 'Selesai', 'tanggal': '20 Jun 2025', 'avatarUrl': 'https://i.pravatar.cc/50?img=1'},
    {'nama': 'Siti Rahayu', 'motor': 'Kawasaki KLX 150', 'harga': 26000000, 'status': 'Diproses', 'tanggal': '22 Jun 2025', 'avatarUrl': 'https://i.pravatar.cc/50?img=5'},
    {'nama': 'Budi Santoso', 'motor': 'Honda CB150R', 'harga': 19800000, 'status': 'Selesai', 'tanggal': '18 Jun 2025', 'avatarUrl': 'https://i.pravatar.cc/50?img=3'},
  ];

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    if (!AuthService().isLoggedIn) {
      _motorList = _localMotors;
      _transaksi = _localTransaksi;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final statsRes = await _api.get('/dashboard/stats');
      if (statsRes['success'] == true) {
        _stats = statsRes['data'] as Map<String, dynamic>;
      }

      final motorRes = await _api.get('/dashboard/motors');
      if (motorRes['success'] == true && motorRes['data'] != null) {
        _motorList = (motorRes['data'] as List).map((e) {
          final m = e as Map<String, dynamic>;
          return {
            'nama': m['name'],
            'harga': m['price'],
            'status': m['status'],
            'tahun': m['year'],
            'tipe': m['type'],
            'img': (m['image_urls'] is List && (m['image_urls'] as List).isNotEmpty)
                ? (m['image_urls'] as List).first.toString()
                : 'https://picsum.photos/seed/${m['id']}/200/140',
          };
        }).toList();
      }

      final transRes = await _api.get('/dashboard/transactions');
      if (transRes['success'] == true && transRes['data'] != null) {
        _transaksi = (transRes['data'] as List).map((e) {
          final t = e as Map<String, dynamic>;
          return {
            'nama': t['buyer'] is Map ? t['buyer']['name'] : 'Unknown',
            'motor': t['motor'] is Map ? t['motor']['name'] : '',
            'harga': t['price'],
            'status': t['status'],
            'tanggal': (t['created_at'] ?? '').toString().substring(0, 10),
            'avatarUrl': 'https://i.pravatar.cc/50?img=${t['id']}',
          };
        }).toList();
      }
    } catch (_) {
      _motorList = _localMotors;
      _transaksi = _localTransaksi;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setTab(int idx) {
    _tabIdx = idx;
    notifyListeners();
  }

  void addMotor(Map<String, dynamic> motor) {
    _motorList.insert(0, motor);
    notifyListeners();
  }

  void removeMotor(int index) {
    _motorList.removeAt(index);
    notifyListeners();
  }
}
