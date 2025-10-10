import 'package:flutter/material.dart';
import '../Widgets/SettingsWidgets/AboutSection.dart';
import '../Widgets/SettingsWidgets/AccountSection.dart';
import '../Widgets/SettingsWidgets/DataStorageSection.dart';
import '../Widgets/SettingsWidgets/PreferencesSection.dart';
import '../Widgets/SettingsWidgets/SectionTitle.dart';
import '../Widgets/SettingsWidgets/SignOut.dart';
import '../Widgets/SettingsWidgets/StorageUsageSection.dart';
import '../Widgets/SettingsWidgets/SupportSection.dart';
import '../Widgets/SettingsWidgets/UserCard.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey,
        elevation: 0,
        toolbarHeight: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.deepSapphire,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Customize your experience',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUserCard(),
              const SizedBox(height: 28),

              buildSectionTitle('Account'),
              const SizedBox(height: 12),
              buildAccountSection(),
              const SizedBox(height: 28),

              buildSectionTitle('Preferences'),
              const SizedBox(height: 12),
              buildPreferencesSection(),
              const SizedBox(height: 28),

              buildSectionTitle('Data & Storage'),
              const SizedBox(height: 12),
              buildDataStorageSection(),
              const SizedBox(height: 28),

              buildSectionTitle('Support'),
              const SizedBox(height: 12),
              buildSupportSection(),
              const SizedBox(height: 28),

              buildSectionTitle('Storage Usage'),
              const SizedBox(height: 12),
              buildStorageUsageSection(),
              const SizedBox(height: 28),

              buildAboutSection(),
              const SizedBox(height: 28),

              buildSignOutButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
