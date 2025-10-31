import 'package:provider/provider.dart';
import 'package:task_manager_assignment/data/provider/profile_details_provider.dart';
import 'package:task_manager_assignment/data/provider/update_profile_provider.dart';
import 'package:task_manager_assignment/utils/core_paths.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});
  static const String name = '/profileDetailsScreen';

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailsProvider>().fetchProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UpdateProfileProvider>();
    final profilePhoto =
        provider.encodedPhoto ?? AuthController.userModel!.photo;
    return Scaffold(
      appBar: TMAppBar(fromProfileDetails: true),

      body: Consumer<ProfileDetailsProvider>(
        builder: (context, core, _) {
          return Visibility(
            visible: core.progressIndicator == false,
            replacement: CenteredProgressIndicator(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      maxRadius: 50,
                      backgroundColor: Colors.grey.shade200,
                      child: profilePhoto.isNotEmpty
                          ? ClipOval(
                              child: Image.memory(
                                base64Decode(profilePhoto),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : const Icon(Icons.person),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      core.userName ?? "No name",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(core.email ?? "No email"),
                    Text(core.mobile ?? "No mobile"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
