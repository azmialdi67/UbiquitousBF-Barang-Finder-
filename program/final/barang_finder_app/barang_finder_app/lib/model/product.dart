// product.dart
// ignore_for_file: prefer_typing_uninitialized_variables

class Product {
  String name;
  String description; // changed from double price to String description
  double harga; // changed from double price to double harga
  String location;
  String? imagePath;
  DateTime createdAt;

  var productName;

  var lokasi;

  var fotoBarang;

  var storeImagePath; // Added createdAt property
  // Add other properties as needed

  Product({
    required this.name,
    required this.description,
    required this.harga,
    required this.location,
    this.imagePath,
    required this.createdAt,
    // Initialize other properties here
  });
}
