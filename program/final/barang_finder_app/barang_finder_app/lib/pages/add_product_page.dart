// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  XFile? pickedImage;
  String location = '';
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  Future<void> _pickImage() async {
    XFile? image;
    if (kIsWeb) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      setState(() {
        pickedImage = image;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        location = _getGoogleMapsLink(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  String _getGoogleMapsLink(double latitude, double longitude) {
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              controller: productNameController,
            ),
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
              controller: descriptionController,
            ),
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
              controller: hargaController,
            ),
            const SizedBox(height: 12),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Lokasi Produk',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: _getCurrentLocation,
                ),
              ),
              controller: TextEditingController(text: location),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pilih Foto untuk Produk'),
            ),

            const SizedBox(height: 20),

            pickedImage != null
                ? (kIsWeb
                    ? Image.network(pickedImage!.path)
                    : Image.file(File(pickedImage!.path)))
                : const SizedBox.shrink(),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final addedProduct = Product(
                  productName: productNameController.text,
                  description: descriptionController.text,
                  harga: double.tryParse(hargaController.text) ?? 0.0,
                  location: location,
                  imagePath: pickedImage?.path,
                  createdAt: DateTime.now(),
                );
                _uploadProduct(addedProduct);
              },
              child: const Text('Tambah Produk'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadProduct(Product product) async {
    final apiUrl = Uri.parse('http://localhost:4000/product_posts'); 
    final response = await http.post(
      apiUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      print('Product uploaded successfully!');
      // Tambahkan logika lain jika diperlukan setelah upload
      Navigator.pop(context, product);
    } else {
      print('Failed to upload product. Error: ${response.statusCode}');
      // Tambahkan logika penanganan kesalahan jika diperlukan
    }
  }
}
