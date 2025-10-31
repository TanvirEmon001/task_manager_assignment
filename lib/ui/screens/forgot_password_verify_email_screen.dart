import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/verify_email_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
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

                  // Screen Title
                  Text(
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'A 6-digit OTP will be sent to your email address',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  TextFormField(
                    controller: _emailTEController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter your email address';
                      if (!value.contains("@")) return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Button / Loader
                  Consumer<VerifyEmailProvider>(
                    builder: (context, provider, _) {
                      return Visibility(
                        visible: !provider.progressIndicator,
                        replacement: const CenteredProgressIndicator(),
                        child: FilledButton(
                          onPressed: _onTapNextButton,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 36),

                  // Login Redirect
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

  // Login navigation
  void _onTapLoginButton() {
    Navigator.pop(context);
  }

  // Next button click handler
  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _recoverVerifyByEmail();
    }
  }

  // Provider call
  Future<void> _recoverVerifyByEmail() async {
    final provider =
    Provider.of<VerifyEmailProvider>(context, listen: false);

    final bool isSuccess =
    await provider.recoverVerifyByEmail(_emailTEController.text.trim());

    if (isSuccess) {
      showSnackBarMessage(context, "OTP sent to your email");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordVerifyOtpScreen(
            userEmail: _emailTEController.text.trim(),
          ),
        ),
      );
    } else {
      showSnackBarMessage(context, provider.errorMessage ?? "Failed, try again");
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
