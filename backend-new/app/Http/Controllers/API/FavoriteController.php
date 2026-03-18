<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request)
    {
        $favorites = $request->user()->favorites()
            ->with('food.category')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $favorites,
        ]);
    }

    public function toggle(Request $request)
    {
        $request->validate([
            'food_id' => 'required|exists:foods,id',
        ]);

        $favorite = Favorite::where('user_id', $request->user()->id)
            ->where('food_id', $request->food_id)
            ->first();

        if ($favorite) {
            $favorite->delete();
            $message = 'Removed from favorites';
            $isFavorite = false;
        } else {
            Favorite::create([
                'user_id' => $request->user()->id,
                'food_id' => $request->food_id,
            ]);
            $message = 'Added to favorites';
            $isFavorite = true;
        }

        return response()->json([
            'success' => true,
            'message' => $message,
            'is_favorite' => $isFavorite,
        ]);
    }

    public function check(Request $request, $foodId)
    {
        $isFavorite = Favorite::where('user_id', $request->user()->id)
            ->where('food_id', $foodId)
            ->exists();

        return response()->json([
            'success' => true,
            'is_favorite' => $isFavorite,
        ]);
    }
}
