import 'package:task_manager_assignment/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager_assignment/ui/screens/completed_task_screen.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});

  static const String name = '/dashboard';

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {
  int _selectedIndex = 0;
  bool? appBarToggle;

  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CancelledTaskScreen(),
    CompletedTaskScreen(),
  ];

  @override
  void initState() {
    super.initState();
    appBarToggle = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: 'New',
          ),
          NavigationDestination(icon: Icon(Icons.refresh), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
        ],
      ),
    );
  }
}