// product.dart
class Product {
  String name;
  double price;
  String location;
  String detail;
  String? imagePath;
  String storeName;
  String storeDetail;
  String storeImagePath;
  String storeAddress;
  String storePhoneNumber;
  // double latitude; // Add latitude property
  // double longitude; // Add longitude property

  Product({
    required this.name,
    required this.price,
    required this.location,
    required this.detail,
    this.imagePath,
    required this.storeName,
    required this.storeDetail,
    required this.storeImagePath,
    required this.storeAddress,
    required this.storePhoneNumber,
    // required this.latitude,
    // required this.longitude,
  });
}