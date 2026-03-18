<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OrderSeeder extends Seeder
{
    public function run(): void
    {
        $userId = 2; // Adnan user

        // Order 1 - Ongoing
        $orderId1 = DB::table('orders')->insertGetId([
            'user_id' => $userId,
            'order_number' => 'ORD-B4291',
            'total_amount' => 45.97,
            'status' => 'preparing',
            'payment_status' => 'paid',
            'delivery_address' => '123 Main St, Phnom Penh, Cambodia',
            'delivery_fee' => 2.00,
            'notes' => 'Please ring doorbell',
            'created_at' => now()->subHours(2),
            'updated_at' => now()->subHours(2),
        ]);

        DB::table('order_items')->insert([
            [
                'order_id' => $orderId1,
                'food_id' => 1,
                'food_name' => 'Margherita Pizza',
                'quantity' => 2,
                'price' => 12.99,
                'image_url' => 'https://via.placeholder.com/300?text=Margherita+Pizza',
                'created_at' => now()->subHours(2),
                'updated_at' => now()->subHours(2),
            ],
            [
                'order_id' => $orderId1,
                'food_id' => 3,
                'food_name' => 'Classic Burger',
                'quantity' => 1,
                'price' => 10.99,
                'image_url' => 'https://via.placeholder.com/300?text=Classic+Burger',
                'created_at' => now()->subHours(2),
                'updated_at' => now()->subHours(2),
            ],
        ]);

        // Order 2 - Completed
        $orderId2 = DB::table('orders')->insertGetId([
            'user_id' => $userId,
            'order_number' => 'ORD-B4290',
            'total_amount' => 33.98,
            'status' => 'delivered',
            'payment_status' => 'paid',
            'delivery_address' => '123 Main St, Phnom Penh, Cambodia',
            'delivery_fee' => 2.00,
            'created_at' => now()->subDays(2),
            'updated_at' => now()->subDays(2),
        ]);

        DB::table('order_items')->insert([
            [
                'order_id' => $orderId2,
                'food_id' => 5,
                'food_name' => 'California Roll',
                'quantity' => 1,
                'price' => 15.99,
                'image_url' => 'https://via.placeholder.com/300?text=California+Roll',
                'created_at' => now()->subDays(2),
                'updated_at' => now()->subDays(2),
            ],
            [
                'order_id' => $orderId2,
                'food_id' => 7,
                'food_name' => 'Spaghetti Carbonara',
                'quantity' => 1,
                'price' => 13.99,
                'image_url' => 'https://via.placeholder.com/300?text=Spaghetti+Carbonara',
                'created_at' => now()->subDays(2),
                'updated_at' => now()->subDays(2),
            ],
        ]);

        // Order 3 - Cancelled
        $orderId3 = DB::table('orders')->insertGetId([
            'user_id' => $userId,
            'order_number' => 'ORD-B4289',
            'total_amount' => 25.98,
            'status' => 'cancelled',
            'payment_status' => 'failed',
            'delivery_address' => '123 Main St, Phnom Penh, Cambodia',
            'delivery_fee' => 2.00,
            'notes' => 'Customer cancelled',
            'created_at' => now()->subDays(5),
            'updated_at' => now()->subDays(5),
        ]);

        DB::table('order_items')->insert([
            [
                'order_id' => $orderId3,
                'food_id' => 4,
                'food_name' => 'Cheese Burger',
                'quantity' => 2,
                'price' => 11.99,
                'image_url' => 'https://via.placeholder.com/300?text=Cheese+Burger',
                'created_at' => now()->subDays(5),
                'updated_at' => now()->subDays(5),
            ],
        ]);
    }
}
