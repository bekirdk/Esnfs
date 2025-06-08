import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esnaf_pos/models/product_model.dart';
import 'package:esnaf_pos/pages/quick_sale/barcode_scanner_screen.dart';
import 'package:esnaf_pos/pages/quick_sale/select_customer_screen.dart';
import 'package:esnaf_pos/models/customer_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class QuickSaleScreen extends StatefulWidget {
  const QuickSaleScreen({super.key});

  @override
  State<QuickSaleScreen> createState() => _QuickSaleScreenState();
}

class _QuickSaleScreenState extends State<QuickSaleScreen> {
  final List<CartItem> _cart = [];
  double _totalPrice = 0.0;
  bool _isLoading = false;
  Customer? _selectedCustomer;

  void _calculateTotalPrice() {
    double total = 0;
    for (var item in _cart) {
      total += item.product.sellingPrice * item.quantity;
    }
    setState(() {
      _totalPrice = total;
    });
  }

  void _addToCart(Product product) {
    setState(() {
      for (var item in _cart) {
        if (item.product.id == product.id) {
          item.quantity++;
          _calculateTotalPrice();
          return;
        }
      }
      _cart.add(CartItem(product: product, quantity: 1));
      _calculateTotalPrice();
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cart[index].quantity++;
      _calculateTotalPrice();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      _calculateTotalPrice();
    });
  }
  
  Future<void> _selectCustomer() async {
    final selected = await Navigator.push<Customer>(
      context,
      MaterialPageRoute(builder: (context) => const SelectCustomerScreen()),
    );
    if (selected != null) {
      setState(() {
        _selectedCustomer = selected;
      });
    }
  }

  Future<void> _scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (barcode == null || barcode.isEmpty) return;
    setState(() { _isLoading = true; });
    try {
      final productQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();
      if (productQuery.docs.isNotEmpty) {
        final product = Product.fromFirestore(productQuery.docs.first);
        _addToCart(product);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bu barkoda sahip bir ürün bulunamadı.')),
          );
        }
      }
    } catch (e) {
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ürün aranırken hata: $e')),
          );
        }
    } finally {
      if (mounted) { setState(() { _isLoading = false; });}
    }
  }

  Future<void> _completeSale() async {
    if (_cart.isEmpty) return;
    setState(() { _isLoading = true; });

    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    try {
      final saleRef = db.collection('sales').doc();
      final List<Map<String, dynamic>> saleItemsDetails = [];

      for (var cartItem in _cart) {
        final productRef = db.collection('products').doc(cartItem.product.id);
        batch.update(productRef, {'stockQuantity': FieldValue.increment(-cartItem.quantity)});
        saleItemsDetails.add({
          'productId': cartItem.product.id,
          'productName': cartItem.product.productName,
          'quantity': cartItem.quantity,
          'priceAtTimeOfSale': cartItem.product.sellingPrice,
        });
      }

      Map<String, dynamic> saleData = {
        'totalAmount': _totalPrice,
        'saleDate': Timestamp.now(),
        'items': saleItemsDetails,
      };

      if (_selectedCustomer != null) {
        saleData['customerId'] = _selectedCustomer!.id;
        saleData['customerName'] = _selectedCustomer!.customerName;

        final customerRef = db.collection('customers').doc(_selectedCustomer!.id);
        batch.update(customerRef, {'totalDebt': FieldValue.increment(_totalPrice)});

        final customerTransactionRef = db.collection('customer_transactions').doc();
        batch.set(customerTransactionRef, {
          'customerId': _selectedCustomer!.id,
          'transactionDate': Timestamp.now(),
          'type': 'SALE_DEBT',
          'amount': _totalPrice,
          'relatedSaleId': saleRef.id,
        });
      }

      batch.set(saleRef, saleData);
      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Satış başarıyla tamamlandı!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Satış sırasında hata: $e')),
          );
        }
    } finally {
      if (mounted) { setState(() { _isLoading = false; });}
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.canvasColor,
      appBar: AppBar(
        title: const Text('Hızlı Satış'),
        backgroundColor: theme.canvasColor,
        foregroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedCustomer == null
                        ? 'Müşteri Seçilmedi'
                        : 'Müşteri: ${_selectedCustomer!.customerName}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: _selectedCustomer == null ? FontWeight.normal : FontWeight.bold,
                        color: _selectedCustomer == null ? Colors.grey.shade700 : theme.primaryColor
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: _selectCustomer,
                  child: Text('MÜŞTERİ SEÇ', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _cart.isEmpty
                ? const Center(child: Text('Sepetiniz boş. Ürün eklemek için barkod okutun.'))
                : ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = _cart[index];
                      return ListTile(
                        title: Text(cartItem.product.productName),
                        subtitle: Text('${cartItem.product.sellingPrice.toStringAsFixed(2)} ₺ x ${cartItem.quantity} = ${(cartItem.product.sellingPrice * cartItem.quantity).toStringAsFixed(2)} ₺'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline, color: Colors.red.shade700),
                              onPressed: () => _decrementQuantity(index),
                            ),
                            Text(cartItem.quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline, color: Colors.green.shade700),
                              onPressed: () => _incrementQuantity(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (_isLoading) const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ) else Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Toplam: ${_totalPrice.toStringAsFixed(2)} ₺',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _scanBarcode,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('BARKOD OKUT'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _cart.isEmpty ? null : _completeSale,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('SATIŞI TAMAMLA'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}