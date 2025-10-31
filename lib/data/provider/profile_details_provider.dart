import 'package:flutter/foundation.dart';

import '../../utils/urls.dart';
import '../models/profile_model.dart';
import '../services/api_caller.dart';

class ProfileDetailsProvider extends ChangeNotifier {
  final List<ProfileModel> _profileModel = [];
  bool _progressIndicator = false;

  String? _errorMessage;
  String? _userName;
  String? _email;
  String? _mobile;

  // get methods:
  bool get progressIndicator => _progressIndicator;
  String? get userName => _userName;
  String? get email => _email;
  String? get mobile => _mobile;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchProfileDetails() async {
    bool isSuccess = false;

    _progressIndicator = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.profileDetailsUrl,
    );

    if (response.isSuccess) {
      final decodedJson = response.responseData;

      _profileModel.clear();
      for (Map<String, dynamic> profileJson in decodedJson['data']) {
        ProfileModel profileModel = ProfileModel.fromJson(profileJson);
        _profileModel.add(profileModel);
      }
      _userName = "${_profileModel[0].firstName} ${_profileModel[0].lastName}";
      _email = _profileModel[0].email;
      _mobile = _profileModel[0].mobile;
      _progressIndicator = false;
      isSuccess = true;
      notifyListeners();
    } else {
      _progressIndicator = false;
      notifyListeners();
      _errorMessage = response.errorMessage.toString();
    }

    return isSuccess;

  }


}
