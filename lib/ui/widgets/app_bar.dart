import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/profile/profile_screen.dart';

import '../screens/Controller/auth_controller.dart';

class TmAppbar extends StatefulWidget implements PreferredSizeWidget {
  const TmAppbar({super.key});

  @override
  State<TmAppbar> createState() => _TmAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TmAppbarState extends State<TmAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (ModalRoute.of(context)?.settings.name !=
              ProfileScreen.routeName) {
            Navigator.pushNamed(context, ProfileScreen.routeName);
          }
        },
        child: Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.userModel?.fullName ?? 'N/A',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),

                Text(
                  AuthController.userModel?.email ?? 'N/A',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_outlined, color: Colors.white),

          onPressed: () {
            _logout();
          },
        ),
      ],
    );
  }

Future <void> _logout() async {
  await AuthController.clearUserData();
  Navigator.pushNamedAndRemoveUntil(
    context,
    SignInScreen.routeName,
        (predicate) => false,
  );
  }


}
