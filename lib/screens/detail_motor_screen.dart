import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/motor_model.dart';
import '../providers/auth_provider.dart';
import '../auth/login_sheet.dart';
import 'profil_showroom_screen.dart';

class DetailMotorScreen extends StatefulWidget {
  final Motor motor;
  const DetailMotorScreen({super.key, required this.motor});

  @override
  State<DetailMotorScreen> createState() => _DetailMotorScreenState();
}

class _DetailMotorScreenState extends State<DetailMotorScreen> {
  late bool _isFavorit;

  String _formatHarga(double harga) {
    final formatted = harga.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  void initState() {
    super.initState();
    _isFavorit = widget.motor.isFavorit;
  }

  void _handleBeli() {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => LoginSheet(
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login berhasil! Silakan lanjutkan transaksi.'), backgroundColor: Color(0xFF2E7D32)),
            );
          },
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menghubungi showroom...'), backgroundColor: Color(0xFF1565C0)),
    );
  }

  void _handleShare(Motor m) {
    final text = '${m.nama} - ${_formatHarga(m.harga)}\n'
        'Tahun ${m.tahun} | ${m.kilometer} km | ${m.lokasi}\n'
        'Dijual oleh ${m.showroom}\n'
        'Cek di MotoBekas!';
    Share.share(text);
  }

  void _handleChat() {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => LoginSheet(
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login berhasil!'), backgroundColor: Color(0xFF2E7D32)),
            );
          },
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Membuka chat...'), backgroundColor: Color(0xFF1565C0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.motor;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context, m),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderInfo(m),
                    const SizedBox(height: 12),
                    _buildSpesifikasi(m),
                    const SizedBox(height: 12),
                    _buildDeskripsiKondisi(m),
                    const SizedBox(height: 12),
                    _buildShowroomCard(context, m),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Motor m) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: const Color(0xFF1565C0),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _isFavorit = !_isFavorit),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(_isFavorit ? Icons.favorite : Icons.favorite_outline, color: _isFavorit ? Colors.red[300] : Colors.white),
          ),
        ),
        GestureDetector(
          onTap: () => _handleShare(m),
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.share_outlined, color: Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              m.gambarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE3F0FF),
                child: const Center(child: Icon(Icons.two_wheeler, size: 80, color: Color(0xFF1565C0))),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black54, Colors.transparent]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(Motor m) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE3F0FF), borderRadius: BorderRadius.circular(6)),
                child: Text(m.tipe, style: const TextStyle(color: Color(0xFF1565C0), fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
                child: Text(m.kondisi, style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(m.nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 6),
          Text(_formatHarga(m.harga), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1565C0))),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(Icons.calendar_today, '${m.tahun}'),
              const SizedBox(width: 10),
              _infoChip(Icons.speed, '${(m.kilometer / 1000).toStringAsFixed(0)}rb km'),
              const SizedBox(width: 10),
              _infoChip(Icons.location_on, m.lokasi),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: Colors.grey),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
    ],
  );

  Widget _buildSpesifikasi(Motor m) {
    final speks = [
      ['Merek', m.merek],
      ['Tipe', m.tipe],
      ['Tahun', m.tahun.toString()],
      ['Warna', m.warna],
      ['Kilometer', '${m.kilometer.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (x) => '${x[1]}.')} km'],
      ['Kondisi', m.kondisi],
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Spesifikasi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 14),
          ...speks.asMap().entries.map((e) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.value[0], style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  Text(e.value[1], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                ],
              ),
              if (e.key < speks.length - 1)
                const Divider(height: 16, thickness: 0.5),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildDeskripsiKondisi(Motor m) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Deskripsi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 10),
          Text(
            '${m.nama} tahun ${m.tahun} kondisi ${m.kondisi.toLowerCase()}. Body mulus tanpa lecet berarti. Mesin halus, tidak ada bunyi aneh. Surat-surat lengkap, STNK dan BPKB asli. Pajak hidup. Siap pakai. Ban masih bagus. Cocok untuk harian.',
            style: const TextStyle(fontSize: 13, color: Color(0xFF555566), height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildShowroomCard(BuildContext context, Motor m) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dijual oleh', style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.storefront, color: Color(0xFF1565C0), size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(m.showroom, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: Color(0xFF1565C0), size: 15),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFB300), size: 14),
                        const SizedBox(width: 3),
                        Text('${m.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                        const SizedBox(width: 4),
                        const Text('• 48 review', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilShowroomScreen())),
                child: const Text('Lihat', style: TextStyle(color: Color(0xFF1565C0), fontSize: 13)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, -3))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _handleChat,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1565C0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1565C0), size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleBeli,
              child: const Text('Beli Sekarang'),
            ),
          ),
        ],
      ),
    );
  }
}
