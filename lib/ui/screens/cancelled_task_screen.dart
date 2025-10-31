import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/cancelled_task_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {




  @override
  void initState() {
    super.initState();
    context.read<CancelledTaskProvider>().getAllCancelledTasks();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<CancelledTaskProvider>(
          builder: (context, provider, _){
            return Visibility(
              visible: provider.getCancelledTaskInProgress == false,
              replacement: CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: provider.cancelledTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: provider.cancelledTaskList[index],
                    refreshParent: () {
                      provider.getAllCancelledTasks();
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
