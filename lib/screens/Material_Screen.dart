import 'package:flutter/material.dart';
import '../Widgets/MaterialWidgets/material_filter_bar.dart';
import '../Widgets/MaterialWidgets/material_item_card.dart';
import '../Widgets/MaterialWidgets/material_search_bar.dart';
import '../Widgets/MaterialWidgets/material_storage_card.dart';
import '../theme/app_colors.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

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
      "color": AppColors.teal,
      "icon": Icons.note,
    },
    {
      "title": "Physics Lab Recording",
      "type": "Videos",
      "subject": "Physics",
      "size": "45.2 MB",
      "time": "1 week ago",
      "color": AppColors.oceanBlue,
      "icon": Icons.videocam,
    },
    {
      "title": "Chemistry Formulas",
      "type": "PDFs",
      "subject": "Chemistry",
      "size": "892 KB",
      "time": "3 days ago",
      "color": AppColors.mintGreen,
      "icon": Icons.picture_as_pdf,
    },
    {
      "title": "History Timeline",
      "type": "Notes",
      "subject": "History",
      "size": "1.8 MB",
      "time": "5 days ago",
      "color": AppColors.teal,
      "icon": Icons.note,
    },
    {
      "title": "Biology Diagrams",
      "type": "Images",
      "subject": "Biology",
      "size": "3.2 MB",
      "time": "1 week ago",
      "color": AppColors.mintGreen,
      "icon": Icons.image,
    },
    {
      "title": "English Literature Notes",
      "type": "Notes",
      "subject": "English",
      "size": "4.1 MB",
      "time": "1 week ago",
      "color": AppColors.teal,
      "icon": Icons.note,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMaterials = selectedFilter == "All"
        ? materials
        : materials.where((m) => m["type"] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightGrey,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Materials",
              style: TextStyle(
                color: AppColors.deepSapphire,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Access your study resources",
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search bar
              MaterialSearchBar(
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Filter bar
              MaterialFilterBar(
                selected: selectedFilter,
                onFilterChanged: (filter) {
                  setState(() => selectedFilter = filter);
                },
              ),
              const SizedBox(height: 16),

              // Storage card
              const MaterialStorageCard(
                usedStorage: "156.8 MB",
                totalStorage: "2 GB",
                filesCount: 6,
                progress: 0.08,
              ),
              const SizedBox(height: 16),

              // Material items list
              Column(
                children: filteredMaterials.map((item) {
                  return MaterialItemCard(
                    title: item["title"],
                    subject: item["subject"],
                    size: item["size"],
                    time: item["time"],
                    color: item["color"],
                    icon: item["icon"],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
