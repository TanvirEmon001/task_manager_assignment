import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../services/api_caller.dart';

class VerifyOtpProvider extends ChangeNotifier {
  bool _progressIndicator = false;
  String? _errorMessage;

  bool get progressIndicator => _progressIndicator;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyByOtp(String otp, String userEmail) async {
    bool isSuccess = false;

    _progressIndicator = true;
    notifyListeners();

    String url = "${Urls.recoveryVerifyOtpUrl}/$userEmail/$otp";

    final ApiResponse response = await ApiCaller.getRequest(url: url);

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
      _progressIndicator = false;
      notifyListeners();
    }

    return isSuccess;
  }
}
