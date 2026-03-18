<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Message;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function index(Request $request)
    {
        $messages = $request->user()->messages()
            ->orderBy('created_at', 'desc')
            ->get();

        $unreadCount = $messages->where('is_read', false)->where('is_user', false)->count();

        return response()->json([
            'success' => true,
            'data' => [
                'messages' => $messages,
                'unread_count' => $unreadCount,
            ],
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'message' => 'required|string',
        ]);

        $message = $request->user()->messages()->create([
            'title' => 'Support Chat',
            'message' => $request->message,
            'type' => 'chat',
            'is_user' => true,
            'is_read' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Message sent',
            'data' => $message,
        ]);
    }

    public function markAsRead(Request $request, $id)
    {
        $message = $request->user()->messages()->findOrFail($id);
        $message->update(['is_read' => true]);

        return response()->json([
            'success' => true,
            'message' => 'Message marked as read',
        ]);
    }

    public function markAllAsRead(Request $request)
    {
        $request->user()->messages()
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json([
            'success' => true,
            'message' => 'All messages marked as read',
        ]);
    }

    public function delete(Request $request, $id)
    {
        $message = $request->user()->messages()->findOrFail($id);
        $message->delete();

        return response()->json([
            'success' => true,
            'message' => 'Message deleted successfully',
        ]);
    }
}
