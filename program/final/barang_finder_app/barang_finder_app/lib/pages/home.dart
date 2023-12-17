// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:barang_finder_app/model/product.dart';
import 'package:barang_finder_app/pages/add.dart';
import 'package:barang_finder_app/pages/detail.dart'; // Import halaman detail.dart

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: const AddProductForm(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:5000/get_products'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        products = responseData.map((json) => Product.fromJson(json)).toList();
      });
    } else {
      debugPrint('Failed to fetch products. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang Finder App'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(products[index].productName ?? ''),
              subtitle: Text(products[index].description ?? ''),
              trailing: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Detail saat tombol ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(product: products[index]),
                    ),
                  );
                },
                child: Text('Details'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
