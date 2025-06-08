import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esnaf_pos/models/product_model.dart';
import 'package:esnaf_pos/widgets/custom_text_form_field.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _barcodeController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _stockQuantityController;

  bool _isLoading = false;
  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _productNameController =
        TextEditingController(text: widget.product?.productName ?? '');
    _barcodeController =
        TextEditingController(text: widget.product?.barcode ?? '');
    _sellingPriceController = TextEditingController(
        text: widget.product?.sellingPrice.toString() ?? '');
    _stockQuantityController = TextEditingController(
        text: widget.product?.stockQuantity.toString() ?? '');
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _barcodeController.dispose();
    _sellingPriceController.dispose();
    _stockQuantityController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final productData = {
        'productName': _productNameController.text,
        'barcode': _barcodeController.text,
        'sellingPrice': double.parse(_sellingPriceController.text),
        'stockQuantity': int.parse(_stockQuantityController.text),
        'createdAt': _isEditing
            ? widget.product!.id 
            : Timestamp.now(),
      };

      try {
        if (_isEditing) {
          await FirebaseFirestore.instance
              .collection('products')
              .doc(widget.product!.id)
              .update(productData);
        } else {
          await FirebaseFirestore.instance
              .collection('products')
              .add(productData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(_isEditing ? 'Ürün güncellendi!' : 'Ürün eklendi!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata oluştu: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.canvasColor,
      appBar: AppBar(
        title: Text(_isEditing ? 'Ürünü Düzenle' : 'Yeni Ürün'),
        elevation: 0,
        backgroundColor: theme.canvasColor,
        foregroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  controller: _productNameController,
                  labelText: 'Ürün Adı',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen ürün adını girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _barcodeController,
                  labelText: 'Barkod (Opsiyonel)',
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _sellingPriceController,
                  labelText: 'Satış Fiyatı (₺)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen satış fiyatını girin';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Lütfen geçerli bir sayı girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _stockQuantityController,
                  labelText: 'Stok Adedi',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen stok adedini girin';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Lütfen geçerli bir tamsayı girin';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveProduct,
                child: Text(_isEditing ? 'GÜNCELLE' : 'ÜRÜNÜ KAYDET'),
              ),
      ),
    );
  }
}