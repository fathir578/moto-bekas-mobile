<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Motor;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function stats(Request $request): JsonResponse
    {
        $showroom = $request->user()->showroom;

        if (!$showroom) {
            return response()->json([
                'success' => false,
                'message' => 'Hanya showroom yang bisa mengakses dashboard',
            ], 403);
        }

        $totalMotors = $showroom->motors()->count();
        $sold = $showroom->motors()->where('status', 'Terjual')->count();
        $processed = $showroom->motors()->where('status', 'Diproses')->count();
        $revenue = $showroom->transactions()
            ->where('status', 'Selesai')
            ->sum('price');

        return response()->json([
            'success' => true,
            'data' => [
                'stock_count' => $totalMotors,
                'sold_count' => $sold,
                'processed_count' => $processed,
                'revenue' => $revenue,
            ],
        ]);
    }

    public function motors(Request $request): JsonResponse
    {
        $showroom = $request->user()->showroom;

        if (!$showroom) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $motors = $showroom->motors()->latest()->paginate(20);

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

    public function storeMotor(Request $request): JsonResponse
    {
        $showroom = $request->user()->showroom;

        if (!$showroom) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'brand' => 'required|string|max:255',
            'type' => 'required|in:Matic,Manual,Sport,Trail,Bebek',
            'year' => 'required|integer|min:2000|max:2030',
            'price' => 'required|integer|min:0',
            'kilometer' => 'required|integer|min:0',
            'color' => 'required|string',
            'condition' => 'required|string',
            'description' => 'nullable|string',
            'location' => 'required|string',
            'image_urls' => 'nullable|array',
        ]);

        $motor = $showroom->motors()->create($validated);

        $showroom->increment('stock_count');

        return response()->json([
            'success' => true,
            'data' => $motor,
            'message' => 'Motor berhasil ditambahkan',
        ], 201);
    }

    public function updateMotor(Request $request, $id): JsonResponse
    {
        $showroom = $request->user()->showroom;

        if (!$showroom) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $motor = $showroom->motors()->findOrFail($id);

        $validated = $request->validate([
            'name' => 'string|max:255',
            'brand' => 'string|max:255',
            'type' => 'in:Matic,Manual,Sport,Trail,Bebek',
            'year' => 'integer|min:2000|max:2030',
            'price' => 'integer|min:0',
            'kilometer' => 'integer|min:0',
            'color' => 'string',
            'condition' => 'string',
            'description' => 'nullable|string',
            'status' => 'in:Tersedia,Terjual,Diproses',
        ]);

        $motor->update($validated);

        return response()->json([
            'success' => true,
            'data' => $motor,
            'message' => 'Motor berhasil diperbarui',
        ]);
    }

    public function destroyMotor(Request $request, $id): JsonResponse
    {
        $showroom = $request->user()->showroom;

        if (!$showroom) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $motor = $showroom->motors()->findOrFail($id);
        $motor->delete();

        $showroom->decrement('stock_count');

        return response()->json([
            'success' => true,
            'message' => 'Motor berhasil dihapus',
        ]);
    }

    public function transactions(Request $request): JsonResponse
    {
        $showroom = $request->user()->showroom;

        if (!$showroom) {
            return response()->json(['success' => false, 'message' => 'Akses ditolak'], 403);
        }

        $transactions = $showroom->transactions()
            ->with(['motor', 'buyer'])
            ->latest()
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $transactions->items(),
            'meta' => [
                'current_page' => $transactions->currentPage(),
                'per_page' => $transactions->perPage(),
                'total' => $transactions->total(),
            ],
        ]);
    }
}
