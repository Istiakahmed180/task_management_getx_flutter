import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_management/common/widgets/app_background.dart';
import 'package:task_management/common/widgets/common_app_bar.dart';
import 'package:task_management/constants/api_path.dart';
import 'package:task_management/constants/app_colors.dart';
import 'package:task_management/network/network_response.dart';
import 'package:task_management/network/network_service.dart';

class CreateNewTaskScreen extends StatefulWidget {
  const CreateNewTaskScreen({super.key});

  @override
  State<CreateNewTaskScreen> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isCreateNewTask = false;
  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
  }

  void _validateForm() {
    isCreateNewTask = formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void clearTextFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CommonAppBar(),
      body: AppBackground(
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                "Add New Task",
                style:
                    textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildNewTaskForm(context, formKey),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom))
            ],
          ),
        ),
      ),
    );
  }

  Form _buildNewTaskForm(context, GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _titleController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(hintText: "Title"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter title";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _descriptionController,
            maxLines: 5,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: "Description",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter description";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isCreateNewTask ? createNewTask : null,
            child: isProgress
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.colorWhite,
                    ),
                  )
                : const Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 30,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> createNewTask() async {
    if (formKey.currentState!.validate()) {
      isProgress = true;
      setState(() {});

      final Map<String, String> requestBody = {
        "title": _titleController.text,
        "description": _descriptionController.text,
        "status": "New"
      };

      final NetworkResponse response = await NetworkService.postRequest(
          context: context,
          url: ApiPath.createNewTask,
          requestBody: requestBody);
      isProgress = false;
      setState(() {});
      if (response.isSuccess) {
        Navigator.pop(context, true);
        clearTextFields();
        Fluttertoast.showToast(
            msg: "Task Create Complete", backgroundColor: AppColors.colorGreen);
      } else {
        Fluttertoast.showToast(
            msg: response.errorMessage, backgroundColor: AppColors.colorRed);
      }
    }
  }
}
