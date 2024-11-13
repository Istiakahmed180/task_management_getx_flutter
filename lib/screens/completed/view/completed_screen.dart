import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_task_card.dart';
import 'package:task_management/common/widgets/not_found.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/new_task/model/task_model.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<TaskData> _completedTaskList = [];
  bool _isCompletedTaskListProgress = false;

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  Future<void> _getCompletedTaskList() async {
    _isCompletedTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.completeTaskList);
    if (response.isSuccess) {
      final TaskModel completedTaskModel =
          TaskModel.fromJson(response.requestResponse);
      _completedTaskList.clear();
      _completedTaskList = completedTaskModel.data ?? [];
      _isCompletedTaskListProgress = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _deleteCompletedTaskList(String taskId) async {
    _isCompletedTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.deleteTask(taskId));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Delete Complete", backgroundColor: AppColors.colorGreen);
      _getCompletedTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isCompletedTaskListProgress = false;
    setState(() {});
  }

  Future<void> _updateCompletedTaskList(String taskId, String status) async {
    _isCompletedTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.updateTask(taskId, status));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Update Complete", backgroundColor: AppColors.colorGreen);
      _getCompletedTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isCompletedTaskListProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBackground(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Visibility(
        visible: !_isCompletedTaskListProgress,
        replacement: const Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.colorGreen,
          ),
        ),
        child: _completedTaskList.isEmpty
            ? const NotFound(title: "Completed Task List Not Found")
            : CommonTaskCard(
                taskList: _completedTaskList,
                textTheme: textTheme,
                onDelete: _deleteCompletedTaskList,
                onUpdate: _updateCompletedTaskList,
              ),
      ),
    ));
  }
}
