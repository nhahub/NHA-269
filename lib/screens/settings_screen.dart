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
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Customize your experience',
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUserCard(),
              const SizedBox(height: 20),
              buildSectionTitle('Account'),
              const SizedBox(height: 8),
              buildAccountSection(),
              const SizedBox(height: 20),
              buildSectionTitle('Preferences'),
              const SizedBox(height: 8),
              buildPreferencesSection(),
              const SizedBox(height: 20),
              buildSectionTitle('Data & Storage'),
              const SizedBox(height: 8),
              buildDataStorageSection(),
              const SizedBox(height: 20),
              buildSectionTitle('Support'),
              const SizedBox(height: 8),
              buildSupportSection(),
              const SizedBox(height: 20),
              buildSectionTitle('Storage Usage'),
              const SizedBox(height: 8),
              buildStorageUsageSection(),
              const SizedBox(height: 20),
              buildAboutSection(),
              const SizedBox(height: 20),
              buildSignOutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}