<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Showroom extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'name', 'address', 'city', 'phone', 'operating_hours',
        'is_verified', 'rating', 'review_count', 'stock_count',
    ];

    protected function casts(): array
    {
        return [
            'is_verified' => 'boolean',
            'rating' => 'float',
            'review_count' => 'integer',
            'stock_count' => 'integer',
        ];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function motors()
    {
        return $this->hasMany(Motor::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }
}
