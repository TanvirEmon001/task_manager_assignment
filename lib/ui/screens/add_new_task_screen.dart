import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/add_new_task_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

import '../../data/provider/update_profile_provider.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AddNewTaskProvider _addNewTaskProvider = AddNewTaskProvider();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UpdateProfileProvider>();
    final profilePhoto =
        provider.encodedPhoto ?? AuthController.userModel!.photo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainNavBarHolderScreen.name,
              (predicate) => false,
            );
          },
          icon: Icon(Icons.arrow_back_sharp),
        ),
        title: GestureDetector(
          child: Row(
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  maxRadius: 25,
                  backgroundColor: Colors.grey.shade200,
                  child: profilePhoto.isNotEmpty
                      ? ClipOval(
                          child: Image.memory(
                            base64Decode(profilePhoto),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        )
                      : const Icon(Icons.person),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    AuthController.userModel?.email ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
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
                  const SizedBox(height: 32),
                  Text(
                    'Add new task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 6,
                    decoration: InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<AddNewTaskProvider>(
                    builder: (context, addNewTaskProvider, _) {
                      return Visibility(
                        visible:
                            addNewTaskProvider.addNewTaskInProgress == false,
                        replacement: CenteredProgressIndicator(),
                        child: FilledButton(
                          onPressed: _onTapAddButton,
                          child: Text('Add'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    final bool isSuccess = await _addNewTaskProvider.addNewTask(
      _titleTEController.text.trim(),
      _descriptionTEController.text.trim(),
    );

    if (isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'New task has been added');
    } else {
      showSnackBarMessage(context, _addNewTaskProvider.errorMessage.toString());
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
