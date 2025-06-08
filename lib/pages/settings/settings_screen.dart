import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationSwitch = false;
  bool _emailSwitch = false;

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
            'Settings',
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
              _buildSectionHeader('General'),
              _buildSettingsContainer(
                children: [
                  _buildToggleRow(
                    title: 'Notification',
                    value: _notificationSwitch,
                    onChanged: (value) {
                      setState(() {
                        _notificationSwitch = value;
                      });
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildNavigationRow(title: 'Theme Mode', value: 'Light'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildToggleRow(
                    title: 'Email',
                    value: _emailSwitch,
                    onChanged: (value) {
                      setState(() {
                        _emailSwitch = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('Support'),
              _buildSettingsContainer(
                children: [
                  _buildNavigationRow(title: 'Terms of Services'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildNavigationRow(title: 'Data Policy'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildNavigationRow(title: 'About'),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildNavigationRow(title: 'Help/FAQ'),
                   const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildNavigationRow(title: 'Contact Us'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () {
            // TODO: Sign Out logic
          },
          child: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Bölüm başlıkları için yardımcı metot
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Ayar satırlarını tutan ana konteyner için yardımcı metot
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

  // Açma/kapama anahtarlı ayar satırları için yardımcı metot
  Widget _buildToggleRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green, // Açıkken yeşil
        inactiveThumbColor: Colors.red, // Kapalıyken topuzu kırmızı
        inactiveTrackColor: Colors.red.withOpacity(0.3), // Kapalıyken yolu kırmızımsı
      ),
    );
  }

  // Ok ikonlu, tıklanabilir ayar satırları için yardımcı metot
  Widget _buildNavigationRow({required String title, String? value}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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