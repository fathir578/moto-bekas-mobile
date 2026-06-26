import 'package:flutter/material.dart';
import '../models/motor_model.dart';
import '../services/motor_service.dart';
import '../services/showroom_service.dart';

class MotorProvider extends ChangeNotifier {
  final MotorService _motorService = MotorService();
  final ShowroomService _showroomService = ShowroomService();

  int _selectedKategori = 0;
  int get selectedKategori => _selectedKategori;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showroomsLoading = false;
  bool get showroomsLoading => _showroomsLoading;

  String? _error;
  String? get error => _error;

  final List<String> kategori = ['Semua', 'Matic', 'Manual', 'Sport', 'Trail', 'Bebek'];
  List<Motor> _filtered = [];
  List<Showroom> _showrooms = [];

  List<Motor> get filteredMotors => _filtered;
  List<Showroom> get showrooms => _showrooms;

  Future<void> loadMotors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ktg = kategori[_selectedKategori];
      _filtered = await _motorService.getMotors(kategori: ktg, search: _searchQuery);
    } catch (e) {
      _error = 'Gagal memuat data';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadShowrooms() async {
    _showroomsLoading = true;
    notifyListeners();

    try {
      _showrooms = await _showroomService.getShowrooms();
    } catch (_) {}

    _showroomsLoading = false;
    notifyListeners();
  }

  void setKategori(int index) {
    _selectedKategori = index;
    loadMotors();
  }

  void setSearch(String query) {
    _searchQuery = query;
    loadMotors();
  }

  void toggleFavorit(String id) {
    _motorService.toggleFavorit(id);
    notifyListeners();
  }

  Motor? getMotorById(String id) => _motorService.getMotorById(id);
  List<Motor> getMotorsByShowroom(String nama) => _motorService.getMotorsByShowroom(nama);
  Showroom? getShowroomById(String id) => _showroomService.getShowroomById(id);
  Showroom? getShowroomByName(String nama) => _showroomService.getShowroomByName(nama);
}
