import 'package:task_manager_assignment/utils/core_paths.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTasks();
  }

  Future<void> _getAllProgressTasks() async {
    _getCancelledTaskInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.cancelledTaskListUrl,
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
    _getCancelledTaskInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getCancelledTaskInProgress == false,
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
