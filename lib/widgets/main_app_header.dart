import 'package:flutter/material.dart';

class MainAppHeader extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const MainAppHeader({super.key, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.apps_rounded),
            tooltip: 'Menüyü Aç',
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Row(
            children: [
              if (onAddPressed != null)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Yeni Ekle',
                  onPressed: onAddPressed,
                ),
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.person_outline,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}