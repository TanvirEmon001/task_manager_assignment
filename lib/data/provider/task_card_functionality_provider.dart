import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../services/api_caller.dart';

class TaskCardFunctionalityProvider extends ChangeNotifier {
  bool _changeStatusInProgress = false;
  bool _deleteInProgress = false;
  String? _errorMessage;

  bool get changeStatusInProgress => _changeStatusInProgress;
  bool get deleteInProgress => _deleteInProgress;
  String? get errorMessage => _errorMessage;


  // task status change method
  Future<bool> changeStatus(String id, String status) async {
    bool isSuccess = false;

    _changeStatusInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.updateTaskStatusUrl(id, status),
    );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
      _changeStatusInProgress = false;
      notifyListeners();
    } else {
      _errorMessage = response.errorMessage.toString();
    }

    return isSuccess;
  }


  // task delete method
  Future<bool> deleteTask(String id) async {
    bool isSuccess = false;

    _deleteInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.deleteTaskUrl(id),
    );
    _deleteInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage.toString();
    }

    return isSuccess;
  }


}