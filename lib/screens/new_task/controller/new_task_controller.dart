import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/new_task/model/task_count_model.dart';
import 'package:task_management/screens/new_task/model/task_model.dart';

class NewTaskController extends GetxController {
  final RxList<TaskData> newTaskList = <TaskData>[].obs;
  final RxList<TaskCountData> taskCountList = <TaskCountData>[].obs;
  final RxBool isNewTaskListProgress = false.obs;
  final RxBool isTaskCountProgress = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNewTaskList();
    getTaskCount();
  }

  Future<void> getNewTaskList() async {
    isNewTaskListProgress.value = true;
    final NetworkResponse response = await NetworkService.getRequest(
      context: Get.context!,
      url: ApiPath.newTaskList,
    );
    isNewTaskListProgress.value = false;

    if (response.isSuccess) {
      final TaskModel newTaskModel =
          TaskModel.fromJson(response.requestResponse);
      newTaskList.value = newTaskModel.data ?? [];
    } else {
      Fluttertoast.showToast(
        msg: response.errorMessage,
        backgroundColor: AppColors.colorRed,
      );
    }
  }

  Future<void> getTaskCount() async {
    isTaskCountProgress.value = true;
    final NetworkResponse response = await NetworkService.getRequest(
      context: Get.context!,
      url: ApiPath.taskCount,
    );
    isTaskCountProgress.value = false;

    if (response.isSuccess) {
      final TaskCountModel taskCountModel =
          TaskCountModel.fromJson(response.requestResponse);
      taskCountList.value = taskCountModel.data ?? [];
    } else {
      Fluttertoast.showToast(
        msg: response.errorMessage,
        backgroundColor: AppColors.colorRed,
      );
    }
  }

  Future<void> deleteNewTaskList(String taskId) async {
    isNewTaskListProgress.value = true;
    final NetworkResponse response = await NetworkService.getRequest(
      context: Get.context!,
      url: ApiPath.deleteTask(taskId),
    );
    isNewTaskListProgress.value = false;

    if (response.isSuccess) {
      Fluttertoast.showToast(
        msg: "Task Delete Complete",
        backgroundColor: AppColors.colorGreen,
      );
      await getNewTaskList();
      await getTaskCount();
    } else {
      Fluttertoast.showToast(
        msg: response.errorMessage,
        backgroundColor: AppColors.colorRed,
      );
    }
  }

  Future<void> updateNewTaskList(String taskId, String status) async {
    isNewTaskListProgress.value = true;
    final NetworkResponse response = await NetworkService.getRequest(
      context: Get.context!,
      url: ApiPath.updateTask(taskId, status),
    );
    isNewTaskListProgress.value = false;

    if (response.isSuccess) {
      Fluttertoast.showToast(
        msg: "Task Update Complete",
        backgroundColor: AppColors.colorGreen,
      );
      await getNewTaskList();
      await getTaskCount();
    } else {
      Fluttertoast.showToast(
        msg: response.errorMessage,
        backgroundColor: AppColors.colorRed,
      );
    }
  }

  Future<void> goToTaskCreateScreen() async {
    final result = await Get.toNamed(Routes.createNewTask);
    if (result == true) {
      await getNewTaskList();
      await getTaskCount();
    }
  }
}
