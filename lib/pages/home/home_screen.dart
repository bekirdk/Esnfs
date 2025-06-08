import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ana Sayfa',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}