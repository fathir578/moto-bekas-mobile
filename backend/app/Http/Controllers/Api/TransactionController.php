<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Motor;
use App\Models\Transaction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $query = Transaction::with(['motor', 'showroom', 'buyer']);

        if ($user->role === 'showroom') {
            $showroom = $user->showroom;
            $query->where('showroom_id', $showroom?->id);
        } else {
            $query->where('buyer_id', $user->id);
        }

        $transactions = $query->latest()->paginate(20);

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

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'motor_id' => 'required|exists:motors,id',
        ]);

        $motor = Motor::with('showroom')->findOrFail($validated['motor_id']);

        if ($motor->status !== 'Tersedia') {
            return response()->json([
                'success' => false,
                'message' => 'Motor sudah tidak tersedia',
            ], 400);
        }

        $transaction = Transaction::create([
            'motor_id' => $motor->id,
            'buyer_id' => $request->user()->id,
            'showroom_id' => $motor->showroom_id,
            'status' => 'Diproses',
            'price' => $motor->price,
        ]);

        $motor->update(['status' => 'Diproses']);

        return response()->json([
            'success' => true,
            'data' => $transaction,
            'message' => 'Transaksi berhasil dibuat',
        ], 201);
    }

    public function update(Request $request, $id): JsonResponse
    {
        $validated = $request->validate([
            'status' => 'required|in:Diproses,Selesai,Dibatalkan',
        ]);

        $transaction = Transaction::findOrFail($id);
        $transaction->update($validated);

        if ($validated['status'] === 'Selesai') {
            $transaction->motor->update(['status' => 'Terjual']);
        } elseif ($validated['status'] === 'Dibatalkan') {
            $transaction->motor->update(['status' => 'Tersedia']);
        }

        return response()->json([
            'success' => true,
            'data' => $transaction,
            'message' => 'Status transaksi diperbarui',
        ]);
    }
}
