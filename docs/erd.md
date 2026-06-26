# Entity Relationship Diagram — MotoBekas

## Database Structure

```mermaid
erDiagram
    users {
        bigint id PK
        string name
        string email UK
        string password
        string role
        string phone
        string avatar_url
        timestamp created_at
        timestamp updated_at
    }

    showrooms {
        bigint id PK
        bigint user_id FK
        string name
        text address
        string city
        string phone
        string operating_hours
        boolean is_verified
        decimal rating
        int review_count
        int stock_count
        timestamp created_at
        timestamp updated_at
    }

    motors {
        bigint id PK
        bigint showroom_id FK
        string name
        string brand
        string type
        int year
        decimal price
        int kilometer
        string color
        string condition
        text description
        string location
        string status
        json image_urls
        boolean is_featured
        timestamp created_at
        timestamp updated_at
    }

    favorites {
        bigint id PK
        bigint user_id FK
        bigint motor_id FK
        timestamp created_at
    }

    reviews {
        bigint id PK
        bigint showroom_id FK
        bigint user_id FK
        int rating
        text comment
        timestamp created_at
        timestamp updated_at
    }

    transactions {
        bigint id PK
        bigint motor_id FK
        bigint buyer_id FK
        bigint showroom_id FK
        string status
        decimal price
        timestamp created_at
        timestamp updated_at
    }

    users ||--o{ showrooms : "memiliki"
    users ||--o{ favorites : "menyukai"
    users ||--o{ reviews : "menulis"
    users ||--o{ transactions : "membeli"

    showrooms ||--o{ motors : "menjual"
    showrooms ||--o{ reviews : "memiliki"
    showrooms ||--o{ transactions : "memproses"

    motors ||--o{ favorites : "disukai"
    motors ||--o{ transactions : "ditransaksikan"
```

## Relationships

| Table | Related Table | Type | Description |
|-------|--------------|------|-------------|
| users.id | showrooms.user_id | One to Many | User memiliki banyak showroom |
| users.id | favorites.user_id | One to Many | User memiliki banyak favorite |
| users.id | reviews.user_id | One to Many | User menulis banyak review |
| users.id | transactions.buyer_id | One to Many | User membeli banyak motor |
| showrooms.id | motors.showroom_id | One to Many | Showroom menjual banyak motor |
| showrooms.id | reviews.showroom_id | One to Many | Showroom memiliki banyak review |
| showrooms.id | transactions.showroom_id | One to Many | Showroom memproses banyak transaksi |
| motors.id | favorites.motor_id | One to Many | Motor disukai banyak user |
| motors.id | transactions.motor_id | One to Many | Motor ditransaksikan |

## Constraints

- favorites: unique constraint on (user_id, motor_id) — user hanya bisa favorit satu kali per motor
- users.email: unique — tidak boleh ada email duplikat
- users.role: enum('buyer', 'showroom') — hanya dua role yang didukung
- motors.status: enum('tersedia', 'terjual', 'diproses')
- transactions.status: enum('diproses', 'selesai', 'dibatalkan')
