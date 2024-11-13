import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/screens/new_task/model/task_model.dart';

class CommonTaskCard extends StatefulWidget {
  const CommonTaskCard({
    super.key,
    required this.taskList,
    required this.textTheme,
    required this.onDelete,
    required this.onUpdate,
  });

  final List<TaskData> taskList;
  final TextTheme textTheme;
  final Function(String taskId) onDelete;
  final Function(String taskId, String status) onUpdate;

  @override
  State<CommonTaskCard> createState() => _CommonTaskCardState();
}

class _CommonTaskCardState extends State<CommonTaskCard> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        final TaskData task = widget.taskList[index];

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColors.colorWhite,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${task.title!.isNotEmpty ? task.title : "N/A"}",
                  style: widget.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${task.description!.isNotEmpty ? task.description : "N/A"}",
                  style: widget.textTheme.titleSmall?.copyWith(
                    color: AppColors.colorLightGray,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Date : ${DateFormat("dd-MMM-yyyy").format(DateTime.parse(task.createdDate!))}",
                  style: widget.textTheme.titleSmall?.copyWith(
                    color: AppColors.colorDarkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                          color: AppColors.colorBlue,
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        "${task.status!.isNotEmpty ? task.status : "N/A"}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.colorWhite),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus = task.status;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Edit Status'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    'New',
                                    'Completed',
                                    'Canceled',
                                    'Progress'
                                  ].map((e) {
                                    return ListTile(
                                      onTap: () {
                                        setState(() {
                                          _selectedStatus = e;
                                        });
                                        widget.onUpdate(
                                            task.sId!, _selectedStatus!);
                                        Navigator.pop(context);
                                      },
                                      title: Text(e),
                                      selected: _selectedStatus == e,
                                      trailing: _selectedStatus == e
                                          ? const Icon(Icons.check)
                                          : null,
                                    );
                                  }).toList(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit_off_outlined,
                            color: AppColors.colorGreen,
                          ),
                        ),
                        IconButton(
                          onPressed: () => widget.onDelete(task.sId!),
                          icon: const Icon(
                            Icons.delete_forever_sharp,
                            color: AppColors.colorRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: widget.taskList.length,
    );
  }
}
