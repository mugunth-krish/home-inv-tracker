import 'dart:io';
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
String? imagePath;


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
ElevatedButton(
onPressed: () async {
final picked = await ImagePicker().pickImage(source: ImageSource.camera);
if (picked != null) {
setState(() => imagePath = picked.path);
}
},
child: const Text("Pick Photo"),
),
if (imagePath != null)
Image.file(File(imagePath!), height: 150),
const Spacer(),
ElevatedButton(
onPressed: () async {
final newItem = InventoryItem(
id: "temp", // replaced by backend
name: nameCtrl.text,
location: locationCtrl.text,
);
final api = ApiService();
final saved = await api.addItem(newItem);
if (imagePath != null) {
await api.uploadPhoto(saved.id, imagePath!);
}
if (mounted) Navigator.pop(context);
},
child: const Text("Save"),
)
],
),
),
);
}
}