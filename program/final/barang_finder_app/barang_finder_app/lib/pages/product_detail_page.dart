import 'package:flutter/material.dart';
import '../model/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Padding(
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
              'Harga: Rp. ${product.price}',
              style: const TextStyle(fontSize: 16, color: Colors.orange),
            ),
            const SizedBox(height: 12),
            Text(
              'Lokasi: ${product.location}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Detail Produk: ${product.detail}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            // Tampilkan gambar produk jika tersedia
            product.imagePath != null
                ? Image.network(
                    Uri.parse(product.imagePath!).toString(),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            // Tampilkan gambar toko jika tersedia
            // ignore: unnecessary_null_comparison
            product.storeImagePath != null
                ? Image.network(
                    Uri.parse(product.storeImagePath).toString(),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika yang diperlukan
              },
              child: const Text('Tombol Lainnya'),
            ),
          ],
        ),
      ),
    );
  }
}
