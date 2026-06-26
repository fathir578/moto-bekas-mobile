# MotoBekas

Aplikasi jual beli motor bekas. Pembeli dapat mencari dan membeli motor bekas dari showroom terdaftar. Showroom dapat mengelola stok motor dan melihat dashboard penjualan.

## Tech Stack

| Layer | Tech |
|-------|------|
| Frontend | Flutter 3.x (Dart) |
| Backend | Laravel 11.x (PHP) |
| Database | MySQL |
| Auth | Laravel Sanctum (token-based) |
| State Management | Provider |

## Project Structure

```
motobekas/
├── backend/              # Laravel API
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/Api/
│   │   │   │   ├── AuthController.php
│   │   │   │   ├── MotorController.php
│   │   │   │   ├── ShowroomController.php
│   │   │   │   ├── FavoriteController.php
│   │   │   │   ├── TransactionController.php
│   │   │   │   └── DashboardController.php
│   │   │   └── Kernel.php
│   │   └── Models/
│   │       ├── User.php
│   │       ├── Showroom.php
│   │       ├── Motor.php
│   │       ├── Review.php
│   │       ├── Favorite.php
│   │       └── Transaction.php
│   ├── config/
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   │       └── DatabaseSeeder.php
│   └── routes/
│       └── api.php
├── lib/                  # Flutter app
│   ├── auth/
│   │   ├── auth_service.dart
│   │   └── login_sheet.dart
│   ├── models/
│   │   └── motor_model.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── motor_provider.dart
│   │   └── dashboard_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── detail_motor_screen.dart
│   │   ├── profil_showroom_screen.dart
│   │   ├── dashboard_showroom_screen.dart
│   │   └── settings_screen.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── motor_service.dart
│   │   └── showroom_service.dart
│   └── widgets/
│       ├── motor_card.dart
│       └── kategori_chip.dart
├── docs/
│   ├── erd.md
│   ├── 01-product-brief.md
│   ├── 02-user-flows.md
│   ├── 03-database-schema.md
│   ├── 04-api-spec.md
│   ├── 05-ui-guidelines.md
│   ├── 06-task-backlog.md
│   ├── 07-acceptance-criteria.md
│   └── 08-sample-data.md
├── android/
├── ios/
├── pubspec.yaml
├── README.md
└── .gitignore
```

## Features

### User (Guest / Buyer / Showroom)

- **Guest Mode**: Buka aplikasi langsung lihat daftar motor, tanpa login. Login hanya saat mau beli atau jual.
- **Cari Motor**: Cari berdasarkan nama, merek, atau tipe. Filter kategori (matic, manual, sport, trail, bebek).
- **Detail Motor**: Lihat spesifikasi lengkap, harga, gambar. Tombol Beli dan Chat.
- **Bagikan Motor**: Share detail motor ke aplikasi lain.
- **Favorit**: Tandai motor favorit.
- **Showroom Profile**: Lihat profil showroom, rating, review, stok.

### Showroom (Role: showroom)

- **Dashboard**: Statistik total motor, terjual, transaksi diproses, total pendapatan.
- **Tambah Motor**: Tambah motor baru ke katalog.
- **Daftar Motor**: Lihat semua motor milik showroom.

### Auth Flow

- Login/Register via bottom sheet.
- Login: email + password.
- Register: nama + email + password + role (buyer/showroom).
- Token disimpan di SharedPreferences.
- Logout dari halaman Settings.

## API Endpoints

Base URL: `http://localhost:8000/api` (development)

### Auth
| Method | Path | Description |
|--------|------|-------------|
| POST | /auth/register | Register user baru |
| POST | /auth/login | Login user |
| POST | /auth/logout | Logout (hapus token) |
| GET | /auth/user | Get user yang login |

### Motor
| Method | Path | Description |
|--------|------|-------------|
| GET | /motors | List motor (filter: search, type, min_price, max_price, sort) |
| GET | /motors/{id} | Detail motor |
| POST | /motors | Tambah motor (showroom only) |
| PUT | /motors/{id} | Update motor |
| DELETE | /motors/{id} | Hapus motor |

### Showroom
| Method | Path | Description |
|--------|------|-------------|
| GET | /showrooms | List showroom |
| GET | /showrooms/{id} | Detail showroom + motors + reviews |
| GET | /showrooms/{id}/motors | Motor milik showroom tertentu |

### Favorite
| Method | Path | Description |
|--------|------|-------------|
| GET | /favorites | Favorit user login |
| POST | /favorites/{motor_id} | Tambah favorit |
| DELETE | /favorites/{motor_id} | Hapus favorit |

### Transaction
| Method | Path | Description |
|--------|------|-------------|
| GET | /transactions | Transaksi user login |
| POST | /transactions | Buat transaksi baru |
| PUT | /transactions/{id}/status | Update status |

### Dashboard (Showroom)
| Method | Path | Description |
|--------|------|-------------|
| GET | /dashboard/stats | Statistik dashboard showroom |

## Database

Database schema dan ERD lengkap ada di [docs/erd.md](docs/erd.md).

### Tables

- **users** — akun pengguna (buyer/showroom)
- **showrooms** — profil showroom
- **motors** — daftar motor yang dijual
- **favorites** — favorit user
- **reviews** — review untuk showroom
- **transactions** — transaksi pembelian

## Setup Development

### Prasyarat

- Flutter 3.x
- PHP 8.2+
- Composer
- MySQL

### Backend

```bash
cd backend
composer install
cp .env.example .env
# setup database di .env
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=0.0.0.0 --port=8000
```

### Frontend

```bash
# pastikan backend running
flutter pub get
flutter run
```

Edit `lib/services/api_service.dart` jika perlu mengganti base URL API.

### Test Accounts

| Email | Password | Role |
|-------|----------|------|
| budi@test.com | password | buyer |
| showroom@test.com | password | showroom |

## License

MIT
