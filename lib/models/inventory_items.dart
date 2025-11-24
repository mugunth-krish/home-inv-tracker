class InventoryItem {
final String id;
final String name;
final String location;
final String? photoUrl;


InventoryItem({
required this.id,
required this.name,
required this.location,
this.photoUrl,
});


factory InventoryItem.fromJson(Map<String, dynamic> json) {
return InventoryItem(
id: json['id'],
name: json['name'],
location: json['location'],
photoUrl: json['photoUrl'],
);
}


Map<String, dynamic> toJson() {
return {
'name': name,
'location': location,
'photoUrl': photoUrl,
};
}
}