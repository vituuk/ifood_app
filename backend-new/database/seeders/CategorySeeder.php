<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Pizza', 'description' => 'Delicious pizzas with various toppings'],
            ['name' => 'Burger', 'description' => 'Juicy burgers with fresh ingredients'],
            ['name' => 'Sushi', 'description' => 'Fresh sushi and Japanese cuisine'],
            ['name' => 'Pasta', 'description' => 'Italian pasta dishes'],
            ['name' => 'Salad', 'description' => 'Fresh and healthy salads'],
            ['name' => 'Dessert', 'description' => 'Sweet treats and desserts'],
            ['name' => 'Drinks', 'description' => 'Refreshing beverages'],
            ['name' => 'Snacks', 'description' => 'Quick bites and snacks'],
        ];

        foreach ($categories as $category) {
            DB::table('categories')->insert([
                'name' => $category['name'],
                'slug' => Str::slug($category['name']),
                'description' => $category['description'],
                'image' => 'https://via.placeholder.com/150?text=' . urlencode($category['name']),
                'status' => 'active',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
