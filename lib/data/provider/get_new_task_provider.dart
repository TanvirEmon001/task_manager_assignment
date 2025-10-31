import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../models/task_model.dart';
import '../models/task_status_count_model.dart';
import '../services/api_caller.dart';

class GetNewTaskProvider extends ChangeNotifier {
  bool _getNewTaskInProgress = false;
  bool _getTaskStatusCountInProgress = false;
  String? _errorMessage;
  List<TaskModel> _newTaskList = [];
  List<TaskStatusCountModel> _taskStatusCountList = [];

  bool get getNewTaskInProgress => _getNewTaskInProgress;
  bool get getTaskStatusCountInProgress => _getTaskStatusCountInProgress;
  String? get errorMessage => _errorMessage;
  List<TaskModel> get newTaskList => _newTaskList;
  List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;



  Future<bool> getAllTaskStatusCount() async {
    bool isSuccess = false;
    _getTaskStatusCountInProgress = true;
    notifyListeners();
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.taskStatusCountUrl,
    );
    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage.toString();
    }
    _getTaskStatusCountInProgress = false;
    notifyListeners();

    return isSuccess;
  }



  Future<bool> getAllNewTasks() async {
    bool isSuccess = false;
    _getNewTaskInProgress = true;
    notifyListeners();


    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.newTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage.toString();
    }
    _getNewTaskInProgress = false;
    notifyListeners();


    return isSuccess;

  }


}