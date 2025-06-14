import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esnaf_pos/models/product_model.dart';
import 'package:esnaf_pos/widgets/main_app_header.dart';
import 'package:esnaf_pos/widgets/product_list_item.dart';
import 'package:esnaf_pos/pages/products/add_product_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: MainAppHeader(
              onAddPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductScreen()),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('createdAt', descending: true)
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
                    child: Text('Henüz hiç ürün eklenmemiş.'),
                  );
                }
                final productDocs = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: productDocs.length,
                  itemBuilder: (context, index) {
                    final product = Product.fromFirestore(productDocs[index]);
                    return ProductListItem(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}