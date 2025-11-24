import 'package:flutter/material.dart';
import 'package:home_inventory_app/models/inventory_items.dart';

class ItemCard extends StatelessWidget {
final InventoryItem item;
const ItemCard({super.key, required this.item});


@override
Widget build(BuildContext context) {
return Card(
child: ListTile(
leading: item.photoUrl != null
? Image.network(item.photoUrl!, width: 50, height: 50, fit: BoxFit.cover)
: const Icon(Icons.inventory),
title: Text(item.name),
subtitle: Text(item.location),
),
);
}
}