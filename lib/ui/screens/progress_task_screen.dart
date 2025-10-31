import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/progress_task_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {


  @override
  void initState() {
    super.initState();
    context.read<ProgressTaskProvider>().getAllProgressTasks();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProgressTaskProvider>(
              builder: (context, provider, _){
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Visibility(
                      visible: provider.getProgressTaskInProgress == false,
                      replacement: CenteredProgressIndicator(),
                      child: ListView.separated(
                        itemCount: provider.progressTaskList.length,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskModel: provider.progressTaskList[index],
                            refreshParent: () {
                              context.read<ProgressTaskProvider>().getAllProgressTasks();
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8);
                        },
                      ),
                    )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
