import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esnaf_pos/widgets/sale_list_item.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfToday =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    return Column(
      children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('sales')
              .where('saleDate', isGreaterThanOrEqualTo: startOfToday)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const SizedBox.shrink();
            }

            double todaysTotal = 0;
            for (var doc in snapshot.data!.docs) {
              todaysTotal += doc.data()['totalAmount'];
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Bugünün Toplam Satışı",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${todaysTotal.toStringAsFixed(2)} ₺',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('sales')
                .orderBy('saleDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Bir hata oluştu.'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('Henüz hiç satış yapılmamış.'));
              }

              final saleDocs = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: saleDocs.length,
                itemBuilder: (context, index) {
                  return SaleListItem(saleDoc: saleDocs[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}