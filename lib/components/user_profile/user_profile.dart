import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/components/user_profile/login.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/edit_book_purchase.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileWidget> {
  void onPressProfile() {
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

  void onSelected(int value) {
    switch (value) {
      case 1:
        onPressProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        icon: const Icon(Icons.account_circle),
        onSelected: onSelected,
        itemBuilder: (context) =>
            [const PopupMenuItem(value: 1, child: Text('Log In'))]);
  }
}
