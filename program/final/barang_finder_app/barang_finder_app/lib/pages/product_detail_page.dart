// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import '../model/product.dart';
import 'dart:html' as html;

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama Produk: ${product.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Harga: Rp. ${product.harga}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'Lokasi: ${product.location}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'Detail Produk: ${product.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              if (product.imagePath != null)
                Image.network(
                  Uri.parse(product.imagePath!).toString(),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              if (product.fotoBarang != null)
                Image.network(
                  Uri.parse(product.fotoBarang!).toString(),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 20),
              // Tampilkan gambar toko jika tersedia
              if (product.storeImagePath != null)
                IconButton(
                  icon: Image.network(
                    Uri.parse(product.storeImagePath).toString(),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    _openGoogleMaps(product.location);
                  },
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _openGoogleMaps(product.location);
                },
                icon: const Icon(Icons.store),
                label: const Text('Toko'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuka Google Maps
  void _openGoogleMaps(String location) {
    final url = 'https://www.google.com/maps/place/$location';
    html.window.open(url, 'Google Maps');
  }
}
