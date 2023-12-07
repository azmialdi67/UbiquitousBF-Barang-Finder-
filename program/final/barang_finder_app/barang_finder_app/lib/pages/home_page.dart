// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'add_product_page.dart';
import '../model/product.dart';
import 'product_detail_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<Product> products;

  CustomSearchDelegate({required this.products});

  // Implementasi metode pencarian
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implementasi logika pencarian dan tampilkan hasilnya
    // Di sini, Anda dapat menggunakan query untuk mencari produk yang sesuai
    // dan menampilkan hasilnya.
    return Text('Hasil pencarian: $query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implementasi saran saat pengguna sedang mengetik
    // Anda dapat menampilkan produk yang sesuai dengan query atau memberikan saran lainnya.
    return Text('Saran pencarian');
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(product.productName ?? ''),
        subtitle: Text('Harga: Rp. ${product.harga}'),
        onTap: () {
          _navigateToProductDetail(context, product);
        },
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required List products}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan produk dari API saat halaman dimuat
    _getProductsFromAPI();
  }

  Future<void> _getProductsFromAPI() async {
    final apiUrl = Uri.parse('http://localhost:4000/product_posts'); // Ganti dengan URL API Anda
    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final List<Product> products = responseData
            .map((dynamic item) => Product.fromJson(item))
            .cast<Product>() // Menambahkan casting ke tipe Product
            .toList();

        setState(() {
          _products = products;
        });
      } else {
        print('Failed to get products. Error: ${response.statusCode}');
        // Tambahkan logika penanganan kesalahan jika diperlukan
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? result = await showSearch<String>(
                context: context,
                delegate: CustomSearchDelegate(products: _products),
              );
              // Implementasi logika berdasarkan hasil pencarian jika diperlukan
              print('Hasil pencarian: $result');
            },
          ),
        ],
      ),
      body: _buildProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddProductPage(context),
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddProductPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage()),
    );

    if (result != null && result is Product) {
      // Upload produk yang ditambahkan ke API
      _uploadProduct(result);

      setState(() {
        _products.add(result);
      });
    }
  }

  Future<void> _uploadProduct(Product product) async {
    final apiUrl = Uri.parse('http://localhost:4000/posts');
    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        print('Product uploaded successfully!');
        // Tambahkan logika lain jika diperlukan setelah upload
        _getProductsFromAPI(); // Perbarui daftar produk setelah menambahkan produk baru
      } else {
        print('Failed to upload product. Error: ${response.statusCode}');
        // Tambahkan logika penanganan kesalahan jika diperlukan
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ProductTile(product: product);
      },
    );
  }
}
