import 'package:task_manager_assignment/utils/core_paths.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final int otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _progressIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 82),
                  Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Password should be more than 6 letters and combination of numbers',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'New Password'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _onTapResetPasswordButton,
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignUpButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (predicate) => false,
    );
  }

  void _onTapResetPasswordButton() {
    // Validate before calling API
    if (_validatePasswords()) {
      _recoverResetPassword();
    }
  }

  bool _validatePasswords() {
    String password = _passwordTEController.text.trim();
    String confirmPassword = _confirmPasswordTEController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      showSnackBarMessage(context, "Please fill both password fields");
      return false;
    }

    if (password.length < 6) {
      showSnackBarMessage(context, "Password must be at least 6 characters long");
      return false;
    }

    if (password != confirmPassword) {
      showSnackBarMessage(context, "Passwords do not match");
      return false;
    }

    return true;
  }

  Future<void> _recoverResetPassword() async {
    setState(() {
      _progressIndicator = true;
    });

    String password = _passwordTEController.text.trim();

    Map<String, dynamic> body = {
      "email": widget.email,
      "OTP": widget.otp.toString(),
      "password": password,
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: body,
    );

    setState(() {
      _progressIndicator = false;
    });

    if (response.isSuccess) {
      showSnackBarMessage(context, "Password reset successful!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
