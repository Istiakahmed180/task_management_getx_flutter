import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_floatin_action_button.dart';
import 'package:task_management/common/widgets/common_task_card.dart';
import 'package:task_management/common/widgets/not_found.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/new_task/model/task_count_model.dart';
import 'package:task_management/screens/new_task/model/task_model.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  List<TaskData> _newTaskList = [];
  List<TaskCountData> _taskCountList = [];
  bool _isNewTaskListProgress = false;
  bool _isTaskCountProgress = false;

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskCount();
  }

  Future<void> _getNewTaskList() async {
    setState(() {
      _isNewTaskListProgress = true;
    });
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.newTaskList);
    setState(() {
      _isNewTaskListProgress = false;
    });
    if (response.isSuccess) {
      final TaskModel newTaskModel =
          TaskModel.fromJson(response.requestResponse);
      setState(() {
        _newTaskList = newTaskModel.data ?? [];
      });
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _getTaskCount() async {
    setState(() {
      _isTaskCountProgress = true;
    });
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.taskCount);
    setState(() {
      _isTaskCountProgress = false;
    });
    if (response.isSuccess) {
      final TaskCountModel taskCountModel =
          TaskCountModel.fromJson(response.requestResponse);
      setState(() {
        _taskCountList = taskCountModel.data ?? [];
      });
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _deleteNewTaskList(String taskId) async {
    setState(() {
      _isNewTaskListProgress = true;
    });
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.deleteTask(taskId));
    setState(() {
      _isNewTaskListProgress = false;
    });
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Delete Complete", backgroundColor: AppColors.colorGreen);
      _getNewTaskList();
      _getTaskCount();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _updateNewTaskList(String taskId, String status) async {
    setState(() {
      _isNewTaskListProgress = true;
    });
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.updateTask(taskId, status));
    setState(() {
      _isNewTaskListProgress = false;
    });
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Update Complete", backgroundColor: AppColors.colorGreen);
      _getNewTaskList();
      _getTaskCount();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _goToTaskCreateScreen() async {
    final result = await Navigator.pushNamed(context, Routes.createNewTask);
    if (result == true) {
      _getNewTaskList();
      _getTaskCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: AppBackground(
        child: _isTaskCountProgress || _isNewTaskListProgress
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.colorGreen,
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  _buildProgressHeaderSection(textTheme),
                  const SizedBox(height: 10),
                  _buildTaskListSection(textTheme),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
      ),
      floatingActionButton: CommonFloatingActionButton(
        goToTaskCreateScreen: _goToTaskCreateScreen,
      ),
    );
  }

  Widget _buildTaskListSection(TextTheme textTheme) {
    return Expanded(
      child: _newTaskList.isEmpty
          ? const NotFound(title: "New Task List Not Found")
          : CommonTaskCard(
              taskList: _newTaskList,
              textTheme: textTheme,
              onDelete: _deleteNewTaskList,
              onUpdate: _updateNewTaskList,
            ),
    );
  }

  Widget _buildProgressHeaderSection(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _taskCountList.map((count) {
          return _buildProgressSection(
              textTheme: textTheme,
              progressCount: count.sum!.toString(),
              progressName: count.sId!);
        }).toList(),
      ),
    );
  }

  Expanded _buildProgressSection(
      {required TextTheme textTheme,
      required String progressCount,
      required String progressName}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              progressCount,
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              progressName,
              style: textTheme.titleSmall?.copyWith(
                  color: AppColors.colorLightGray,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
