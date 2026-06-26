<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Motor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MotorController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Motor::with('showroom')->where('status', 'Tersedia');

        if ($request->filled('search')) {
            $s = $request->search;
            $query->where(function ($q) use ($s) {
                $q->where('name', 'like', "%{$s}%")
                  ->orWhere('brand', 'like', "%{$s}%");
            });
        }

        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        $motors = $query->paginate(20);

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

    public function show($id): JsonResponse
    {
        $motor = Motor::with('showroom')->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $motor,
        ]);
    }

    public function featured(): JsonResponse
    {
        $motors = Motor::with('showroom')
            ->where('status', 'Tersedia')
            ->where('is_featured', true)
            ->take(6)
            ->get();

        return response()->json([
            'success' => true,
            'data' => $motors,
        ]);
    }
}
