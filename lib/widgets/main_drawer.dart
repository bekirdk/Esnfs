import 'package:flutter/material.dart';
import 'package:esnaf_pos/pages/settings/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Esnaf POS Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Helvetica',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context); 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Çıkış Yap'),
            onTap: () {
              // TODO: Çıkış yapma mantığı eklenecek
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}