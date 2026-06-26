<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Motor extends Model
{
    use HasFactory;

    protected $fillable = [
        'showroom_id', 'name', 'brand', 'type', 'year', 'price',
        'kilometer', 'color', 'condition', 'description', 'location',
        'status', 'image_urls', 'is_featured',
    ];

    protected function casts(): array
    {
        return [
            'year' => 'integer',
            'price' => 'integer',
            'kilometer' => 'integer',
            'image_urls' => 'array',
            'is_featured' => 'boolean',
        ];
    }

    public function showroom()
    {
        return $this->belongsTo(Showroom::class);
    }

    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }
}
