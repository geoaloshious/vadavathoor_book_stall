import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/functions/users.dart';
import '../../providers/user.dart';
import 'login.dart';

class UserProfileWidget extends StatefulWidget {
  final void Function() resetPage;

  const UserProfileWidget({super.key, required this.resetPage});

  @override
  State<UserProfileWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileWidget> {
  void onPressLogin() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Size screenSize = MediaQuery.of(context).size;

          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                  constraints: BoxConstraints(maxWidth: screenSize.width * 0.3),
                  child: const LoginDialogWidget()));
        });
  }

  void onPressLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              autofocus: true,
              onPressed: () async {
                await logout(context);
                widget.resetPage();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void onSelected(int value) {
    switch (value) {
      case 1:
        onPressLogin();
      case 2:
        onPressLogout();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserProviderValue(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return PopupMenuButton<int>(
          padding: const EdgeInsets.all(5),
          icon: user.user.userID == ''
              ? const Icon(
                  Icons.account_circle,
                  size: 35,
                )
              : Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(user.user.firstName[0] + user.user.lastName[0],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
          tooltip: user.user.userID == ''
              ? 'Guest user'
              : '${user.user.firstName} ${user.user.lastName}',
          onSelected: onSelected,
          itemBuilder: (context) => [
                if (user.user.userID == '')
                  const PopupMenuItem(value: 1, child: Text('Log In'))
                else
                  const PopupMenuItem(value: 2, child: Text('Log Out'))
              ]);
    });
  }
}
