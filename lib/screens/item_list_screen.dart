import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/inventory_items.dart';
import 'add_item_screen.dart';
import '../widget/item_card.dart';


class ItemListScreen extends StatefulWidget {
const ItemListScreen({super.key});


@override
State<ItemListScreen> createState() => _ItemListScreenState();
}


class _ItemListScreenState extends State<ItemListScreen> {
late Future<List<InventoryItem>> items;


@override
void initState() {
super.initState();
items = ApiService().getItems();
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("My Inventory")),
body: FutureBuilder<List<InventoryItem>>(
future: items,
builder: (context, snapshot) {
if (!snapshot.hasData) {
return const Center(child: CircularProgressIndicator());
}
final list = snapshot.data!;
if (list.isEmpty) {
return const Center(child: Text("No items yet"));
}
return ListView.builder(
itemCount: list.length,
itemBuilder: (context, i) => ItemCard(item: list[i]),
);
},
),
floatingActionButton: FloatingActionButton(
onPressed: () async {
await Navigator.push(
context,
MaterialPageRoute(builder: (_) => const AddItemScreen()),
);
setState(() {
items = ApiService().getItems();
});
},
child: const Icon(Icons.add),
),
);
}
}