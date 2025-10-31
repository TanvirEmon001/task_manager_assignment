import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../services/api_caller.dart';

class AddNewTaskProvider extends ChangeNotifier {
  bool _addNewTaskInProgress = false;
  String? _errorMessage;

  bool get addNewTaskInProgress => _addNewTaskInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;

    _addNewTaskInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New",
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    _addNewTaskInProgress = false;
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
