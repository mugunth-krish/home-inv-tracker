import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:home_inventory_app/models/inventory_items.dart';
import '../services/api_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();

  String? imagePath;       // Mobile file path or web blob URL
  Uint8List? imageBytes;   // For preview on web or mobile

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Item name"),
            ),
            TextField(
              controller: locationCtrl,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 20),

            // Pick photo button
            ElevatedButton(
              onPressed: () async {
                final picked = await picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  if (kIsWeb) {
                    imageBytes = await picked.readAsBytes();
                    imagePath = picked.path;
                  } else {
                    imagePath = picked.path;
                    final file = File(picked.path);
                    imageBytes = await file.readAsBytes();
                  }
                  setState(() {});
                }
              },
              child: const Text("Pick Photo"),
            ),

            // Preview image
            if (imageBytes != null)
              Image.memory(imageBytes!, height: 150),

            const Spacer(),

            // Save button
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty || locationCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter name and location")),
                  );
                  return;
                }

                final newItem = InventoryItem(
                  id: "temp", // backend replaces this
                  name: nameCtrl.text,
                  location: locationCtrl.text,
                );

                final api = ApiService();
                final saved = await api.addItem(newItem);

                // Upload photo
                if (imagePath != null) {
                  await api.uploadPhoto(saved.id, imagePath!);
                }

                if (mounted) Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
