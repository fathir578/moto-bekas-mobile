import 'package:flutter/material.dart';
import '../models/motor_model.dart';

class MotorCard extends StatelessWidget {
  final Motor motor;
  final VoidCallback onTap;
  final VoidCallback onFavoritTap;

  const MotorCard({
    super.key,
    required this.motor,
    required this.onTap,
    required this.onFavoritTap,
  });

  String _formatHarga(double harga) {
    if (harga >= 1000000) {
      return 'Rp ${(harga / 1000000).toStringAsFixed(1)}jt';
    }
    return 'Rp ${harga.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.network(
                    motor.gambarUrl,
                    height: 118,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 118,
                      color: const Color(0xFFE3F0FF),
                      child: const Center(child: Icon(Icons.two_wheeler, size: 48, color: Color(0xFF1565C0))),
                    ),
                  ),
                ),
                // Badge tipe
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(motor.tipe, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ),
                // Favorit
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavoritTap,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        motor.isFavorit ? Icons.favorite : Icons.favorite_outline,
                        color: motor.isFavorit ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(motor.nama, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${motor.tahun} • ${motor.warna}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(_formatHarga(motor.harga), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1565C0))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.speed, size: 11, color: Colors.grey),
                      const SizedBox(width: 3),
                      Text('${(motor.kilometer / 1000).toStringAsFixed(0)}rb km', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      const Spacer(),
                      const Icon(Icons.location_on, size: 11, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(motor.lokasi, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 11, color: Color(0xFFFFB300)),
                      const SizedBox(width: 2),
                      Text(motor.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(motor.showroom, style: const TextStyle(fontSize: 9.5, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
