import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esnaf_pos/models/customer_model.dart';

class SelectCustomerScreen extends StatelessWidget {
  const SelectCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Müşteri Seç')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('customers')
            .orderBy('customerName')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Müşteriler yüklenirken bir hata oluştu.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Henüz kayıtlı müşteri bulunmuyor.'));
          }

          final customerDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: customerDocs.length,
            itemBuilder: (context, index) {
              final customer = Customer.fromFirestore(customerDocs[index]);
              return ListTile(
                title: Text(customer.customerName),
                subtitle: Text(customer.phoneNumber ?? ''),
                onTap: () {
                  Navigator.pop(context, customer);
                },
              );
            },
          );
        },
      ),
    );
  }
}