import 'package:flutter/material.dart';
import '../Widgets/TasksWidgets/progress_overview.dart';
import '../Widgets/TasksWidgets/section_title.dart';
import '../Widgets/TasksWidgets/task_card.dart';
import '../theme/app_colors.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

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
              'Tasks',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.deepSapphire,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your assignments',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.deepSapphire,
            ),
            onPressed: () {
              // TODO: calendar action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressOverview(),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Pending Tasks'),
              const SizedBox(height: 8),
              const _TaskList(pending: true),
              const SizedBox(height: 20),
              const SectionTitle(title: 'Completed Tasks'),
              const SizedBox(height: 8),
              const _TaskList(pending: false),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final bool pending;
  const _TaskList({required this.pending});

  @override
  Widget build(BuildContext context) {
    final tasks = pending
        ? [
            TaskCard(
              title: "Complete Calculus Assignment",
              subtitle: "Chapter 5 exercises 1-20",
              subject: "Mathematics",
              dueText: "Due Today",
              priority: "High",
              priorityColor: Colors.red,
              tagColor: Colors.green,
            ),
            TaskCard(
              title: "Physics Lab Report",
              subtitle: "Wave motion experiment analysis",
              subject: "Physics",
              dueText: "Due Tomorrow",
              priority: "High",
              priorityColor: Colors.red,
              tagColor: Colors.teal,
            ),
            TaskCard(
              title: "Chemistry Practice Problems",
              subtitle: "Organic compounds worksheet",
              subject: "Chemistry",
              dueText: "Due Dec 10",
              priority: "Medium",
              priorityColor: Colors.orange,
              tagColor: Colors.amber,
            ),
            TaskCard(
              title: "English Essay Draft",
              subtitle: "Shakespeare analysis - 1500 words",
              subject: "English",
              dueText: "Due Dec 12",
              priority: "Low",
              priorityColor: Colors.green,
              tagColor: Colors.blue,
            ),
          ]
        : [
            TaskCard(
              title: "Read History Chapter 8",
              subtitle: "",
              subject: "History",
              done: true,
            ),
            TaskCard(
              title: "Biology Diagram Drawing",
              subtitle: "",
              subject: "Biology",
              done: true,
            ),
          ];

    return Column(children: tasks);
  }
}
