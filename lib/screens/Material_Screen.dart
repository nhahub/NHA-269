import 'package:flutter/material.dart';
import '../Widgets/MaterialWidgets/material_filter_bar.dart';
import '../Widgets/MaterialWidgets/material_item_card.dart';
import '../Widgets/MaterialWidgets/material_search_bar.dart';
import '../Widgets/MaterialWidgets/material_storage_card.dart';
import '../theme/app_colors.dart';
import 'package:learnflow/Widgets/MaterialWidgets/file_upload_dialog.dart';
import 'package:learnflow/Firebase/material_service.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  String selectedFilter = "All";
  final MaterialService _materialService = MaterialService();

  late Future<List<Map<String, dynamic>>> _materialsFuture;

  @override
  void initState() {
    super.initState();
    _materialsFuture = _materialService.getUserMaterials();
  }

  void _refreshMaterials() {
    setState(() {
      _materialsFuture = _materialService.getUserMaterials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightGrey,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              MaterialSearchBar(onChanged: (value) {}),
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

              // 🔥 Real-time materials from Firestore
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _materialsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  final materials = snapshot.data ?? [];

                  // Filter by type
                  final filteredMaterials = selectedFilter == "All"
                      ? materials
                      : materials
                            .where(
                              (m) =>
                                  m["type"]?.toString().toLowerCase() ==
                                  _normalizeFilter(selectedFilter),
                            )
                            .toList();

                  if (filteredMaterials.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "No materials uploaded yet.",
                        style: TextStyle(color: AppColors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return Column(
                    children: filteredMaterials.map((item) {
                      return MaterialItemCard(
                        title: item["name"] ?? "Untitled",
                        subject: item["subject"] ?? "Unknown Subject",
                        size: _formatFileSize(item["size"]),
                        time: item["uploadedAt"] != null
                            ? _formatTimeDifference(item["uploadedAt"])
                            : "Unknown",
                        type: item["type"] ?? "Untitled",
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.oceanBlue,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const FileUploadDialog(),
          );
          _refreshMaterials();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatTimeDifference(DateTime uploadedAt) {
    final diff = DateTime.now().difference(uploadedAt);
    if (diff.inDays >= 1) return "${diff.inDays} day(s) ago";
    if (diff.inHours >= 1) return "${diff.inHours} hour(s) ago";
    if (diff.inMinutes >= 1) return "${diff.inMinutes} min(s) ago";
    return "Just now";
  }

  String _formatFileSize(dynamic sizeInBytes) {
    if (sizeInBytes == null) return "—";

    double size = sizeInBytes.toDouble();

    if (size < 1024) {
      return "${size.toStringAsFixed(1)} B";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(1)} KB";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(1)} MB";
    } else {
      return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }

  String _normalizeFilter(String filter) {
    switch (filter.toLowerCase()) {
      case "notes":
        return "notes";
      case "pdfs":
        return "pdf";
      case "videos":
        return "video";
      case "images":
        return "image";
      default:
        return filter.toLowerCase();
    }
  }
}
