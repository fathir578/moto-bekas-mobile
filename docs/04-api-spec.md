# API Spec — MotoBekas

Base URL: `http://localhost:8000/api/v1`

## Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/register | Register user |
| POST | /auth/login | Login user |
| POST | /auth/logout | Logout (revoke token) |
| GET | /auth/me | Get current user |
| POST | /auth/refresh | Refresh JWT token |

## Motors
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /motors | List motors (search, filter, paginate) |
| GET | /motors/{id} | Detail motor |
| GET | /motors/featured | Motor unggulan |

## Showrooms
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /showrooms | List showrooms |
| GET | /showrooms/{id} | Detail showroom |
| GET | /showrooms/{id}/motors | Motor milik showroom |
| GET | /showrooms/{id}/reviews | Review showroom |

## Favorites (Auth required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /favorites | List favorit user |
| POST | /favorites | Tambah favorit |
| DELETE | /favorites/{id} | Hapus favorit |

## Transactions (Auth required)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /transactions | List transaksi (buyer/showroom) |
| POST | /transactions | Buat transaksi |
| PATCH | /transactions/{id} | Update status transaksi |

## Dashboard (Showroom only)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /dashboard/stats | Statistik showroom |
| GET | /dashboard/motors | Stok motor showroom |
| POST | /dashboard/motors | Tambah motor |
| PUT | /dashboard/motors/{id} | Edit motor |
| DELETE | /dashboard/motors/{id} | Hapus motor |
| GET | /dashboard/transactions | Transaksi showroom |

## Response Format
```json
{
  "success": true,
  "data": {},
  "message": "...",
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 100
  }
}
```
