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

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<TaskData> _progressTaskList = [];
  bool _isProgressTaskListProgress = false;

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  Future<void> _getProgressTaskList() async {
    _isProgressTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.progressTaskList);
    if (response.isSuccess) {
      final TaskModel progressTaskModel =
          TaskModel.fromJson(response.requestResponse);
      _progressTaskList.clear();
      _progressTaskList = progressTaskModel.data ?? [];
      _isProgressTaskListProgress = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _deleteProgressTaskList(String taskId) async {
    _isProgressTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.deleteTask(taskId));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Delete Complete", backgroundColor: AppColors.colorGreen);
      _getProgressTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isProgressTaskListProgress = false;
    setState(() {});
  }

  Future<void> _updateProgressTaskList(String taskId, String status) async {
    _isProgressTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.updateTask(taskId, status));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Update Complete", backgroundColor: AppColors.colorGreen);
      _getProgressTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isProgressTaskListProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBackground(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Visibility(
        visible: !_isProgressTaskListProgress,
        replacement: const Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.colorGreen,
          ),
        ),
        child: _progressTaskList.isEmpty
            ? const NotFound(title: "Progress Task List Not Found")
            : CommonTaskCard(
                taskList: _progressTaskList,
                textTheme: textTheme,
                onDelete: _deleteProgressTaskList,
                onUpdate: _updateProgressTaskList,
              ),
      ),
    ));
  }
}
