import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';

class MaterialItemCard extends StatelessWidget {
  final String title;
  final String subject;
  final String size;
  final String time;
  final String type;
  final String link;

  const MaterialItemCard({
    super.key,
    required this.title,
    required this.subject,
    required this.size,
    required this.time,
    required this.type,
    required this.link,
  });

  Color get _typeColor {
    switch (type.toLowerCase()) {
      case 'notes':
        return AppColors.teal;
      case 'pdf':
        return AppColors.mintGreen;
      case 'video':
        return AppColors.oceanBlue;
      case 'image':
        return AppColors.grey;
      default:
        return AppColors.black;
    }
  }

  IconData get _typeIcon {
    switch (type.toLowerCase()) {
      case 'notes':
        return Icons.note;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.videocam;
      case 'image':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _openLink() async {
    try {
      final uri = Uri.parse(link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Cannot open URL: $link");
      }
    } catch (e) {
      debugPrint("Failed to open link: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _typeColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon, color: _typeColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.deepSapphire,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subject,
                  style: const TextStyle(color: AppColors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                size,
                style: const TextStyle(
                  color: AppColors.deepSapphire,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              Text(
                time,
                style: const TextStyle(color: AppColors.grey, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 4),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.download_rounded,
                  color: AppColors.oceanBlue,
                  size: 20,
                ),
                tooltip: 'Open in browser',
                onPressed: _openLink,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                tooltip: 'Delete',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
