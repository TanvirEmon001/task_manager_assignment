import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../models/task_model.dart';
import '../services/api_caller.dart';

class CompletedTaskProvider extends ChangeNotifier {
  bool _getCompletedTaskInProgress = false;
  List<TaskModel> _completedTaskList = [];
  String? _errorMessage;

  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;
  List<TaskModel> get completedTaskList => _completedTaskList;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllCompletedTasks() async {
    bool isSuccess = false;

    _getCompletedTaskInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.completedTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage.toString();
    }
    _getCompletedTaskInProgress = false;
    notifyListeners();

    return isSuccess;
  }

}