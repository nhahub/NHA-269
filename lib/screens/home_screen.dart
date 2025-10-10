import 'package:flutter/material.dart';
import '../Widgets/HomeWidgets/buildFeatureCard.dart';
import '../Widgets/HomeWidgets/buildOverviewItem.dart';
import '../Widgets/HomeWidgets/buildScheduleCard.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.lightGrey,
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepSapphire,
                  ),
                  children: [
                    TextSpan(text: 'Welcome back, '),
                    TextSpan(
                      text: 'StudentName!',
                      style: TextStyle(color: AppColors.oceanBlue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Ready to learn something new?',
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.notifications_none),
            color: AppColors.deepSapphire,
          ),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.person),
            color: AppColors.deepSapphire,
          ),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.more_vert),
            color: AppColors.deepSapphire,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Overview',
                      style: TextStyle(
                        color: AppColors.deepSapphire,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildOverviewItem(
                      icon: Icons.timer,
                      label: 'Next Class',
                      value: 'Math - 2:30 PM',
                      color: AppColors.teal,
                    ),
                    const SizedBox(height: 12),
                    buildOverviewItem(
                      icon: Icons.task,
                      label: 'Pending Tasks',
                      value: '5 assignments',
                      color: AppColors.oceanBlue,
                    ),
                    const SizedBox(height: 12),
                    buildOverviewItem(
                      icon: Icons.timeline_sharp,
                      label: 'Study Streak',
                      value: '7 days',
                      color: AppColors.mintGreen,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Main Features',
                style: TextStyle(
                  color: AppColors.deepSapphire,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildFeatureCard(
                    icon: Icons.calendar_month,
                    title: 'Timetable',
                    subtitle: 'Manage your schedule',
                    color: AppColors.oceanBlue,
                    onTap: () {
                      Navigator.pushNamed(context, '/timetable');
                    },
                  ),
                  buildFeatureCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Materials',
                    subtitle: 'Access study resources',
                    color: AppColors.teal,
                    onTap: () {},
                  ),
                  buildFeatureCard(
                    icon: Icons.check_circle_outline,
                    title: 'Tasks',
                    subtitle: 'Track assignments',
                    color: AppColors.mintGreen,
                    onTap: () {
                      Navigator.pushNamed(context, '/tasks');
                    },
                  ),
                  buildFeatureCard(
                    icon: Icons.center_focus_strong,
                    title: 'Focus',
                    subtitle: 'Pomodoro timer',
                    color: AppColors.deepSapphire,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Schedule",
                          style: TextStyle(
                            color: AppColors.deepSapphire,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/timetable');
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(
                              color: AppColors.oceanBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    buildScheduleCard(
                      subject: 'Mathematics',
                      time: '2:30 PM - 4:00 PM',
                      color: AppColors.oceanBlue,
                    ),
                    const SizedBox(height: 10),
                    buildScheduleCard(
                      subject: 'Physics Lab',
                      time: '4:30 PM - 6:00 PM',
                      color: AppColors.teal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
