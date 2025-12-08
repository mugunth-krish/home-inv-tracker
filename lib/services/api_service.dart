import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'package:home_inventory_app/models/inventory_items.dart';

class ApiService {
  final String baseUrl = "http://localhost:5000";

  // Get all items
  Future<List<InventoryItem>> getItems() async {
    final response = await http.get(Uri.parse("$baseUrl/items"));
    if (response.statusCode != 200) {
      throw Exception("Failed to load items");
    }
    final List data = jsonDecode(response.body);
    return data.map((e) => InventoryItem.fromJson(e)).toList();
  }

  // Add a new item
  Future<InventoryItem> addItem(InventoryItem item) async {
    final response = await http.post(
      Uri.parse("$baseUrl/items"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add item");
    }
    return InventoryItem.fromJson(jsonDecode(response.body));
  }

  // Delete an item
  Future<void> deleteItem(String itemId) async {
    final response = await http.delete(Uri.parse("$baseUrl/items/$itemId"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete item");
    }
  }

  // Upload photo (Web + Mobile compatible)
  Future<void> uploadPhoto(String itemId, String filePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/items/$itemId/photo"),
    );

    if (kIsWeb) {
      // Web: read bytes from XFile
      final xfile = XFile(filePath);
      final bytes = await xfile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          bytes,
          filename: "upload_${DateTime.now().millisecondsSinceEpoch}.jpg",
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    } else {
      // Mobile: upload file from path
      request.files.add(await http.MultipartFile.fromPath('photo', filePath));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception("Photo upload failed");
    }
  }
}
