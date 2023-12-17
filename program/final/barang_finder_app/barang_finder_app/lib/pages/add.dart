// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({Key? key}) : super(key: key);

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();

  Uint8List? _imageBytes; // Variable untuk menyimpan data gambar yang dipilih

  Future<void> addProduct() async {
    final Map<String, dynamic> data = {
      'productName': productNameController.text,
      'description': descriptionController.text,
      'harga': double.parse(hargaController.text),
      'location': locationController.text,
      'imagePath': imagePathController.text,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5000/add_product'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Product added successfully!');
      showNotification('Add Product Success');
      // Navigate to home or display a success message
      Navigator.pop(context); // Kembali ke halaman sebelumnya (dalam hal ini, halaman utama)
    } else {
      print('Failed to add product. Status code: ${response.statusCode}');
      showNotification('Failed to add product');
      // Handle error and display an error message
    }
  }

  Future<void> getLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final String latitude = position.latitude.toString();
    final String longitude = position.longitude.toString();

    final String googleMapsLink = 'https://www.google.com/maps/place/$latitude,$longitude';

    setState(() {
      locationController.text = googleMapsLink;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final List<int> imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(imageBytes);
        imagePathController.text = pickedFile.path;
      });
    }
  }

  void showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            ElevatedButton(
              onPressed: getLocation,
              child: Text('Get Location'),
            ),
            _imageBytes != null
                ? Image.memory(
                    _imageBytes!,
                    height: 100,
                  )
                : Container(),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
