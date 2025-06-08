import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esnaf_pos/models/customer_model.dart';
import 'package:esnaf_pos/widgets/custom_text_form_field.dart';
import 'package:esnaf_pos/widgets/customer_transaction_list_item.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _paymentFormKey = GlobalKey<FormState>();
  final _paymentAmountController = TextEditingController();
  
  final _adjustBalanceFormKey = GlobalKey<FormState>();
  final _newBalanceController = TextEditingController();
  
  bool _isProcessing = false;

  @override
  void dispose() {
    _paymentAmountController.dispose();
    _newBalanceController.dispose();
    super.dispose();
  }

  Future<void> _showRecordPaymentDialog() async {
    _paymentAmountController.clear();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Ödeme Al'),
          content: SingleChildScrollView(
            child: Form(
              key: _paymentFormKey,
              child: CustomTextFormField(
                controller: _paymentAmountController,
                labelText: 'Ödeme Tutarı (₺)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'Lütfen tutarı girin'; }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) { return 'Geçerli bir tutar girin';}
                  return null;
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () { Navigator.of(dialogContext).pop(); },
            ),
            ElevatedButton(
              child: const Text('Ödemeyi Kaydet'),
              onPressed: () { _recordPayment(dialogContext); },
            ),
          ],
        );
      },
    );
  }

  Future<void> _recordPayment(BuildContext dialogContext) async {
    if (_paymentFormKey.currentState!.validate()) {
      Navigator.of(dialogContext).pop(); 
      setState(() { _isProcessing = true; });
      final paymentAmount = double.parse(_paymentAmountController.text);
      final db = FirebaseFirestore.instance;
      final batch = db.batch();
      try {
        final customerRef = db.collection('customers').doc(widget.customer.id);
        batch.update(customerRef, {'totalDebt': FieldValue.increment(-paymentAmount)});
        final transactionRef = db.collection('customer_transactions').doc();
        batch.set(transactionRef, {
          'customerId': widget.customer.id,
          'transactionDate': Timestamp.now(),
          'type': 'PAYMENT',
          'amount': paymentAmount,
        });
        await batch.commit();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ödeme başarıyla kaydedildi!'), backgroundColor: Colors.green),
          );
        }
      } catch (e) { /* Hata yönetimi */ } 
      finally {
        if (mounted) { setState(() { _isProcessing = false; });}
      }
    }
  }

  Future<void> _showAdjustBalanceDialog() async {
    final currentCustomerDoc = await FirebaseFirestore.instance.collection('customers').doc(widget.customer.id).get();
    final currentCustomerData = Customer.fromFirestore(currentCustomerDoc);
    _newBalanceController.text = currentCustomerData.totalDebt.toStringAsFixed(2);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Bakiye Düzelt'),
          content: SingleChildScrollView(
            child: Form(
              key: _adjustBalanceFormKey,
              child: CustomTextFormField(
                controller: _newBalanceController,
                labelText: 'Yeni Toplam Borç (₺)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) { return 'Lütfen yeni bakiyeyi girin';}
                  if (double.tryParse(value) == null) { return 'Geçerli bir sayı girin';}
                  return null;
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () { Navigator.of(dialogContext).pop(); },
            ),
            ElevatedButton(
              child: const Text('Bakiyeyi Güncelle'),
              onPressed: () { _adjustBalance(dialogContext, currentCustomerData.totalDebt);},
            ),
          ],
        );
      },
    );
  }

  Future<void> _adjustBalance(BuildContext dialogContext, double currentDebt) async {
    if (_adjustBalanceFormKey.currentState!.validate()) {
      Navigator.of(dialogContext).pop();
      setState(() { _isProcessing = true; });
      final newTotalDebt = double.parse(_newBalanceController.text);
      final adjustmentAmount = newTotalDebt - currentDebt; 
      final db = FirebaseFirestore.instance;
      final batch = db.batch();
      try {
        final customerRef = db.collection('customers').doc(widget.customer.id);
        batch.update(customerRef, {'totalDebt': newTotalDebt});
        final transactionRef = db.collection('customer_transactions').doc();
        batch.set(transactionRef, {
          'customerId': widget.customer.id,
          'transactionDate': Timestamp.now(),
          'type': 'BALANCE_ADJUSTMENT',
          'amount': adjustmentAmount,
          'newBalance': newTotalDebt,
        });
        await batch.commit();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bakiye başarıyla güncellendi!'), backgroundColor: Colors.blue),
          );
        }
      } catch (e) { /* Hata yönetimi */ } 
      finally {
        if (mounted) { setState(() { _isProcessing = false; });}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.customerName),
        backgroundColor: theme.canvasColor,
        foregroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.phone, color: theme.primaryColor),
                    title: const Text('Telefon Numarası'),
                    subtitle: Text(widget.customer.phoneNumber ?? 'Belirtilmemiş'),
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('customers').doc(widget.customer.id).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) { return const SizedBox.shrink(); }
                    final updatedCustomer = Customer.fromFirestore(snapshot.data!);
                    return Card(
                      color: updatedCustomer.totalDebt > 0 ? Colors.red.shade50 : Colors.green.shade50,
                      child: ListTile(
                        leading: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: updatedCustomer.totalDebt > 0 ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                        title: const Text('Toplam Borç/Alacak'),
                        subtitle: Text(
                          '${updatedCustomer.totalDebt.toStringAsFixed(2)} ₺',
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,
                            color: updatedCustomer.totalDebt > 0 ? Colors.red.shade700 : Colors.green.shade700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (_isProcessing)
                  const Center(child: CircularProgressIndicator())
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment), label: const Text('ÖDEME AL'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50), backgroundColor: Colors.orange.shade700, foregroundColor: Colors.white),
                          onPressed: _showRecordPaymentDialog,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit_note), label: const Text('BAKİYE DÜZELT'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 50), backgroundColor: Colors.blueGrey.shade700, foregroundColor: Colors.white),
                          onPressed: _showAdjustBalanceDialog,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                const Text('İşlem Geçmişi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('customer_transactions')
                  .where('customerId', isEqualTo: widget.customer.id)
                  .orderBy('transactionDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('İşlem geçmişi yüklenirken bir hata oluştu.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Bu müşteri için henüz işlem yok.'));
                }
                final transactionDocs = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  itemCount: transactionDocs.length,
                  itemBuilder: (context, index) {
                    return CustomerTransactionListItem(transactionDoc: transactionDocs[index]);
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