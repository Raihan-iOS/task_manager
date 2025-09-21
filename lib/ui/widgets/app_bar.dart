import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/Sign_in_screen.dart';
import 'package:task_manager/ui/screens/profile/profile_screen.dart';

class TmAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppbar({super.key});

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
                  "User Name",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),

                Text(
                  "Email",
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInScreen.routeName,
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
