
import 'package:task_manager_assignment/utils/core_paths.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});
  static const String name = '/profileDetailsScreen';

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {

  final List<ProfileModel> _profileModel = [];

  bool _progressIndicator = false;

  String? userName;
  String? email;
  String? mobile;

  @override
  void initState() {
    super.initState();


    _fetchProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    final profilePhoto = AuthController.userModel!.photo;
    return Scaffold(
      appBar: TMAppBar(fromProfileDetails: true),

      body: Visibility(
        visible: _progressIndicator == false,
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
                Text(userName ?? 'User Not Found'),
                Text(email ?? 'Email Not Found'),
                Text(mobile ?? 'Mobile Not Found'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchProfileDetails() async {
    setState(() {
      _progressIndicator = true;
    });

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.profileDetailsUrl,
    );

    if (response.isSuccess) {
      final decodedJson = response.responseData;

      for (Map<String, dynamic> profileJson in decodedJson['data']) {
        ProfileModel profileModel = ProfileModel.fromJson(profileJson);
        _profileModel.add(profileModel);
      }
      setState(() {
        userName = "${_profileModel[0].firstName} ${_profileModel[0].lastName}";
        email = _profileModel[0].email;
        mobile = _profileModel[0].mobile;
        _progressIndicator = false;
      });



    } else {
      setState(() {
        _progressIndicator = false;
      });
      showSnackBarMessage(context, response.errorMessage!);
    }
  }
}
