import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SaleListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> saleDoc;

  const SaleListItem({super.key, required this.saleDoc});

  @override
  Widget build(BuildContext context) {
    final saleData = saleDoc.data();
    final Timestamp saleTimestamp = saleData['saleDate'];
    final DateTime saleDate = saleTimestamp.toDate();
    final String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(saleDate);
    final List items = saleData['items'];
    final double totalAmount = saleData['totalAmount'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          formattedDate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${items.length} kalem ürün satıldı'),
        trailing: Text(
          '${totalAmount.toStringAsFixed(2)} ₺',
          style: TextStyle(
            color: Colors.green.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}