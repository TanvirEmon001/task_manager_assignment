import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/add_new_task_provider.dart';
import 'package:task_manager_assignment/data/provider/get_new_task_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});
  static const String name = '/newTaskScreen';

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetNewTaskProvider>().getAllNewTasks();
    context.read<GetNewTaskProvider>().getAllTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    print("Widget build hoitase");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Consumer<GetNewTaskProvider>(
              builder: (context, getNewTaskProvider, _) {
                return SizedBox(
                  height: 90,
                  child: Visibility(
                    visible:
                        getNewTaskProvider.getTaskStatusCountInProgress ==
                        false,
                    replacement: CenteredProgressIndicator(),
                    child: ListView.separated(
                      itemCount: getNewTaskProvider.taskStatusCountList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return TaskCountByStatusCard(
                          title: getNewTaskProvider
                              .taskStatusCountList[index]
                              .status,
                          count: getNewTaskProvider
                              .taskStatusCountList[index]
                              .count,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 4);
                      },
                    ),
                  ),
                );
              },
            ),
            Consumer<GetNewTaskProvider>(
              builder: (context, getNewTaskProvider, _) {
                return Expanded(
                  child: Visibility(
                    visible: getNewTaskProvider.getNewTaskInProgress == false,
                    replacement: CenteredProgressIndicator(),
                    child: ListView.separated(
                      itemCount: getNewTaskProvider.newTaskList.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskModel: getNewTaskProvider.newTaskList[index],
                          refreshParent: () {
                            context.read<GetNewTaskProvider>().getAllNewTasks();
                            context
                                .read<GetNewTaskProvider>()
                                .getAllTaskStatusCount();
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );
  }
}
