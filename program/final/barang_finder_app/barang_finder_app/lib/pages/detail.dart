// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_cast

import 'package:barang_finder_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatelessWidget {
  final Product product;

  const Detail({Key? key, required this.product}) : super(key: key);

  Future<String?> getImage() async {
    // Anda perlu mengembalikan URL gambar dari sumber yang sesuai.
    // Misalnya, langsung mengembalikan product.imagePath jika valid.
    return product.imagePath as String?;
  }

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
                  launch(product.location!);
                }
              },
              child: Text(
                'Location: ${product.location as String? ?? 'Location not available'}',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: getImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Image.network(
                    snapshot.data as String? ?? '',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading image');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
