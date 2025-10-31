import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../models/task_model.dart';
import '../services/api_caller.dart';

class ProgressTaskProvider extends ChangeNotifier {
  bool _getProgressTaskInProgress = false;
  List<TaskModel> _progressTaskList = [];
  String? _errorMessage;

  bool get getProgressTaskInProgress => _getProgressTaskInProgress;
  List<TaskModel> get progressTaskList => _progressTaskList;
  String? get errorMessage => _errorMessage;


  Future<bool> getAllProgressTasks() async {
    bool isSuccess = false;

    _getProgressTaskInProgress = true;
    notifyListeners();
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.progressTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage.toString();
    }
    _getProgressTaskInProgress = false;
    notifyListeners();

    return isSuccess;
  }


}