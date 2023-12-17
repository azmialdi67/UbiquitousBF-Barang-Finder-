// product.dart

class Product {
  int? productId;
  String? productName;
  String? description;
  double? harga;
  String? location;
  String? imagePath;
  DateTime? createdAt;

  Product({
    this.productId,
    this.productName,
    this.description,
    this.harga,
    this.location,
    this.imagePath,
    this.createdAt,
  });

  // Factory method to create a Product instance from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_post_id'],
      productName: map['product_name'],
      description: map['description'],
      harga: map['harga']?.toDouble(),
      location: map['lokasi_barang'],
      imagePath: map['foto_barang'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Convert the Product instance to a map
  Map<String, dynamic> toMap() {
    return {
      'product_post_id': productId,
      'product_name': productName,
      'description': description,
      'harga': harga,
      'lokasi_barang': location,
      'foto_barang': imagePath,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Factory method to create a Product instance from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_post_id'],
      productName: json['product_name'],
      description: json['description'],
      harga: json['harga']?.toDouble(),
      location: json['lokasi_barang'],
      imagePath: json['foto_barang'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convert the Product instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_post_id': productId,
      'product_name': productName,
      'description': description,
      'harga': harga,
      'lokasi_barang': location,
      'foto_barang': imagePath,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
