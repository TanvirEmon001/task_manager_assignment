import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/update_profile_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UpdateProfileProvider _updateProfileProvider = UpdateProfileProvider();


  @override
  void initState() {
    super.initState();
    UserModel user = AuthController.userModel!;

    _emailTEController.text = user.email;
    _firstNameTEController.text = user.firstName;
    _lastNameTEController.text = user.lastName;
    _mobileTEController.text = user.mobile;
    _passwordTEController.text = user.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Update Profile',
                    style: TextTheme.of(context).titleLarge,
                  ),
                  const SizedBox(height: 24),
                  Consumer<UpdateProfileProvider>(
                    builder: (context, provider, _) {
                      return PhotoPickerField(
                        onTap: () {
                          provider.pickImage();
                        },
                        selectedPhoto: provider.selectedImage,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    enabled: false,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: 'First name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: 'Last name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password (Optional)',
                    ),
                    validator: (String? value) {
                      if ((value != null && value.isNotEmpty) &&
                          value.length < 6) {
                        return 'Enter a password more than 6 letters';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<UpdateProfileProvider>(
                    builder: (context, provider, _) {
                    return Visibility(
                        visible: provider.updateProfileInProgress == false,
                        replacement: CenteredProgressIndicator(),
                        child: FilledButton(
                          onPressed: _onTapUpdateButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final bool isSuccess = await _updateProfileProvider.updateProfile(
      email: _emailTEController.text.trim(),
      firstName: _firstNameTEController.text.trim(),
      lastName: _lastNameTEController.text.trim(),
      mobile: _mobileTEController.text.trim(),
      password: _passwordTEController.text.trim(),
    );

    if (isSuccess) {
      _passwordTEController.clear();
      showSnackBarMessage(context, 'Profile has been updated!');
    } else {
      showSnackBarMessage(
        context,
        _updateProfileProvider.errorMessage.toString(),
      );
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
