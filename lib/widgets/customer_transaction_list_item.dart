import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomerTransactionListItem extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> transactionDoc;

  const CustomerTransactionListItem({super.key, required this.transactionDoc});

  String _getTransactionTypeText(String type) {
    switch (type) {
      case 'SALE_DEBT':
        return 'Satıştan Borç';
      case 'PAYMENT':
        return 'Yapılan Ödeme';
      case 'BALANCE_ADJUSTMENT':
        return 'Bakiye Düzeltme';
      default:
        return 'Bilinmeyen İşlem';
    }
  }

  IconData _getTransactionTypeIcon(String type) {
    switch (type) {
      case 'SALE_DEBT':
        return Icons.shopping_cart_checkout_outlined;
      case 'PAYMENT':
        return Icons.payment_outlined;
      case 'BALANCE_ADJUSTMENT':
        return Icons.tune_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Color _getAmountColor(String type, double amount, BuildContext context) {
    if (type == 'PAYMENT' || (type == 'BALANCE_ADJUSTMENT' && amount < 0)) {
      return Colors.green.shade700;
    } else if (type == 'SALE_DEBT' || (type == 'BALANCE_ADJUSTMENT' && amount > 0)) {
      return Colors.red.shade700;
    }
    return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  }


  @override
  Widget build(BuildContext context) {
    final transactionData = transactionDoc.data();
    final Timestamp transactionTimestamp = transactionData['transactionDate'];
    final DateTime transactionDate = transactionTimestamp.toDate();
    final String formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(transactionDate);
    final String type = transactionData['type'];
    final double amount = (transactionData['amount'] as num).toDouble();

    String amountText = '${amount.abs().toStringAsFixed(2)} ₺';
    if (type == 'PAYMENT' || (type == 'BALANCE_ADJUSTMENT' && amount < 0)) {
      amountText = '- $amountText';
    } else if (type == 'SALE_DEBT' || (type == 'BALANCE_ADJUSTMENT' && amount > 0)) {
      amountText = '+ $amountText';
    }


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        leading: Icon(
          _getTransactionTypeIcon(type),
          color: _getAmountColor(type, amount, context),
        ),
        title: Text(
          _getTransactionTypeText(type),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(formattedDate),
        trailing: Text(
          amountText,
          style: TextStyle(
            color: _getAmountColor(type, amount, context),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}