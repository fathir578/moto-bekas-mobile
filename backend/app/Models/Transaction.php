<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'motor_id', 'buyer_id', 'showroom_id', 'status', 'price',
    ];

    protected function casts(): array
    {
        return [
            'price' => 'integer',
        ];
    }

    public function motor()
    {
        return $this->belongsTo(Motor::class);
    }

    public function buyer()
    {
        return $this->belongsTo(User::class, 'buyer_id');
    }

    public function showroom()
    {
        return $this->belongsTo(Showroom::class);
    }
}
