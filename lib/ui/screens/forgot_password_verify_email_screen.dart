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
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits OTP will be sent to your email address',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _progressIndicator == false,
                    replacement: CenteredProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapNextButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
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
    Navigator.pop(context);
  }

  void _onTapNextButton() {
    _recoverVerifyByEmail();

  }

  Future<void> _recoverVerifyByEmail() async {
    setState(() {
      _progressIndicator = true;
    });

    String url =
        "${Urls.recoveryVerifyEmailUrl}/${_emailTEController.text.trim()}";

    final ApiResponse response = await ApiCaller.getRequest(url: url);

    setState(() {
      _progressIndicator = false;
    });

    if (response.isSuccess){

      showSnackBarMessage(context, "A 6 digit OTP code sent to your email");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForgotPasswordVerifyOtpScreen(userEmail: _emailTEController.text.trim(),)),
      );
    } else {
      showSnackBarMessage(context, response.errorMessage!);
      setState(() {
        _progressIndicator = false;
      });
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
