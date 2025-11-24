import 'package:flutter/material.dart';
import 'package:home_inventory_app/screens/item_list_screen.dart';


void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ItemListScreen(),
    );
  }
}
