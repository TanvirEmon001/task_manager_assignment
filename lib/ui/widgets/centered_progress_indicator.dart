import 'package:task_manager_assignment/utils/core_paths.dart';

class CenteredProgressIndicator extends StatelessWidget {
  const CenteredProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
