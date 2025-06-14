import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:esnaf_pos/pages/customers/customers_screen.dart';
import 'package:esnaf_pos/pages/home/home_screen.dart';
import 'package:esnaf_pos/pages/products/products_screen.dart';
import 'package:esnaf_pos/pages/reports/reports_screen.dart';
import 'package:esnaf_pos/pages/quick_sale/quick_sale_screen.dart';
import 'package:esnaf_pos/widgets/main_drawer.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProductsScreen(),
    const ReportsScreen(),
    const CustomersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _widgetOptions[_selectedIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuickSaleScreen()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.inventory_2_outlined,
                color: _selectedIndex == 1
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(
                Icons.bar_chart_outlined,
                color: _selectedIndex == 2
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(
                Icons.people_alt_outlined,
                color: _selectedIndex == 3
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}