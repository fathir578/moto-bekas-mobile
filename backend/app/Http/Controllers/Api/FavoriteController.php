<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use App\Models\Motor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $favorites = $request->user()
            ->favorites()
            ->with('motor.showroom')
            ->latest()
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $favorites->items(),
            'meta' => [
                'current_page' => $favorites->currentPage(),
                'per_page' => $favorites->perPage(),
                'total' => $favorites->total(),
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'motor_id' => 'required|exists:motors,id',
        ]);

        $existing = Favorite::where('user_id', $request->user()->id)
            ->where('motor_id', $validated['motor_id'])
            ->first();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => 'Motor sudah ada di favorit',
            ], 409);
        }

        $favorite = Favorite::create([
            'user_id' => $request->user()->id,
            'motor_id' => $validated['motor_id'],
        ]);

        return response()->json([
            'success' => true,
            'data' => $favorite,
            'message' => 'Berhasil ditambahkan ke favorit',
        ], 201);
    }

    public function destroy(Request $request, $id): JsonResponse
    {
        $favorite = Favorite::where('user_id', $request->user()->id)
            ->where('motor_id', $id)
            ->firstOrFail();

        $favorite->delete();

        return response()->json([
            'success' => true,
            'message' => 'Dihapus dari favorit',
        ]);
    }
}
