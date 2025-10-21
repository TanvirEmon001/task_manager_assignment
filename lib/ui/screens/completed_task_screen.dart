import 'package:task_manager_assignment/utils/core_paths.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTasks();
  }

  Future<void> _getAllProgressTasks() async {
    _getProgressTaskInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.completedTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getProgressTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getProgressTaskInProgress == false,
          replacement: CenteredProgressIndicator(),
          child: ListView.separated(
            itemCount: _progressTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _progressTaskList[index],
                refreshParent: () {
                  _getAllProgressTasks();
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 8);
            },
          ),
        ),
      ),
    );
  }
}
