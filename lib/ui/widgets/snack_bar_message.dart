import 'package:task_manager_assignment/utils/core_paths.dart';

void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
