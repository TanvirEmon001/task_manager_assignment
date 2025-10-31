import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../models/task_model.dart';
import '../services/api_caller.dart';

class CancelledTaskProvider extends ChangeNotifier {
  bool _getCancelledTaskInProgress = false;
  List<TaskModel> _cancelledTaskList = [];
  String? _errorMessage;

  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress;
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllCancelledTasks() async {
    bool isSuccess = false;

    _getCancelledTaskInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.cancelledTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage.toString();
    }
    _getCancelledTaskInProgress = false;
    notifyListeners();

    return isSuccess;
  }


}
