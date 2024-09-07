import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = emptyUserModel();

  UserModel get user => _user;

  void setData(UserModel data) {
    _user = data;
    notifyListeners();
  }
}
