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
  String _searchQuery = "";

  final MaterialService _materialService = MaterialService();

  late Future<List<Map<String, dynamic>>> _materialsFuture;
  late Future<Map<String, dynamic>> _storageSummaryFuture;

  @override
  void initState() {
    super.initState();
    _materialsFuture = _materialService.getUserMaterials();
    _storageSummaryFuture = _fetchStorageSummary();
  }

  Future<Map<String, dynamic>> _fetchStorageSummary() async {
    final totalSize = await _materialService.getTotalStorageUsed();
    final totalFiles = await _materialService.getTotalFilesCount();
    return {"totalSize": totalSize, "totalFiles": totalFiles};
  }

  void _refreshMaterials() {
    setState(() {
      _materialsFuture = _materialService.getUserMaterials();
      _storageSummaryFuture = _fetchStorageSummary();
    });
  }

  String _formatFileSize(double size) {
    if (size < 1024) return "${size.toStringAsFixed(1)} B";
    if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(1)} KB";
    if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(1)} MB";
    }
    return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
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
              MaterialSearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
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

              // 🔥 MaterialStorageCard with dynamic values
              FutureBuilder<Map<String, dynamic>>(
                future: _storageSummaryFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final totalSizeDynamic = snapshot.data!["totalSize"];
                  final totalFilesDynamic = snapshot.data!["totalFiles"];

                  final totalSize = totalSizeDynamic is int
                      ? totalSizeDynamic.toDouble()
                      : totalSizeDynamic as double;

                  final totalFiles = totalFilesDynamic as int;

                  return MaterialStorageCard(
                    usedStorage: totalSize,
                    totalStorage: 0.1, // keep static total limit in GB
                    filesCount: totalFiles,
                  );
                },
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

                  final filteredMaterials = materials.where((m) {
                    // Map filter name to type
                    String typeFilter;
                    switch (selectedFilter.toLowerCase()) {
                      case "notes":
                        typeFilter = "notes";
                        break;
                      case "pdfs":
                        typeFilter = "pdf";
                        break;
                      case "videos":
                        typeFilter = "video";
                        break;
                      case "images":
                        typeFilter = "image";
                        break;
                      default:
                        typeFilter = ""; // All
                    }

                    // Filter by type
                    final matchesType =
                        selectedFilter.toLowerCase() == "all" ||
                        m["type"].toString().toLowerCase() == typeFilter;

                    // Filter by search query (name OR subject)
                    final name = (m["name"] ?? "").toString().toLowerCase();
                    final subject = (m["subject"] ?? "")
                        .toString()
                        .toLowerCase();
                    final matchesSearch =
                        _searchQuery.isEmpty ||
                        name.contains(_searchQuery) ||
                        subject.contains(_searchQuery);

                    return matchesType && matchesSearch;
                  }).toList();

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
                        size: _formatFileSize((item["size"] ?? 0).toDouble()),
                        time: item["uploadedAt"] != null
                            ? _formatTimeDifference(item["uploadedAt"])
                            : "Unknown",
                        type: item["type"] ?? "Unknown",
                        link: item["link"],
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
}
