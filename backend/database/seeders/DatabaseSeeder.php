<?php

namespace Database\Seeders;

use App\Models\Favorite;
use App\Models\Motor;
use App\Models\Review;
use App\Models\Showroom;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Buyer
        $buyer = User::create([
            'name' => 'Budi Santoso',
            'email' => 'budi@test.com',
            'password' => bcrypt('password'),
            'role' => 'buyer',
            'phone' => '0812-3456-7890',
        ]);

        // Showroom users
        $userMaju = User::create([
            'name' => 'Showroom Maju Jaya',
            'email' => 'showroom@test.com',
            'password' => bcrypt('password'),
            'role' => 'showroom',
            'phone' => '0812-3456-7890',
        ]);

        $userBerkah = User::create([
            'name' => 'Showroom Berkah Motor',
            'email' => 'berkah@test.com',
            'password' => bcrypt('password'),
            'role' => 'showroom',
            'phone' => '0813-9876-5432',
        ]);

        $userGaruda = User::create([
            'name' => 'Showroom Garuda Motor',
            'email' => 'garuda@test.com',
            'password' => bcrypt('password'),
            'role' => 'showroom',
            'phone' => '0821-5555-8888',
        ]);

        // Showrooms
        $maju = Showroom::create([
            'user_id' => $userMaju->id,
            'name' => 'Showroom Maju Jaya',
            'address' => 'Jl. Raya Purwakarta No. 88, Purwakarta',
            'city' => 'Purwakarta',
            'phone' => '0812-3456-7890',
            'operating_hours' => 'Senin – Sabtu, 08.00 – 17.00',
            'is_verified' => true,
            'rating' => 4.8,
            'review_count' => 124,
            'stock_count' => 3,
        ]);

        $berkah = Showroom::create([
            'user_id' => $userBerkah->id,
            'name' => 'Showroom Berkah Motor',
            'address' => 'Jl. Merdeka No. 45, Jakarta Pusat',
            'city' => 'Jakarta',
            'phone' => '0813-9876-5432',
            'operating_hours' => 'Senin – Sabtu, 09.00 – 18.00',
            'is_verified' => true,
            'rating' => 4.5,
            'review_count' => 89,
            'stock_count' => 2,
        ]);

        $garuda = Showroom::create([
            'user_id' => $userGaruda->id,
            'name' => 'Showroom Garuda Motor',
            'address' => 'Jl. Asia Afrika No. 120, Bandung',
            'city' => 'Bandung',
            'phone' => '0821-5555-8888',
            'operating_hours' => 'Senin – Minggu, 08.00 – 20.00',
            'is_verified' => true,
            'rating' => 4.9,
            'review_count' => 156,
            'stock_count' => 2,
        ]);

        // Motors
        $vario = Motor::create([
            'showroom_id' => $maju->id,
            'name' => 'Honda Vario 160',
            'brand' => 'Honda',
            'type' => 'Matic',
            'year' => 2022,
            'price' => 18500000,
            'kilometer' => 12000,
            'color' => 'Putih',
            'condition' => 'Sangat Baik',
            'description' => 'Honda Vario 160 tahun 2022 kondisi sangat baik. Body mulus tanpa lecet berarti. Mesin halus, tidak ada bunyi aneh. Surat-surat lengkap, STNK dan BPKB asli. Pajak hidup. Siap pakai.',
            'location' => 'Bandung',
            'status' => 'Tersedia',
            'image_urls' => ['https://picsum.photos/seed/vario/400/280'],
            'is_featured' => true,
        ]);

        $nmax = Motor::create([
            'showroom_id' => $berkah->id,
            'name' => 'Yamaha NMAX 155',
            'brand' => 'Yamaha',
            'type' => 'Matic',
            'year' => 2021,
            'price' => 22000000,
            'kilometer' => 18500,
            'color' => 'Hitam',
            'condition' => 'Baik',
            'description' => 'Yamaha NMAX 155 tahun 2021 kondisi baik. Motor harian, ada sedikit baret di bodi. Mesin masih prima. Pajak hidup.',
            'location' => 'Jakarta',
            'status' => 'Tersedia',
            'image_urls' => ['https://picsum.photos/seed/nmax/400/280'],
            'is_featured' => true,
        ]);

        $klx = Motor::create([
            'showroom_id' => $garuda->id,
            'name' => 'Kawasaki KLX 150',
            'brand' => 'Kawasaki',
            'type' => 'Trail',
            'year' => 2020,
            'price' => 26000000,
            'kilometer' => 9800,
            'color' => 'Hijau',
            'condition' => 'Sangat Baik',
            'description' => 'Kawasaki KLX 150 tahun 2020 kondisi sangat baik. Jarang dipakai, masih seperti baru. Surat lengkap.',
            'location' => 'Bandung',
            'status' => 'Tersedia',
            'image_urls' => ['https://picsum.photos/seed/klx/400/280'],
            'is_featured' => true,
        ]);

        $cb150r = Motor::create([
            'showroom_id' => $maju->id,
            'name' => 'Honda CB150R',
            'brand' => 'Honda',
            'type' => 'Sport',
            'year' => 2021,
            'price' => 19800000,
            'kilometer' => 15200,
            'color' => 'Merah',
            'condition' => 'Baik',
            'description' => 'Honda CB150R tahun 2021 kondisi baik. Motor sport yang terawat. Ban masih tebal. Pajak hidup.',
            'location' => 'Depok',
            'status' => 'Tersedia',
            'image_urls' => ['https://picsum.photos/seed/cb150r/400/280'],
            'is_featured' => false,
        ]);

        $mio = Motor::create([
            'showroom_id' => $berkah->id,
            'name' => 'Yamaha Mio M3',
            'brand' => 'Yamaha',
            'type' => 'Matic',
            'year' => 2023,
            'price' => 13500000,
            'kilometer' => 5000,
            'color' => 'Biru',
            'condition' => 'Sangat Baik',
            'description' => 'Yamaha Mio M3 tahun 2023 sangat baru. Baru dipakai 5000km. Kondisi 99% seperti baru.',
            'location' => 'Bekasi',
            'status' => 'Tersedia',
            'image_urls' => ['https://picsum.photos/seed/miom3/400/280'],
            'is_featured' => false,
        ]);

        $gsx = Motor::create([
            'showroom_id' => $garuda->id,
            'name' => 'Suzuki GSX-R150',
            'brand' => 'Suzuki',
            'type' => 'Sport',
            'year' => 2020,
            'price' => 24500000,
            'kilometer' => 20000,
            'color' => 'Hitam-Biru',
            'condition' => 'Baik',
            'description' => 'Suzuki GSX-R150 tahun 2020 kondisi baik. Motor sport fairing mulus. Performa mesin masih terjaga.',
            'location' => 'Tangerang',
            'status' => 'Tersedia',
            'image_urls' => ['https://picsum.photos/seed/gsx/400/280'],
            'is_featured' => false,
        ]);

        // Reviews
        Review::create(['showroom_id' => $maju->id, 'user_id' => $buyer->id, 'rating' => 5, 'comment' => 'Pelayanan sangat ramah dan motor yang dijual kondisinya benar-benar sesuai deskripsi. Sangat puas!']);
        Review::create(['showroom_id' => $maju->id, 'user_id' => $buyer->id, 'rating' => 4, 'comment' => 'Proses beli cepat dan transparan. Harga sedikit di atas pasaran tapi kualitas terjamin.']);
        Review::create(['showroom_id' => $maju->id, 'user_id' => $buyer->id, 'rating' => 5, 'comment' => 'BPKB dan STNK langsung diurus showroom. Motor sudah di servis sebelum diserahkan. Recommended!']);
        Review::create(['showroom_id' => $maju->id, 'user_id' => $buyer->id, 'rating' => 4, 'comment' => 'Tempatnya bersih dan rapi, unit motornya lengkap. Staf nya juga informatif.']);
        Review::create(['showroom_id' => $maju->id, 'user_id' => $buyer->id, 'rating' => 5, 'comment' => 'Udah ke-3 kalinya beli motor disini. Selalu puas dengan layanan dan kondisi unitnya.']);
    }
}
