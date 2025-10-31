import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/reset_password_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

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
                    'Password should be at least 6 characters and include a number',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // New Password
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(hintText: 'New Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter password';
                      if (value.length < 6)
                        return 'Minimum 6 characters required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm New Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return 'Confirm your password';
                      if (value != _passwordTEController.text)
                        return 'Passwords do not match';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Consumer<ResetPasswordProvider>(
                    builder: (context, resetPasswordProvider, _) {
                      return Visibility(
                        visible: !resetPasswordProvider.progressIndicator,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: FilledButton(
                          onPressed: _onTapResetPasswordButton,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapLoginButton,
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

  void _onTapLoginButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onTapResetPasswordButton() {
    if (_formKey.currentState!.validate()) {
      _recoverResetPassword();
    }
  }

  Future<void> _recoverResetPassword() async {
    final resetPasswordProvider = Provider.of<ResetPasswordProvider>(
      context,
      listen: false,
    );

    final bool isSuccess = await resetPasswordProvider.recoverResetPassword(
      widget.email,
      widget.otp,
      _passwordTEController.text.trim(),
    );

    if (isSuccess) {
      showSnackBarMessage(context, "Password reset successful!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } else {
      showSnackBarMessage(
        context,
        resetPasswordProvider.errorMessage ?? "Failed to reset password",
      );
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
