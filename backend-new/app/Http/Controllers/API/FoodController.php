<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Food;
use Illuminate\Http\Request;

class FoodController extends Controller
{
    public function index(Request $request)
    {
        $query = Food::with('category')->where('is_available', true);

        // Filter by category
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Search
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'LIKE', "%{$search}%")
                  ->orWhere('description', 'LIKE', "%{$search}%");
            });
        }

        // Sort
        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        
        if ($sortBy === 'rating') {
            $query->orderBy('rating', $sortOrder);
        } elseif ($sortBy === 'price') {
            $query->orderBy('price', $sortOrder);
        } else {
            $query->orderBy('created_at', $sortOrder);
        }

        $foods = $query->paginate($request->get('per_page', 20));

        return response()->json([
            'success' => true,
            'data' => $foods,
        ]);
    }

    public function show($id)
    {
        $food = Food::with(['category', 'reviews.user'])->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $food,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'slug' => 'required|string|max:255|unique:foods',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'image' => 'required|string',
            'rating' => 'nullable|numeric|min:0|max:5',
            'reviews' => 'nullable|integer|min:0',
            'prep_time' => 'required|integer|min:0',
            'calories' => 'nullable|integer|min:0',
            'protein' => 'nullable|numeric|min:0',
            'carbs' => 'nullable|numeric|min:0',
            'fat' => 'nullable|numeric|min:0',
            'is_available' => 'nullable|boolean',
        ]);

        $food = Food::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Food created successfully',
            'data' => $food,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $food = Food::findOrFail($id);

        $validated = $request->validate([
            'category_id' => 'sometimes|exists:categories,id',
            'name' => 'sometimes|string|max:255',
            'slug' => 'sometimes|string|max:255|unique:foods,slug,' . $id,
            'description' => 'sometimes|string',
            'price' => 'sometimes|numeric|min:0',
            'image' => 'sometimes|string',
            'rating' => 'nullable|numeric|min:0|max:5',
            'reviews' => 'nullable|integer|min:0',
            'prep_time' => 'sometimes|integer|min:0',
            'calories' => 'nullable|integer|min:0',
            'protein' => 'nullable|numeric|min:0',
            'carbs' => 'nullable|numeric|min:0',
            'fat' => 'nullable|numeric|min:0',
            'is_available' => 'nullable|boolean',
        ]);

        $food->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Food updated successfully',
            'data' => $food,
        ]);
    }


    public function reviews($id)
    {
        $food = Food::with(['reviews.user'])->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $food->reviews,
        ]);
    }

    public function similar($id)
    {
        $food = Food::findOrFail($id);
        
        $similarFoods = Food::where('category_id', $food->category_id)
            ->where('id', '!=', $id)
            ->where('is_available', true)
            ->limit(10)
            ->get();

        return response()->json([
            'success' => true,
            'data' => $similarFoods,
        ]);
    }
}
