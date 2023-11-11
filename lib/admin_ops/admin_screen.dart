import 'package:flutter/material.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/admin_home.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/admin_products.dart';
import 'package:food_allergy_detection_app_v1/admin_ops/admin_to_be_added.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AdminHomeScreen(),
    AdminProductScreen(),
    AdminTobeaddedScreen(),
  ];

  final List<AppBar> _appBars = [
    AppBar(
      title: Text('Admin Home'),
      backgroundColor: Colors.purple[300],
    ),
    AppBar(
      title: Text('Products Screen'),
      backgroundColor: Colors.purple[300],
    ),
    AppBar(
      title: Text('Product to be added '),
      backgroundColor: Colors.purple[300],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_currentIndex],
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'To be Added',
          ),
        ],
      ),
    );
  }
}
