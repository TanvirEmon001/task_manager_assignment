import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/add_new_task_provider.dart';
import 'package:task_manager_assignment/data/provider/cancelled_task_provider.dart';
import 'package:task_manager_assignment/data/provider/completed_task_provider.dart';
import 'package:task_manager_assignment/data/provider/get_new_task_provider.dart';
import 'package:task_manager_assignment/data/provider/login_provider.dart';
import 'package:task_manager_assignment/data/provider/profile_details_provider.dart';
import 'package:task_manager_assignment/data/provider/progress_task_provider.dart';
import 'package:task_manager_assignment/data/provider/reset_password_provider.dart';
import 'package:task_manager_assignment/data/provider/sign_up_provider.dart';
import 'package:task_manager_assignment/data/provider/update_profile_provider.dart';
import 'package:task_manager_assignment/data/provider/verify_email_provider.dart';
import 'package:task_manager_assignment/data/provider/verify_otp_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';


class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => VerifyEmailProvider()),
        ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => AddNewTaskProvider()),
        ChangeNotifierProvider(create: (_) => GetNewTaskProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProgressTaskProvider()),
        ChangeNotifierProvider(create: (_) => CancelledTaskProvider()),
        ChangeNotifierProvider(create: (_) => CompletedTaskProvider()),
        ChangeNotifierProvider(create: (_) => ProfileDetailsProvider())
      ],
      child: MaterialApp(
        navigatorKey: navigator,
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          textTheme: TextTheme(
            titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: Size.fromWidth(double.maxFinite),
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        initialRoute: SplashScreen.name,
        routes: {
          SplashScreen.name: (_) => SplashScreen(),
          LoginScreen.name: (_) => LoginScreen(),
          SignUpScreen.name: (_) => SignUpScreen(),
          MainNavBarHolderScreen.name: (_) => MainNavBarHolderScreen(),
          UpdateProfileScreen.name: (_) => UpdateProfileScreen(),
          NewTaskScreen.name: (_) => NewTaskScreen(),
          ProfileDetailsScreen.name: (_) => ProfileDetailsScreen(),
        },
      ),
    );
  }
}
