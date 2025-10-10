import 'package:flutter/material.dart';

import '../Widgets/MaterialWidgets/material_filter_bar.dart';
import '../Widgets/MaterialWidgets/material_item_card.dart';
import '../Widgets/MaterialWidgets/material_search_bar.dart';
import '../Widgets/MaterialWidgets/material_storage_card.dart';


class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({Key? key}) : super(key: key);

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> materials = [
    {
      "title": "Calculus Notes - Chapter 5",
      "type": "Notes",
      "subject": "Mathematics",
      "size": "2.4 MB",
      "time": "2 days ago",
      "color": Colors.red.shade100,
      "icon": Icons.note,
    },
    {
      "title": "Physics Lab Recording",
      "type": "Videos",
      "subject": "Physics",
      "size": "45.2 MB",
      "time": "1 week ago",
      "color": Colors.blue.shade100,
      "icon": Icons.videocam,
    },
    {
      "title": "Chemistry Formulas",
      "type": "PDFs",
      "subject": "Chemistry",
      "size": "892 KB",
      "time": "3 days ago",
      "color": Colors.green.shade100,
      "icon": Icons.picture_as_pdf,
    },
    {
      "title": "History Timeline",
      "type": "Notes",
      "subject": "History",
      "size": "1.8 MB",
      "time": "5 days ago",
      "color": Colors.red.shade100,
      "icon": Icons.note,
    },
    {
      "title": "Biology Diagrams",
      "type": "Images",
      "subject": "Biology",
      "size": "3.2 MB",
      "time": "1 week ago",
      "color": Colors.green.shade100,
      "icon": Icons.image,
    },
    {
      "title": "English Literature Notes",
      "type": "Notes",
      "subject": "English",
      "size": "4.1 MB",
      "time": "1 week ago",
      "color": Colors.red.shade100,
      "icon": Icons.note,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMaterials = selectedFilter == "All"
        ? materials
        : materials.where((m) => m["type"] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Materials",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Access your study resources",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MaterialSearchBar(
              onChanged: (value) {
              },
            ),
            const SizedBox(height: 16),
            MaterialFilterBar(
              selected: selectedFilter,
              onFilterChanged: (filter) {
                setState(() => selectedFilter = filter);
              },
            ),
            const SizedBox(height: 16),
            const MaterialStorageCard(
              usedStorage: "156.8 MB",
              totalStorage: "2 GB",
              filesCount: 6,
              progress: 0.08,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMaterials.length,
                itemBuilder: (context, index) {
                  final item = filteredMaterials[index];
                  return MaterialItemCard(
                    title: item["title"],
                    subject: item["subject"],
                    size: item["size"],
                    time: item["time"],
                    color: item["color"],
                    icon: item["icon"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}