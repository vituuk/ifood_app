<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class FoodSeeder extends Seeder
{
    public function run(): void
    {
        $foods = [
            // Burgers
            ['category_id' => 2, 'name' => 'Beef Burger', 'slug' => 'beef-burger', 'description' => 'Grilled beef patty with cheese and lettuce', 'price' => 8.5, 'rating' => 4.5, 'reviews' => 18, 'prep_time' => 15, 'calories' => 720, 'protein' => 28, 'carbs' => 46, 'fat' => 34],
            ['category_id' => 2, 'name' => 'Chicken Burger', 'slug' => 'chicken-burger', 'description' => 'Crispy chicken with mayo and pickles', 'price' => 7.9, 'rating' => 4.4, 'reviews' => 15, 'prep_time' => 14, 'calories' => 680, 'protein' => 24, 'carbs' => 42, 'fat' => 30],
            ['category_id' => 2, 'name' => 'Double Cheese Burger', 'slug' => 'double-cheese-burger', 'description' => 'Double patty burger for big appetite', 'price' => 10.2, 'rating' => 4.8, 'reviews' => 26, 'prep_time' => 18, 'calories' => 890, 'protein' => 38, 'carbs' => 48, 'fat' => 49],
            
            // Pizza
            ['category_id' => 1, 'name' => 'Margherita Pizza', 'slug' => 'margherita-pizza', 'description' => 'Classic tomato, mozzarella and basil', 'price' => 11, 'rating' => 4.6, 'reviews' => 31, 'prep_time' => 20, 'calories' => 790, 'protein' => 26, 'carbs' => 88, 'fat' => 29],
            ['category_id' => 1, 'name' => 'Pepperoni Pizza', 'slug' => 'pepperoni-pizza', 'description' => 'Pepperoni slices and mozzarella cheese', 'price' => 12.5, 'rating' => 4.7, 'reviews' => 40, 'prep_time' => 22, 'calories' => 860, 'protein' => 30, 'carbs' => 92, 'fat' => 35],
            ['category_id' => 1, 'name' => 'BBQ Chicken Pizza', 'slug' => 'bbq-chicken-pizza', 'description' => 'BBQ sauce, chicken and onion', 'price' => 13.2, 'rating' => 4.5, 'reviews' => 21, 'prep_time' => 24, 'calories' => 840, 'protein' => 33, 'carbs' => 90, 'fat' => 31],
            
            // Drinks
            ['category_id' => 7, 'name' => 'Iced Latte', 'slug' => 'iced-latte', 'description' => 'Cold espresso with milk', 'price' => 3.8, 'rating' => 4.3, 'reviews' => 11, 'prep_time' => 5, 'calories' => 150, 'protein' => 6, 'carbs' => 18, 'fat' => 5],
            ['category_id' => 7, 'name' => 'Orange Juice', 'slug' => 'orange-juice', 'description' => 'Fresh orange juice', 'price' => 2.9, 'rating' => 4.2, 'reviews' => 8, 'prep_time' => 4, 'calories' => 120, 'protein' => 2, 'carbs' => 26, 'fat' => 0],
            ['category_id' => 7, 'name' => 'Chocolate Milkshake', 'slug' => 'chocolate-milkshake', 'description' => 'Creamy chocolate shake', 'price' => 4.4, 'rating' => 4.6, 'reviews' => 19, 'prep_time' => 6, 'calories' => 330, 'protein' => 8, 'carbs' => 42, 'fat' => 12],
            
            // Desserts
            ['category_id' => 6, 'name' => 'Chocolate Cake', 'slug' => 'chocolate-cake', 'description' => 'Rich chocolate layered cake', 'price' => 4.7, 'rating' => 4.9, 'reviews' => 27, 'prep_time' => 7, 'calories' => 410, 'protein' => 5, 'carbs' => 52, 'fat' => 18],
            ['category_id' => 6, 'name' => 'Cheesecake', 'slug' => 'cheesecake', 'description' => 'Creamy cheesecake slice', 'price' => 4.9, 'rating' => 4.7, 'reviews' => 20, 'prep_time' => 7, 'calories' => 390, 'protein' => 6, 'carbs' => 36, 'fat' => 22],
            ['category_id' => 6, 'name' => 'Vanilla Donut', 'slug' => 'vanilla-donut', 'description' => 'Soft donut with vanilla glaze', 'price' => 2.3, 'rating' => 4.1, 'reviews' => 9, 'prep_time' => 4, 'calories' => 260, 'protein' => 3, 'carbs' => 31, 'fat' => 12],
        ];

        foreach ($foods as $food) {
            DB::table('foods')->insert([
                'category_id' => $food['category_id'],
                'name' => $food['name'],
                'slug' => $food['slug'],
                'description' => $food['description'],
                'price' => $food['price'],
                'image' => 'https://via.placeholder.com/300?text=' . urlencode($food['name']),
                'rating' => $food['rating'],
                'reviews' => $food['reviews'],
                'prep_time' => $food['prep_time'],
                'calories' => $food['calories'],
                'protein' => $food['protein'],
                'carbs' => $food['carbs'],
                'fat' => $food['fat'],
                'is_available' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
