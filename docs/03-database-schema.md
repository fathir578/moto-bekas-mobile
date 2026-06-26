# Database Schema — MotoBekas

## ERD Overview

```
users
├── id (PK)
├── name
├── email (unique)
├── password
├── role: enum(guest, buyer, showroom)
├── phone
├── avatar_url
├── created_at
└── updated_at

showrooms
├── id (PK)
├── user_id (FK → users)
├── name
├── address
├── city
├── phone
├── operating_hours
├── is_verified
├── rating
├── review_count
├── stock_count
├── created_at
└── updated_at

motors
├── id (PK)
├── showroom_id (FK → showrooms)
├── name
├── brand
├── type: enum(matic, manual, sport, trail, bebek)
├── year
├── price
├── kilometer
├── color
├── condition
├── description
├── location
├── status: enum(tersedia, terjual, diproses)
├── image_urls (JSON array)
├── is_featured
├── created_at
└── updated_at

favorites
├── id (PK)
├── user_id (FK → users)
├── motor_id (FK → motors)
├── created_at
└── (unique: user_id + motor_id)

reviews
├── id (PK)
├── showroom_id (FK → showrooms)
├── user_id (FK → users)
├── rating (1-5)
├── comment
├── created_at
└── updated_at

transactions
├── id (PK)
├── motor_id (FK → motors)
├── buyer_id (FK → users)
├── showroom_id (FK → showrooms)
├── status: enum(diproses, selesai, dibatalkan)
├── price
├── created_at
└── updated_at
```
