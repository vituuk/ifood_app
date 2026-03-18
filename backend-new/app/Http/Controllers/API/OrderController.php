<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $query = $request->user()->orders()->with('items.food');

        // Filter by status
        if ($request->has('status')) {
            $status = $request->status;
            
            if ($status === 'ongoing') {
                $query->whereIn('status', ['pending', 'confirmed', 'preparing', 'delivering']);
            } elseif ($status === 'completed') {
                $query->where('status', 'delivered');
            } elseif ($status === 'draft') {
                $query->where('status', 'pending')->where('payment_status', 'pending');
            } else {
                $query->where('status', $status);
            }
        }

        $orders = $query->orderBy('created_at', 'desc')->get();

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }

    public function show(Request $request, $id)
    {
        $order = $request->user()->orders()
            ->with(['items.food', 'payment'])
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $order,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'delivery_address' => 'required|string',
            'delivery_fee' => 'required|numeric|min:0',
            'payment_method' => 'required|in:aba,acleda,credit_card,cash_on_delivery',
            'notes' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.food_id' => 'required|exists:foods,id',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.price' => 'required|numeric|min:0',
        ]);

        // Calculate total
        $subtotal = collect($request->items)->sum(function ($item) {
            return $item['price'] * $item['quantity'];
        });
        $total = $subtotal + $request->delivery_fee;

        // Create order
        $order = Order::create([
            'user_id' => $request->user()->id,
            'order_number' => 'ORD-' . strtoupper(Str::random(5)),
            'total_amount' => $total,
            'status' => 'pending',
            'payment_status' => 'pending',
            'delivery_address' => $request->delivery_address,
            'delivery_fee' => $request->delivery_fee,
            'notes' => $request->notes,
        ]);

        // Create order items
        foreach ($request->items as $item) {
            $food = \App\Models\Food::find($item['food_id']);
            
            OrderItem::create([
                'order_id' => $order->id,
                'food_id' => $food->id,
                'food_name' => $food->name,
                'quantity' => $item['quantity'],
                'price' => $item['price'],
                'image_url' => $food->image,
            ]);
        }

        // Create payment
        Payment::create([
            'order_id' => $order->id,
            'user_id' => $request->user()->id,
            'amount' => $total,
            'payment_method' => $request->payment_method,
            'status' => $request->payment_method === 'cash_on_delivery' ? 'pending' : 'completed',
            'transaction_id' => 'TXN-' . strtoupper(Str::random(10)),
        ]);

        // Update order status
        if ($request->payment_method !== 'cash_on_delivery') {
            $order->update([
                'payment_status' => 'paid',
                'status' => 'confirmed',
            ]);
        }

        // Clear cart
        $cart = $request->user()->cart;
        if ($cart) {
            $cart->items()->delete();
        }

        return response()->json([
            'success' => true,
            'message' => 'Order placed successfully',
            'data' => $order->load(['items.food', 'payment']),
        ], 201);
    }


    public function track(Request $request, $id)
    {
        $order = $request->user()->orders()->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => [
                'order_id' => $order->id,
                'order_number' => $order->order_number,
                'status' => $order->status,
                'payment_status' => $order->payment_status,
                'updated_at' => $order->updated_at,
            ],
        ]);
    }

    public function cancel(Request $request, $id)
    {
        $order = $request->user()->orders()->findOrFail($id);

        if (!in_array($order->status, ['pending', 'confirmed'])) {
            return response()->json([
                'success' => false,
                'message' => 'Cannot cancel order in current status',
            ], 400);
        }

        $order->update(['status' => 'cancelled']);

        return response()->json([
            'success' => true,
            'message' => 'Order cancelled successfully',
        ]);
    }
}
