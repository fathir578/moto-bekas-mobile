<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('motors', function (Blueprint $table) {
            $table->id();
            $table->foreignId('showroom_id')->constrained()->onDelete('cascade');
            $table->string('name');
            $table->string('brand');
            $table->enum('type', ['Matic', 'Manual', 'Sport', 'Trail', 'Bebek']);
            $table->year('year');
            $table->integer('price');
            $table->integer('kilometer');
            $table->string('color');
            $table->string('condition');
            $table->text('description')->nullable();
            $table->string('location');
            $table->enum('status', ['Tersedia', 'Terjual', 'Diproses'])->default('Tersedia');
            $table->json('image_urls')->nullable();
            $table->boolean('is_featured')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('motors');
    }
};
