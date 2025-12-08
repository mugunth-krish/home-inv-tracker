import 'package:flutter/material.dart';
import 'package:home_inventory_app/models/inventory_items.dart';
import 'package:home_inventory_app/services/api_service.dart';

class ItemCard extends StatelessWidget {
  final InventoryItem item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: item.photoUrl != null
            ? Image.network(
                item.photoUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.inventory),

        title: Text(item.name),
        subtitle: Text(item.location),

        // 👉 DELETE BUTTON
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Delete item?"),
                content:
                    Text("Are you sure you want to delete '${item.name}'?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete"),
                  ),
                ],
              ),
            );

            if (confirm != true) return;

            // API DELETE CALL
            await ApiService().deleteItem(item.id);

            // Snackbar for feedback
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Item deleted")),
            );

            // Refresh the list by reopening the route
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
    );
  }
}
