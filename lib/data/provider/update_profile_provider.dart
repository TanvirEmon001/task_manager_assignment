import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../services/api_caller.dart';

class UpdateProfileProvider extends ChangeNotifier {
  final Logger _logger = Logger();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  String? _encodedPhoto;

  bool _updateProfileInProgress = false;
  String? _errorMessage;

  bool get updateProfileInProgress => _updateProfileInProgress;
  String? get errorMessage => _errorMessage;

  XFile? get selectedImage => _selectedImage;

  String? get encodedPhoto => _encodedPhoto;

  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async {
    bool isSuccess = false;

    _updateProfileInProgress = true;
    notifyListeners();

    final Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    _logger.i(
        """
          PP Status before encoded : $_encodedPhoto
          """
    );


    if (_encodedPhoto != null) {
      requestBody['photo'] = _encodedPhoto;
    }

    _logger.i(
        """
          PP Status before response : $_encodedPhoto
          """
    );

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    _updateProfileInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      UserModel model = UserModel(
        id: AuthController.userModel!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: _encodedPhoto ?? AuthController.userModel!.photo,
        password: password,
      );
      await AuthController.updateUserData(model);
      _logger.i(
          """
          PP Status after response : $_encodedPhoto
          """
      );
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage.toString();
    }

    return isSuccess;
  }

  Future<void> pickImage() async {
    XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      List<int> bytes = await _selectedImage!.readAsBytes();
      _encodedPhoto = base64Encode(bytes);
      notifyListeners();
    }
  }


}
