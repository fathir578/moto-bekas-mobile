<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\MotorController;
use App\Http\Controllers\Api\ShowroomController;
use App\Http\Controllers\Api\TransactionController;
use Illuminate\Support\Facades\Route;

// Public routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

Route::get('/motors', [MotorController::class, 'index']);
Route::get('/motors/{id}', [MotorController::class, 'show']);
Route::get('/motors/featured/all', [MotorController::class, 'featured']);

Route::get('/showrooms', [ShowroomController::class, 'index']);
Route::get('/showrooms/{id}', [ShowroomController::class, 'show']);
Route::get('/showrooms/{id}/motors', [ShowroomController::class, 'motors']);
Route::get('/showrooms/{id}/reviews', [ShowroomController::class, 'reviews']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);

    Route::get('/favorites', [FavoriteController::class, 'index']);
    Route::post('/favorites', [FavoriteController::class, 'store']);
    Route::delete('/favorites/{motorId}', [FavoriteController::class, 'destroy']);

    Route::get('/transactions', [TransactionController::class, 'index']);
    Route::post('/transactions', [TransactionController::class, 'store']);
    Route::patch('/transactions/{id}', [TransactionController::class, 'update']);

    Route::get('/dashboard/stats', [DashboardController::class, 'stats']);
    Route::get('/dashboard/motors', [DashboardController::class, 'motors']);
    Route::post('/dashboard/motors', [DashboardController::class, 'storeMotor']);
    Route::put('/dashboard/motors/{id}', [DashboardController::class, 'updateMotor']);
    Route::delete('/dashboard/motors/{id}', [DashboardController::class, 'destroyMotor']);
    Route::get('/dashboard/transactions', [DashboardController::class, 'transactions']);
});
