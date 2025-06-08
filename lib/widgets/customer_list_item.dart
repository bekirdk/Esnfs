import 'package:flutter/material.dart';
import 'package:esnaf_pos/models/customer_model.dart';
import 'package:esnaf_pos/pages/customers/customer_detail_screen.dart';

class CustomerListItem extends StatelessWidget {
  final Customer customer;

  const CustomerListItem({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color debtColor = customer.totalDebt > 0
        ? Colors.red.shade700
        : (customer.totalDebt == 0 ? Colors.black87 : Colors.green.shade700);
    String debtText = customer.totalDebt == 0 
        ? 'Borcu Yok' 
        : '${customer.totalDebt.toStringAsFixed(2)} ₺';
    if(customer.totalDebt < 0) {
      debtText = '${(customer.totalDebt * -1).toStringAsFixed(2)} ₺ Alacaklı';
    }


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withOpacity(0.1),
          foregroundColor: theme.primaryColor,
          child: const Icon(Icons.person_outline),
        ),
        title: Text(
          customer.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(customer.phoneNumber ?? 'Telefon numarası yok'),
        trailing: Text(
          debtText,
          style: TextStyle(
            color: debtColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerDetailScreen(customer: customer),
            ),
          );
        },
      ),
    );
  }
}