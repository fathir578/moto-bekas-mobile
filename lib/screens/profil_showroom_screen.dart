import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/motor_model.dart';
import '../providers/motor_provider.dart';

class ProfilShowroomScreen extends StatefulWidget {
  const ProfilShowroomScreen({super.key});

  @override
  State<ProfilShowroomScreen> createState() => _ProfilShowroomScreenState();
}

class _ProfilShowroomScreenState extends State<ProfilShowroomScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MotorProvider>().loadShowrooms();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motorProv = context.watch<MotorProvider>();
    final showrooms = motorProv.showrooms;
    final showroom = showrooms.isNotEmpty ? showrooms.first : null;
    final motors = showroom != null ? motorProv.getMotorsByShowroom(showroom.nama) : <Motor>[];

    if (motorProv.showroomsLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Showroom')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (showroom == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Showroom')),
        body: const Center(child: Text('Tidak ada data showroom')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, inner) => [
          _buildAppBar(context),
          _buildProfilHeader(showroom),
          _buildTabBar(motors.length, showroom.jumlahReview),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMotorTab(motors),
            _buildReviewTab(showroom),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
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
      title: const Text('Profil Showroom'),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.share_outlined, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildProfilHeader(Showroom s) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.storefront, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(s.nama, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)))),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: Color(0xFF1565C0), size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 13, color: Colors.grey),
                          const SizedBox(width: 3),
                          Flexible(child: Text(s.kota, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _statBadge('${s.rating}', '⭐ Rating'),
                          const SizedBox(width: 10),
                          _statBadge('${s.jumlahReview}', 'Review'),
                          const SizedBox(width: 10),
                          _statBadge('${s.stokMotor}', 'Unit'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  _infoRow(Icons.access_time, s.jamBuka),
                  const SizedBox(height: 6),
                  _infoRow(Icons.phone, s.telepon),
                  const SizedBox(height: 6),
                  _infoRow(Icons.location_on, s.alamat),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Chat'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1565C0),
                      side: const BorderSide(color: Color(0xFF1565C0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Hubungi'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBadge(String value, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: const Color(0xFFE3F0FF), borderRadius: BorderRadius.circular(8)),
    child: Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1565C0))),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    ),
  );

  Widget _infoRow(IconData icon, String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 14, color: const Color(0xFF1565C0)),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF555566)))),
    ],
  );

  Widget _buildTabBar(int motorCount, int reviewCount) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1565C0),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1565C0),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: [
            Tab(text: 'Motor ($motorCount)'),
            Tab(text: 'Review ($reviewCount)'),
          ],
        ),
      ),
    );
  }

  Widget _buildMotorTab(List<Motor> motors) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: motors.length,
      itemBuilder: (ctx, i) {
        final m = motors[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                child: Image.network(m.gambarUrl, width: 110, height: 90, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 110, height: 90, color: const Color(0xFFE3F0FF), child: const Icon(Icons.two_wheeler, color: Color(0xFF1565C0), size: 36))),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.nama, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 4),
                      Text('${m.tahun} • ${m.warna} • ${m.tipe}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text('Rp ${(m.harga / 1000000).toStringAsFixed(1)}jt', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1565C0))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.speed, size: 12, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text('${(m.kilometer / 1000).toStringAsFixed(0)}rb km', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(5)),
                            child: Text(m.kondisi, style: const TextStyle(fontSize: 10, color: Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
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
      },
    );
  }

  Widget _buildReviewTab(Showroom s) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF1976D2)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(s.rating.toString(), style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.white)),
                  Row(children: List.generate(5, (i) => Icon(i < s.rating.floor() ? Icons.star : Icons.star_outline, color: const Color(0xFFFFD600), size: 16))),
                  const SizedBox(height: 4),
                  Text('${s.jumlahReview} ulasan', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: List.generate(5, (i) {
                    final star = 5 - i;
                    final pct = [0.72, 0.18, 0.06, 0.03, 0.01][i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('$star', style: const TextStyle(color: Colors.white, fontSize: 11)),
                          const Icon(Icons.star, color: Color(0xFFFFD600), size: 11),
                          const SizedBox(width: 6),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD600)),
                                minHeight: 7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        ...s.reviews.map((r) => _reviewCard(r)),
      ],
    );
  }

  Widget _reviewCard(ReviewShowroom r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(r.avatarUrl), radius: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.nama, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(i < r.rating.floor() ? Icons.star : Icons.star_outline, color: const Color(0xFFFFB300), size: 13)),
                        const SizedBox(width: 6),
                        Text(r.tanggal, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(r.komentar, style: const TextStyle(fontSize: 13, color: Color(0xFF555566), height: 1.5)),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}
