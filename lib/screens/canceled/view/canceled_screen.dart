import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_task_card.dart';
import 'package:task_management/common/widgets/not_found.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/screens/canceled/controller/canceled_controller.dart';

class CanceledScreen extends StatelessWidget {
  const CanceledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final CanceledController controller = Get.put(CanceledController());

    return AppBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Obx(
          () => Visibility(
            visible: !controller.isCanceledTaskListProgress.value,
            replacement: const Center(
              child: CircularProgressIndicator(
                backgroundColor: AppColors.colorGreen,
              ),
            ),
            child: Obx(
              () => controller.canceledTaskList.isEmpty
                  ? const NotFound(title: "Canceled Task List Not Found")
                  : CommonTaskCard(
                      taskList: controller.canceledTaskList,
                      textTheme: textTheme,
                      onDelete: controller.deleteCanceledTaskList,
                      onUpdate: controller.updateCanceledTaskList,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
