<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('users')->insert([
            [
                'name' => 'Admin User',
                'email' => 'admin@foodapp.com',
                'password' => Hash::make('password'),
                'phone' => '+1234567890',
                'avatar' => 'https://via.placeholder.com/150?text=Admin',
                'role' => 'admin',
                'status' => 'active',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Adnan',
                'email' => 'user@foodapp.com',
                'password' => Hash::make('password'),
                'phone' => '+1234567891',
                'avatar' => 'https://via.placeholder.com/150?text=Adnan',
                'role' => 'user',
                'status' => 'active',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
