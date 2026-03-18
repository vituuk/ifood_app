<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\Food;
use Illuminate\Http\Request;

class CartController extends Controller
{
    public function index(Request $request)
    {
        $cart = $request->user()->cart()->with('items.food')->first();

        if (!$cart) {
            $cart = Cart::create(['user_id' => $request->user()->id]);
        }

        $total = $cart->items->sum(function ($item) {
            return $item->price * $item->quantity;
        });

        return response()->json([
            'success' => true,
            'data' => [
                'cart' => $cart,
                'total' => $total,
                'item_count' => $cart->items->sum('quantity'),
            ],
        ]);
    }

    public function add(Request $request)
    {
        $request->validate([
            'food_id' => 'required|exists:foods,id',
            'quantity' => 'required|integer|min:1',
        ]);

        $food = Food::findOrFail($request->food_id);

        if (!$food->is_available) {
            return response()->json([
                'success' => false,
                'message' => 'This food is not available',
            ], 400);
        }

        $cart = $request->user()->cart;
        if (!$cart) {
            $cart = Cart::create(['user_id' => $request->user()->id]);
        }

        $cartItem = CartItem::where('cart_id', $cart->id)
            ->where('food_id', $food->id)
            ->first();

        if ($cartItem) {
            $cartItem->quantity += $request->quantity;
            $cartItem->save();
        } else {
            CartItem::create([
                'cart_id' => $cart->id,
                'food_id' => $food->id,
                'quantity' => $request->quantity,
                'price' => $food->price,
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Item added to cart',
        ]);
    }

    public function update(Request $request, $itemId)
    {
        $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $cartItem = CartItem::where('id', $itemId)
            ->whereHas('cart', function ($query) use ($request) {
                $query->where('user_id', $request->user()->id);
            })
            ->firstOrFail();

        $cartItem->quantity = $request->quantity;
        $cartItem->save();

        return response()->json([
            'success' => true,
            'message' => 'Cart updated',
        ]);
    }

    public function remove(Request $request, $itemId)
    {
        $cartItem = CartItem::where('id', $itemId)
            ->whereHas('cart', function ($query) use ($request) {
                $query->where('user_id', $request->user()->id);
            })
            ->firstOrFail();

        $cartItem->delete();

        return response()->json([
            'success' => true,
            'message' => 'Item removed from cart',
        ]);
    }

    public function clear(Request $request)
    {
        $cart = $request->user()->cart;
        if ($cart) {
            $cart->items()->delete();
        }

        return response()->json([
            'success' => true,
            'message' => 'Cart cleared',
        ]);
    }
}
