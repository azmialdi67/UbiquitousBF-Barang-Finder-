// ignore_for_file: deprecated_member_use

import 'package:barang_finder_app/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import 'add_product_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> produk = [];
  List<Product> hasilPencarian = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplikasi Pencari Barang',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _temukanProdukTerdekat();
            },
            icon: const Icon(Icons.location_on),
          ),
          IconButton(
            onPressed: () async {
              final hasil = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductPage(
                    product: Product(
                      name: '',
                      price: 0.0,
                      location: '',
                      detail: '',
                      imagePath: null,
                      storeName: '',
                      storeDetail: '',
                      storeImagePath: '',
                      storeAddress: '',
                      storePhoneNumber: '',
                    ),
                  ),
                ),
              );

              if (hasil != null && hasil is Product) {
                setState(() {
                  produk.add(hasil);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Produk "${hasil.name}" berhasil ditambahkan!\n'
                      'Harga: ${hasil.price}\n'
                      'Lokasi: ${hasil.location}\n'
                      'Detail: ${hasil.detail}',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _cariProdukTerdekat(value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari Barang...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: hasilPencarian.isEmpty
                  ? const Center(
                      child: Text('Tidak ada hasil pencarian'),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hasilPencarian.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: hasilPencarian[index].imagePath != null
                                      ? Image.network(
                                          Uri.parse(hasilPencarian[index].imagePath!).toString(),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : const Placeholder(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  hasilPencarian[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Rp. ${hasilPencarian[index].price}',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _launchGoogleMaps(hasilPencarian[index].location);
                                        },
                                        icon: const Icon(Icons.store),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _hapusProduk(index);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _bukaDetailProduk(index);
                                    },
                                    icon: const Icon(Icons.more_horiz),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(
                product: Product(
                  name: '',
                  price: 0.0,
                  location: '',
                  detail: '',
                  imagePath: null,
                  storeName: '',
                  storeDetail: '',
                  storeImagePath: '',
                  storeAddress: '',
                  storePhoneNumber: '',
                ),
              ),
            ),
          );

          if (hasil != null && hasil is Product) {
            setState(() {
              produk.add(hasil);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Produk "${hasil.name}" berhasil ditambahkan!\n'
                  'Harga: ${hasil.price}\n'
                  'Lokasi: ${hasil.location}\n'
                  'Detail: ${hasil.detail}',
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _hapusProduk(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  produk.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produk berhasil dihapus'),
                  ),
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _bukaDetailProduk(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: hasilPencarian[index]),
      ),
    );
  }

  void _launchGoogleMaps(String location) async {
    final String mapsUrl = location;
    // ignore: duplicate_ignore
    // ignore: deprecated_member_use
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      // ignore: avoid_print
      print('Could not launch $mapsUrl');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka halaman Maps'),
        ),
      );
    }
  }

  Future<void> _temukanProdukTerdekat() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Logic to find nearby products based on user's location (position)
      // ...

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Menemukan produk terdekat di lokasi (${position.latitude}, ${position.longitude})',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menemukan lokasi Anda'),
        ),
      );
    }
  }

  void _cariProdukTerdekat(String keyword) {
    setState(() {
      hasilPencarian = produk
          .where(
            (product) => product.name.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    });
  }
}
