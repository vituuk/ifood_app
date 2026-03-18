<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Review;
use App\Models\Food;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'food_id' => 'required|exists:foods,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        // Check if user already reviewed this food
        $existingReview = Review::where('user_id', $request->user()->id)
            ->where('food_id', $request->food_id)
            ->first();

        if ($existingReview) {
            return response()->json([
                'success' => false,
                'message' => 'You have already reviewed this food',
            ], 400);
        }

        $review = Review::create([
            'user_id' => $request->user()->id,
            'food_id' => $request->food_id,
            'rating' => $request->rating,
            'comment' => $request->comment,
        ]);

        // Update food rating
        $this->updateFoodRating($request->food_id);

        return response()->json([
            'success' => true,
            'message' => 'Review added successfully',
            'data' => $review->load('user'),
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $review = $request->user()->reviews()->findOrFail($id);

        $request->validate([
            'rating' => 'sometimes|required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        $review->update($request->all());

        // Update food rating
        $this->updateFoodRating($review->food_id);

        return response()->json([
            'success' => true,
            'message' => 'Review updated successfully',
            'data' => $review,
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $review = $request->user()->reviews()->findOrFail($id);
        $foodId = $review->food_id;
        $review->delete();

        // Update food rating
        $this->updateFoodRating($foodId);

        return response()->json([
            'success' => true,
            'message' => 'Review deleted successfully',
        ]);
    }

    private function updateFoodRating($foodId)
    {
        $food = Food::findOrFail($foodId);
        $reviews = Review::where('food_id', $foodId)->get();
        
        if ($reviews->count() > 0) {
            $avgRating = $reviews->avg('rating');
            $food->update([
                'rating' => round($avgRating, 2),
                'reviews' => $reviews->count(),
            ]);
        } else {
            $food->update([
                'rating' => 0,
                'reviews' => 0,
            ]);
        }
    }
}
