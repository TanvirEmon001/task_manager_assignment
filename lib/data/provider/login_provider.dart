import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../services/api_caller.dart';

class LoginProvider extends ChangeNotifier {
  bool _loginInProgress = false;
  String? _errorMessage;

  bool get loginInProgress => _loginInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    bool isSuccess = false;

    _loginInProgress = true;
    notifyListeners();
    Map<String, dynamic> requestBody = {"email": email, "password": password};
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );
    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel model = UserModel.fromJson(response.responseData['data']);
      String token = response.responseData['token'];

      await AuthController.saveUserData(model, token);
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _loginInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
