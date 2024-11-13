import 'package:flutter/material.dart';
import 'package:task_management/common/widgets/common_app_bar.dart';
import 'package:task_management/common/widgets/exit_confirmation_alert_dialog.dart';
import 'package:task_management/screens/canceled/view/canceled_screen.dart';
import 'package:task_management/screens/completed/view/completed_screen.dart';
import 'package:task_management/screens/new_task/view/new_task_screen.dart';
import 'package:task_management/screens/progress/view/progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final pages = [
    const NewTaskScreen(),
    const CompletedScreen(),
    const CanceledScreen(),
    const ProgressScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _showExitConfirmationAlertDialog(context);
      },
      child: Scaffold(
        appBar: const CommonAppBar(),
        bottomNavigationBar: _buildNavigationBar(),
        body: pages[currentIndex],
      ),
    );
  }

  NavigationBar _buildNavigationBar() {
    return NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedIndex: currentIndex,
        destinations: const [
          NavigationDestination(
              selectedIcon: Icon(Icons.task_outlined),
              icon: Icon(Icons.task),
              label: "New Task"),
          NavigationDestination(
              selectedIcon: Icon(Icons.task_outlined),
              icon: Icon(Icons.task),
              label: "Completed"),
          NavigationDestination(
              selectedIcon: Icon(Icons.task_outlined),
              icon: Icon(Icons.task),
              label: "Canceled"),
          NavigationDestination(
              selectedIcon: Icon(Icons.task_outlined),
              icon: Icon(Icons.task),
              label: "Progress")
        ]);
  }

  Future<bool> _showExitConfirmationAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => const ExitConfirmationAlertDialog(),
    ).then((value) => value ?? false);
  }
}
