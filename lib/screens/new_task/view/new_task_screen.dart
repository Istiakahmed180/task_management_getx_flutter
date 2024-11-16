import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_floatin_action_button.dart';
import 'package:task_management/common/widgets/common_task_card.dart';
import 'package:task_management/common/widgets/not_found.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/screens/new_task/controller/new_task_controller.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final NewTaskController controller = Get.put(NewTaskController());

    return Scaffold(
      body: AppBackground(
        child: Obx(
          () => controller.isTaskCountProgress.value ||
                  controller.isNewTaskListProgress.value
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppColors.colorGreen,
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildProgressHeaderSection(textTheme, controller),
                    const SizedBox(height: 10),
                    _buildTaskListSection(textTheme, controller),
                    const SizedBox(height: 12),
                  ],
                ),
        ),
      ),
      floatingActionButton: CommonFloatingActionButton(
        goToTaskCreateScreen: controller.goToTaskCreateScreen,
      ),
    );
  }

  Widget _buildTaskListSection(
      TextTheme textTheme, NewTaskController controller) {
    return Expanded(
      child: Obx(
        () => controller.newTaskList.isEmpty
            ? const NotFound(title: "New Task List Not Found")
            : CommonTaskCard(
                taskList: controller.newTaskList,
                textTheme: textTheme,
                onDelete: controller.deleteNewTaskList,
                onUpdate: controller.updateNewTaskList,
              ),
      ),
    );
  }

  Widget _buildProgressHeaderSection(
      TextTheme textTheme, NewTaskController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controller.taskCountList.map((count) {
            return _buildProgressSection(
              textTheme: textTheme,
              progressCount: count.sum!.toString(),
              progressName: count.sId!,
            );
          }).toList(),
        ),
      ),
    );
  }

  Expanded _buildProgressSection({
    required TextTheme textTheme,
    required String progressCount,
    required String progressName,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(8),
        ),
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
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
