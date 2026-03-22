<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Http\Request;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     */
    protected function redirectTo(Request $request): ?string
    {
        // If the route is an API route, always return a JSON error instead of redirecting
        if ($request->is('api/*')) {
            abort(response()->json([
                'success' => false,
                'message' => 'Unauthenticated access. Please provide a valid token.'
            ], 401));
        }

        return $request->expectsJson() ? null : route('login');
    }
}
