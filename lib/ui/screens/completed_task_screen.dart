import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/completed_task_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {


  @override
  void initState() {
    super.initState();
    context.read<CompletedTaskProvider>().getAllCompletedTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<CompletedTaskProvider>(
          builder: (context, provider, _) {
            return Visibility(
              visible: provider.getCompletedTaskInProgress == false,
              replacement: CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: provider.completedTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: provider.completedTaskList[index],
                    refreshParent: () {
                      provider.getAllCompletedTasks();
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
              ),
            );
          },
        )
      ),
    );
  }
}
