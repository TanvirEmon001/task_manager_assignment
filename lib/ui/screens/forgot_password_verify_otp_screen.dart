import 'package:task_manager_assignment/utils/core_paths.dart';



class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  final String userEmail;
  const ForgotPasswordVerifyOtpScreen({super.key, required this.userEmail});

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
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
                    'Enter Your OTP',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits OTP has been sent to your email address',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    controller: _otpTEController,
                    appContext: context,
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _progressIndicator == false,
                    replacement: CenteredProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapVerifyButton,
                      child: Text('Verify'),
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

  void _onTapVerifyButton() {
    if (_otpTEController.text.trim().isNotEmpty) {
      _verifyByOtp();
    } else {
      showSnackBarMessage(context, "Please enter OTP");
    }
  }

  Future<void> _verifyByOtp() async {
    setState(() {
      _progressIndicator = true;
    });

    String url =
        "${Urls.recoveryVerifyOtpUrl}/${widget.userEmail}/${_otpTEController.text.trim()}";


    final ApiResponse response = await ApiCaller.getRequest(url: url);

    if (response.isSuccess) {
      _otpTEController.clear();
      showSnackBarMessage(context, "OTP Matched!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.userEmail, otp: int.parse(_otpTEController.text.trim()),)),
            (predicate) => false,
      );
    } else {
      _otpTEController.clear();
      showSnackBarMessage(context, "OTP did not matched!");
      setState(() {
        _progressIndicator = false;
      });
    }

  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
