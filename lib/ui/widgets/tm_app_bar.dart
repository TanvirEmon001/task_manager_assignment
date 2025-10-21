import 'package:task_manager_assignment/utils/core_paths.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({super.key, this.fromUpdateProfile, this.fromProfileDetails});

  final bool? fromUpdateProfile;
  final bool? fromProfileDetails;

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  Widget build(BuildContext context) {
    final profilePhoto = AuthController.userModel!.photo;

    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (widget.fromUpdateProfile ?? false) {
            return;
          }
          Navigator.pushNamed(context, UpdateProfileScreen.name);
        },
        child: Row(
          spacing: 8,
          children: [
            GestureDetector(
              onTap: _profileButtonOnTap,
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
      actions: [IconButton(onPressed: _signOut, icon: Icon(Icons.logout))],
    );
  }

  Future<void> _signOut() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.name, (predicate) => false);
  }

  void _profileButtonOnTap() {
    if (widget.fromProfileDetails ?? false) {
      return;
    }
    Navigator.pushNamed(context, ProfileDetailsScreen.name);
  }

}
