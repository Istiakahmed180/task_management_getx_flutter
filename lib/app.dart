import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/config/routes/routes.dart';
import 'package:task_management/config/routes/routes_handler.dart';
import 'package:task_management/config/theme/theme.dart';

class TaskManagement extends StatelessWidget {
  const TaskManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(context),
      initialRoute: Routes.splash,
      routes: routesHandler(),
    );
  }
}
