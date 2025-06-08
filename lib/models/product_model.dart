// lib/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String productName;
  final String barcode;
  final double sellingPrice;
  final int stockQuantity;

  Product({
    this.id,
    required this.productName,
    required this.barcode,
    required this.sellingPrice,
    required this.stockQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'barcode': barcode,
      'sellingPrice': sellingPrice,
      'stockQuantity': stockQuantity,
    };
  }

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Product(
      id: doc.id,
      productName: data['productName'],
      barcode: data['barcode'],
      sellingPrice: data['sellingPrice'],
      stockQuantity: data['stockQuantity'],
    );
  }
}