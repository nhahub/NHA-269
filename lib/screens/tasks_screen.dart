import 'package:flutter/material.dart';
import '../Widgets/TasksWidgets/progress_overview.dart';
import '../Widgets/TasksWidgets/section_title.dart';
import '../Widgets/TasksWidgets/task_list_widget.dart';
import '../theme/app_colors.dart';
import '../FireBase/task_service.dart';
import '../Widgets/TasksWidgets/task_screen_methods.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskService _taskService = TaskService();
  bool _isInitialLoading = true;
  bool _isReloading = false;
  List<Map<String, dynamic>> _allTasks = [];
  int _completedTasks = 0;
  int _pendingTasks = 0;
  int _overdueTasks = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks(isInitial: true);
  }

  Future<void> _loadTasks({bool isInitial = false}) async {
    await TaskScreenMethods.loadTasks(
      context: context,
      taskService: _taskService,
      isInitial: isInitial,
      onLoadingStateChange: (isInitial, isReloading) {
        setState(() {
          _isInitialLoading = isInitial;
          _isReloading = isReloading;
        });
      },
      onDataLoaded: (tasks, completed, pending, overdue) {
        setState(() {
          _allTasks = tasks;
          _completedTasks = completed;
          _pendingTasks = pending;
          _overdueTasks = overdue;
        });
      },
    );
  }

  Future<void> _toggleTask(String taskId, bool currentStatus) async {
    await TaskScreenMethods.toggleTask(
      context: context,
      taskService: _taskService,
      taskId: taskId,
      currentStatus: currentStatus,
      onSuccess: () => _loadTasks(),
    );
  }

  Future<void> _deleteTask(String taskId, String title) async {
    await TaskScreenMethods.deleteTask(
      context: context,
      taskService: _taskService,
      taskId: taskId,
      title: title,
      onSuccess: () => _loadTasks(),
    );
  }

  void _editTask(Map<String, dynamic> task) {
    TaskScreenMethods.editTask(
      context: context,
      task: task,
      onSuccess: () => _loadTasks(),
    );
  }

  Future<void> _createNewTask() async {
    await TaskScreenMethods.createNewTask(
      context: context,
      onSuccess: () => _loadTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasksList = _allTasks.where((t) => t['done'] == false).toList();
    final completedTasksList = _allTasks.where((t) => t['done'] == true).toList();
    final hasAnyTasks = pendingTasksList.isNotEmpty || completedTasksList.isNotEmpty;

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
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.deepSapphire),
            onPressed: () => _loadTasks(),
          ),
        ],
      ),
      body: _isInitialLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.oceanBlue),
            )
          : Stack(
              children: [
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: _loadTasks,
                    color: AppColors.oceanBlue,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProgressOverview(
                            pendingTasks: _pendingTasks,
                            completedTasks: _completedTasks,
                            overdueTasks: _overdueTasks,
                          ),
                          const SizedBox(height: 20),
                          const SectionTitle(title: 'Pending Tasks'),
                          if (hasAnyTasks)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.swipe_right,
                                    size: 12,
                                    color: AppColors.grey.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Swipe to edit or delete',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.grey.withOpacity(0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                          TaskListWidget(
                            tasks: pendingTasksList,
                            onToggle: _toggleTask,
                            onEdit: _editTask,
                            onDelete: _deleteTask,
                          ),
                          const SizedBox(height: 20),
                          const SectionTitle(title: 'Completed Tasks'),
                          const SizedBox(height: 8),
                          TaskListWidget(
                            tasks: completedTasksList,
                            onToggle: _toggleTask,
                            onEdit: _editTask,
                            onDelete: _deleteTask,
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
                // Subtle loading overlay during reload
                if (_isReloading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.1),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.oceanBlue,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Updating...',
                                style: TextStyle(
                                  color: AppColors.deepSapphire,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTask,
        backgroundColor: AppColors.oceanBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}