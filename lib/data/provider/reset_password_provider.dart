import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../services/api_caller.dart';

class ResetPasswordProvider extends ChangeNotifier {
  bool _progressIndicator = false;
  String? _errorMessage;

  bool get progressIndicator => _progressIndicator;
  String? get errorMessage => _errorMessage;


  Future<bool> recoverResetPassword(String email, String otp, String password) async {
    bool isSuccess = false;

    _progressIndicator = true;
    notifyListeners();


    Map<String, dynamic> body = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: body,
    );

    _progressIndicator = false;
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