import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';
import 'package:task_management/screens/new_task/model/task_model.dart';

class CanceledController extends GetxController {
  // Observable variables
  final RxList<TaskData> canceledTaskList = <TaskData>[].obs;
  final RxBool isCanceledTaskListProgress = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCanceledTaskList();
  }

  Future<void> getCanceledTaskList() async {
    isCanceledTaskListProgress.value = true;

    final NetworkResponse response = await NetworkService.getRequest(
      context: Get.context!,
      url: ApiPath.canceledTaskList,
    );

    if (response.isSuccess) {
      final TaskModel canceledTaskModel =
          TaskModel.fromJson(response.requestResponse);
      canceledTaskList.clear();
      canceledTaskList.addAll(canceledTaskModel.data ?? []);
    } else {
      Fluttertoast.showToast(
        msg: response.errorMessage,
        backgroundColor: AppColors.colorRed,
      );
    }

    isCanceledTaskListProgress.value = false;
  }

  Future<void> deleteCanceledTaskList(String taskId) async {
    isCanceledTaskListProgress.value = true;

    final NetworkResponse response = await NetworkService.getRequest(
      context: Get.context!,
      url: ApiPath.deleteTask(taskId),
    );

    if (response.isSuccess) {
      Fluttertoast.showToast(
        msg: "Task Delete Complete",
        backgroundColor: AppColors.colorGreen,
      );
      await getCanceledTaskList();
    } else {
      Fluttertoast.showToast(
        msg: response.errorMessage,
        backgroundColor: AppColors.colorRed,
      );
    }

    isCanceledTaskListProgress.value = false;
  }

  Future<void> updateCanceledTaskList(String taskId, String status) async {
    isCanceledTaskListProgress.value = true;

    final NetworkResponse response = await NetworkService.getRequest(
      context: Get.context!,
      url: ApiPath.updateTask(taskId, status),
    );

    if (response.isSuccess) {
      Fluttertoast.showToast(
        msg: "Task Update Complete",
        backgroundColor: AppColors.colorGreen,
      );
      await getCanceledTaskList();
    } else {
      Fluttertoast.showToast(
        msg: response.errorMessage,
        backgroundColor: AppColors.colorRed,
      );
    }

    isCanceledTaskListProgress.value = false;
  }
}
