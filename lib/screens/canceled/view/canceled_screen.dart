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

class CanceledScreen extends StatefulWidget {
  const CanceledScreen({super.key});

  @override
  State<CanceledScreen> createState() => _CanceledScreenState();
}

class _CanceledScreenState extends State<CanceledScreen> {
  List<TaskData> _canceledTaskList = [];
  bool _isCanceledTaskListProgress = false;

  @override
  void initState() {
    super.initState();
    _getCanceledTaskList();
  }

  Future<void> _getCanceledTaskList() async {
    _isCanceledTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.canceledTaskList);
    if (response.isSuccess) {
      final TaskModel canceledTaskModel =
          TaskModel.fromJson(response.requestResponse);
      _canceledTaskList.clear();
      _canceledTaskList = canceledTaskModel.data ?? [];
      _isCanceledTaskListProgress = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
  }

  Future<void> _deleteCanceledTaskList(String taskId) async {
    _isCanceledTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.deleteTask(taskId));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Delete Complete", backgroundColor: AppColors.colorGreen);
      _getCanceledTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isCanceledTaskListProgress = false;
    setState(() {});
  }

  Future<void> _updateCanceledTaskList(String taskId, String status) async {
    _isCanceledTaskListProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkService.getRequest(
        context: context, url: ApiPath.updateTask(taskId, status));
    if (response.isSuccess) {
      Fluttertoast.showToast(
          msg: "Task Update Complete", backgroundColor: AppColors.colorGreen);
      _getCanceledTaskList();
    } else {
      Fluttertoast.showToast(
          msg: response.errorMessage, backgroundColor: AppColors.colorRed);
    }
    _isCanceledTaskListProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return AppBackground(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Visibility(
        visible: !_isCanceledTaskListProgress,
        replacement: const Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.colorGreen,
          ),
        ),
        child: _canceledTaskList.isEmpty
            ? const NotFound(title: "Canceled Task List Not Found")
            : CommonTaskCard(
                taskList: _canceledTaskList,
                textTheme: textTheme,
                onDelete: _deleteCanceledTaskList,
                onUpdate: _updateCanceledTaskList,
              ),
      ),
    ));
  }
}
