import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../auth/login_sheet.dart';

class DashboardShowroomScreen extends StatefulWidget {
  const DashboardShowroomScreen({super.key});

  @override
  State<DashboardShowroomScreen> createState() => _DashboardShowroomScreenState();
}

class _DashboardShowroomScreenState extends State<DashboardShowroomScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadData();
    });
  }

  bool _checkAuth(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const LoginSheet(),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final dashProv = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildStatCards()),
          SliverToBoxAdapter(child: _buildTabSection(dashProv)),
          SliverToBoxAdapter(child: dashProv.tabIdx == 0 ? _buildMotorSection(dashProv) : _buildTransaksiSection(dashProv)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_checkAuth(context)) {
            _showTambahMotorDialog(context);
          }
        },
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Motor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 110,
      pinned: true,
      backgroundColor: const Color(0xFF1565C0),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1565C0), Color(0xFF1976D2), Color(0xFF42A5F5)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Dashboard', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          Text('Showroom Maju Jaya', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Row(
                        children: [
                          _topBtn(Icons.notifications_outlined),
                          const SizedBox(width: 8),
                          _topBtn(Icons.settings_outlined),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBtn(IconData icon) => Container(
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
    child: Icon(icon, color: Colors.white, size: 20),
  );

  Widget _buildStatCards() {
    final stats = [
      {'label': 'Stok Motor', 'value': '32', 'icon': Icons.two_wheeler, 'color': const Color(0xFF1565C0), 'bg': const Color(0xFFE3F0FF)},
      {'label': 'Terjual', 'value': '18', 'icon': Icons.check_circle_outline, 'color': const Color(0xFF2E7D32), 'bg': const Color(0xFFE8F5E9)},
      {'label': 'Diproses', 'value': '3', 'icon': Icons.hourglass_empty, 'color': const Color(0xFFE65100), 'bg': const Color(0xFFFFF3E0)},
      {'label': 'Pendapatan', 'value': '1.2M', 'icon': Icons.account_balance_wallet_outlined, 'color': const Color(0xFF6A1B9A), 'bg': const Color(0xFFF3E5F5)},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.7,
        children: stats.map((s) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(color: s['bg'] as Color, borderRadius: BorderRadius.circular(10)),
                child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 22),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(s['value'] as String, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: s['color'] as Color)),
                  Text(s['label'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTabSection(DashboardProvider dashProv) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          _tabBtn('Stok Motor', 0, dashProv),
          const SizedBox(width: 10),
          _tabBtn('Transaksi', 1, dashProv),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, int idx, DashboardProvider dashProv) => GestureDetector(
    onTap: () => dashProv.setTab(idx),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(
        color: dashProv.tabIdx == idx ? const Color(0xFF1565C0) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)],
      ),
      child: Text(label, style: TextStyle(color: dashProv.tabIdx == idx ? Colors.white : Colors.grey, fontWeight: FontWeight.w600, fontSize: 13)),
    ),
  );

  Widget _buildMotorSection(DashboardProvider dashProv) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        children: dashProv.motorList.asMap().entries.map((entry) {
          final i = entry.key;
          final m = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                  child: Image.network(m['img'] as String, width: 100, height: 84, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 100, height: 84, color: const Color(0xFFE3F0FF), child: const Icon(Icons.two_wheeler, color: Color(0xFF1565C0), size: 32))),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(m['nama'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E)), overflow: TextOverflow.ellipsis)),
                            _statusBadge(m['status'] as String),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text('${m['tahun']} • ${m['tipe']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rp ${((m['harga'] as int) / 1000000).toStringAsFixed(1)}jt', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1565C0))),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF1565C0)),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => dashProv.removeMotor(i),
                                  child: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg, txt;
    switch (status) {
      case 'Tersedia':
        bg = const Color(0xFFE8F5E9); txt = const Color(0xFF2E7D32); break;
      case 'Terjual':
        bg = const Color(0xFFE3F0FF); txt = const Color(0xFF1565C0); break;
      default:
        bg = const Color(0xFFFFF3E0); txt = const Color(0xFFE65100);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(status, style: TextStyle(color: txt, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildTransaksiSection(DashboardProvider dashProv) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        children: dashProv.transaksi.map((t) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(t['avatarUrl'] as String), radius: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t['nama'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
                        _statusBadge(t['status'] as String),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(t['motor'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rp ${((t['harga'] as int) / 1000000).toStringAsFixed(1)}jt', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1565C0))),
                        Text(t['tanggal'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  void _showTambahMotorDialog(BuildContext context) {
    final nameCtl = TextEditingController();
    final tahunCtl = TextEditingController();
    final kmCtl = TextEditingController();
    final hargaCtl = TextEditingController();
    final warnaCtl = TextEditingController();
    final deskripsiCtl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text('Tambah Motor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
            ),
            const Divider(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _inputField('Nama Motor', 'Contoh: Honda Vario 160', controller: nameCtl),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _inputField('Tahun', 'Contoh: 2022', controller: tahunCtl)),
                      const SizedBox(width: 12),
                      Expanded(child: _inputField('Kilometer', 'Contoh: 12000', controller: kmCtl)),
                    ]),
                    const SizedBox(height: 14),
                    _inputField('Harga (Rp)', 'Contoh: 18500000', controller: hargaCtl),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _inputField('Warna', 'Contoh: Putih', controller: warnaCtl)),
                      const SizedBox(width: 12),
                      Expanded(child: _dropdownField('Tipe', ['Matic', 'Manual', 'Sport', 'Trail', 'Bebek'])),
                    ]),
                    const SizedBox(height: 14),
                    _inputField('Deskripsi Kondisi', 'Deskripsikan kondisi motor...', controller: deskripsiCtl, maxLines: 3),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE0E0E0))),
                      child: Column(
                        children: const [
                          Icon(Icons.camera_alt_outlined, color: Color(0xFF1565C0), size: 30),
                          SizedBox(height: 8),
                          Text('Tambah Foto Motor', style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Min. 3 foto, maks. 10 foto', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<DashboardProvider>().addMotor({
                            'nama': nameCtl.text.isNotEmpty ? nameCtl.text : 'Motor Baru',
                            'harga': int.tryParse(hargaCtl.text) ?? 0,
                            'status': 'Tersedia',
                            'tahun': int.tryParse(tahunCtl.text) ?? 2024,
                            'tipe': 'Matic',
                            'img': 'https://picsum.photos/seed/new/200/140',
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Motor berhasil ditambahkan!'), backgroundColor: Color(0xFF2E7D32)),
                          );
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: const Text('Simpan & Publikasikan'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint, {TextEditingController? controller, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: items.first,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: (_) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
