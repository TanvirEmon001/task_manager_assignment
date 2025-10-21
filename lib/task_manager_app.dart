import 'package:task_manager_assignment/utils/core_paths.dart';


class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
