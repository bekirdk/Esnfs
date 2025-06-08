import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Örnek bir kart kullanımı
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Uygulama kontrol paneline hoş geldiniz. Aşağıdaki butonlar belirlediğimiz stile sahiptir.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Örnek Butonlar
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.point_of_sale),
              label: const Text('HIZLI SATIŞ'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.inventory_2_outlined),
              label: const Text('ÜRÜN YÖNETİMİ'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.people_alt_outlined),
              label: const Text('MÜŞTERİLER'),
            ),
          ],
        ),
      ),
    );
  }
}