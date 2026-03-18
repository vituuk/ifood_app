<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Message extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'message',
        'type',
        'is_user',
        'is_read',
    ];

    protected $casts = [
        'is_read' => 'boolean',
        'is_user' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
