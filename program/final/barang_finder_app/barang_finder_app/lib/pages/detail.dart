// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:barang_finder_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatelessWidget {
  final Product product;

  const Detail({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName ?? 'Product Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${product.description ?? 'No description'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Price: ${product.harga != null ? 'Rp.${product.harga!.toStringAsFixed(2)}' : 'Price not available'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                // Buka link Google Maps saat lokasi ditekan
                if (product.location != null && product.location!.isNotEmpty) {
                  // Dengan package url_launcher, pastikan Anda sudah menambahkannya pada file pubspec.yaml
                  // Tambahkan dependency: url_launcher: ^6.0.6 pada bagian dependencies
                  // Kemudian jalankan flutter pub get di terminal
                  launch(product.location!);
                }
              },
              child: Text(
                'Location: ${product.location ?? 'Location not available'}',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            product.imagePath != null
                ? Image.network(
                    product.imagePath!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(), // Tampilkan gambar hanya jika imagePath tidak null
          ],
        ),
      ),
    );
  }
}
