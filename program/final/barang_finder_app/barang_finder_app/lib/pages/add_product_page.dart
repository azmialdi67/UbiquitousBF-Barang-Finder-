import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../model/product.dart';

class AddProductPage extends StatefulWidget {
  final Product product;

  const AddProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  XFile? pickedImage;
  XFile? storeImage;
  String location = '';
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeDetailController = TextEditingController();

  Future<void> _pickImage() async {
    XFile? image;
    if (kIsWeb) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      widget.product.imagePath = image.path;

      setState(() {
        pickedImage = image;
      });
    }
  }

  Future<void> _pickStoreImage() async {
    XFile? image;
    if (kIsWeb) {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (image != null) {
      setState(() {
        storeImage = image;
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
        widget.product.location = location;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error getting location: $e');
      // Handle error getting location
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
              onChanged: (value) {
                setState(() {
                  widget.product.name = value;
                });
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  widget.product.price = double.tryParse(value) ?? 0.0;
                });
              },
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
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Detail Produk'),
              onChanged: (value) {
                setState(() {
                  widget.product.detail = value;
                });
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Toko'),
              controller: storeNameController,
            ),
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Detail Toko'),
              controller: storeDetailController,
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
              onPressed: _pickStoreImage,
              child: const Text('Pilih Foto untuk Toko'),
            ),

            const SizedBox(height: 20),

            storeImage != null
                ? (kIsWeb
                    ? Image.network(storeImage!.path)
                    : Image.file(File(storeImage!.path)))
                : const SizedBox.shrink(),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final addedProduct = Product(
                  name: widget.product.name,
                  price: widget.product.price,
                  location: widget.product.location,
                  detail: widget.product.detail,
                  imagePath: pickedImage?.path,
                  storeName: storeNameController.text,
                  storeDetail: storeDetailController.text,
                  storeImagePath: 
                  storeImage!.path, 
                  storeAddress: '', 
                  storePhoneNumber: '',
                );
                Navigator.pop(context, addedProduct);
              },
              child: const Text('Tambah Produk'),
            ),
          ],
        ),
      ),
    );
  }
}
