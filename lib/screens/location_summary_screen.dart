import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/inventory_items.dart';
import '../services/api_service.dart';

class LocationSummaryScreen extends StatefulWidget {
  const LocationSummaryScreen({super.key});

  @override
  State<LocationSummaryScreen> createState() => _LocationSummaryScreenState();
}

class _LocationSummaryScreenState extends State<LocationSummaryScreen> {
  late Future<List<InventoryItem>> itemsFuture;
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    itemsFuture = ApiService().getItems();
  }

  Map<String, int> itemsPerLocation(List<InventoryItem> items) {
    final map = <String, int>{};
    for (var item in items) {
      map[item.location] = (map[item.location] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory by Location")),
      body: FutureBuilder<List<InventoryItem>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          final locationCounts = itemsPerLocation(items);
          final locations = locationCounts.keys.toList();

          if (locations.isEmpty) {
            return const Center(child: Text("No items yet"));
          }

          return Column(
            children: [
              const SizedBox(height: 20),

              // PIE CHART
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      for (int i = 0; i < locations.length; i++)
                        PieChartSectionData(
                          // Remove title – it breaks touches
                          title: "",
                          value: locationCounts[locations[i]]!.toDouble(),
                          radius: selectedLocation == locations[i] ? 70 : 55,
                          color: Colors.primaries[i % Colors.primaries.length],
                        ),
                    ],
                    pieTouchData: PieTouchData(
                      touchCallback: (event, pieTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          return;
                        }

                        final index = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;

                        // 👇 Ignore hover events (Flutter Web)
                        if (index < 0) return;

                        setState(() {
                          selectedLocation = locations[index];
                        });
                      },
                    ),
                  ),
                ),
              ),

              // TITLE FOR SELECTED LOCATION
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  selectedLocation == null
                      ? "Tap a location above"
                      : "Items in: $selectedLocation",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // LIST OF ITEMS BELOW
              Expanded(
                child: selectedLocation == null
                    ? const Center(child: Text("No location selected"))
                    : ListView(
                        children: items
                            .where((item) => item.location == selectedLocation)
                            .map(
                              (item) => ListTile(
                                title: Text(item.name),
                                subtitle: Text("Location: ${item.location}"),
                              ),
                            )
                            .toList(),
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
