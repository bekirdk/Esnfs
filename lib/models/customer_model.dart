import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String? id;
  final String customerName;
  final String? phoneNumber;
  final double totalDebt;

  Customer({
    this.id,
    required this.customerName,
    this.phoneNumber,
    this.totalDebt = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'totalDebt': totalDebt,
    };
  }

  factory Customer.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Customer(
      id: doc.id,
      customerName: data['customerName'],
      phoneNumber: data['phoneNumber'],
      totalDebt: (data['totalDebt'] as num).toDouble(),
    );
  }
}