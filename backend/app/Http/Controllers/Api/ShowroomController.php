<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Showroom;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ShowroomController extends Controller
{
    public function index(): JsonResponse
    {
        $showrooms = Showroom::withCount('motors')->get();

        return response()->json([
            'success' => true,
            'data' => $showrooms,
        ]);
    }

    public function show($id): JsonResponse
    {
        $showroom = Showroom::withCount('motors')->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $showroom,
        ]);
    }

    public function motors($id): JsonResponse
    {
        $showroom = Showroom::findOrFail($id);
        $motors = $showroom->motors()->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $motors->items(),
            'meta' => [
                'current_page' => $motors->currentPage(),
                'per_page' => $motors->perPage(),
                'total' => $motors->total(),
            ],
        ]);
    }

    public function reviews($id): JsonResponse
    {
        $showroom = Showroom::findOrFail($id);
        $reviews = $showroom->reviews()->with('user')->latest()->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $reviews->items(),
            'meta' => [
                'current_page' => $reviews->currentPage(),
                'per_page' => $reviews->perPage(),
                'total' => $reviews->total(),
            ],
        ]);
    }
}
