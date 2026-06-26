import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (auth.isLoggedIn) _buildUserCard(auth),
          if (auth.isLoggedIn) const SizedBox(height: 16),
          _buildMenuCard(context, auth),
          const SizedBox(height: 24),
          if (auth.isLoggedIn) _buildLogoutButton(context, auth),
        ],
      ),
    );
  }

  Widget _buildUserCard(AuthProvider auth) {
    final u = auth.user;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F0FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person, color: Color(0xFF1565C0), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(u?['name'] ?? 'Pengguna', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                Text(u?['email'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: u?['role'] == 'showroom' ? const Color(0xFFE8F5E9) : const Color(0xFFE3F0FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    u?['role'] == 'showroom' ? 'Showroom' : 'Pembeli',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: u?['role'] == 'showroom' ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, AuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          _menuTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profil',
            subtitle: 'Ubah nama, email, atau password',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur Edit Profil segera hadir!')),
            ),
          ),
          if (auth.isLoggedIn) const Divider(height: 1, indent: 56),
          if (auth.isLoggedIn)
            _menuTile(
              context,
              icon: Icons.share_outlined,
              title: 'Bagikan Aplikasi',
              subtitle: 'Kasih tau temen tentang MotoBekas',
              onTap: () {
                Share.share('Yuk beli motor bekas terpercaya di MotoBekas! Cek aja langsung.');
              },
            ),
          const Divider(height: 1, indent: 56),
          _menuTile(
            context,
            icon: Icons.info_outline,
            title: 'Tentang',
            subtitle: 'Versi 1.0.0',
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: const Color(0xFFE3F0FF), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF1565C0), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _confirmLogout(context, auth),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFC62828),
          side: const BorderSide(color: Color(0xFFC62828)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Keluar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Yakin keluar?'),
        content: const Text('Kamu bakal tetep bisa lihat motor-motor di Beranda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
              Navigator.pop(context);
            },
            child: const Text('Keluar', style: TextStyle(color: Color(0xFFC62828))),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.two_wheeler, color: Color(0xFF1565C0), size: 28),
            SizedBox(width: 10),
            Text('MotoBekas', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Text(
          'Aplikasi jual beli motor bekas terpercaya.\n\n'
          'Temukan motor impianmu dari showroom terdaftar dengan harga terbaik.\n\n'
          'Versi 1.0.0',
          style: TextStyle(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
  }
}
