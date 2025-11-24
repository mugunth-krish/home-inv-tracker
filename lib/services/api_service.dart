import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:home_inventory_app/models/inventory_items.dart';


class ApiService {
final String baseUrl = "http://localhost:5000";


Future<List<InventoryItem>> getItems() async {
final response = await http.get(Uri.parse("$baseUrl/items"));
if (response.statusCode != 200) {
throw Exception("Failed to load items");
}
final List data = jsonDecode(response.body);
return data.map((e) => InventoryItem.fromJson(e)).toList();
}


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


Future<void> uploadPhoto(String itemId, String filePath) async {
var request = http.MultipartRequest(
'POST',
Uri.parse("$baseUrl/items/$itemId/photo"),
);
request.files.add(await http.MultipartFile.fromPath('photo', filePath));
final response = await request.send();
if (response.statusCode != 200) {
throw Exception("Photo upload failed");
}
}
}