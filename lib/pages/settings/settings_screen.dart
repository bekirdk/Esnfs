import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationSwitch = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: theme.primaryColor,
          title: const Text(
            'Ayarlar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Genel Ayarlar'),
              _buildSettingsContainer(
                children: [
                  _buildNavigationRow(title: 'Dükkan Bilgileri', value: 'Ayarlanmadı'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildNavigationRow(title: 'Tema Modu', value: 'Açık'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                   _buildNavigationRow(title: 'Para Birimi', value: '₺ (TL)'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildToggleRow(
                    title: 'Satış Bildirimleri',
                    value: _notificationSwitch,
                    onChanged: (value) {
                      setState(() {
                        _notificationSwitch = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('Destek'),
              _buildSettingsContainer(
                children: [
                  _buildNavigationRow(title: 'Yardım ve SSS'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildNavigationRow(title: 'Hakkında'),
                ],
              ),
               const SizedBox(height: 32),
              _buildSectionHeader('Hesap Yönetimi'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            foregroundColor: theme.primaryColor,
            elevation: 0,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () {
            // TODO: Sign Out logic
          },
          child: const Text(
            'Çıkış Yap',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor, // Açıkken ana tema rengimiz (mavi)
      ),
    );
  }

  Widget _buildNavigationRow({required String title, String? value}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: () {
        // TODO: İlgili sayfaya yönlendirme yapılacak
      },
    );
  }
}