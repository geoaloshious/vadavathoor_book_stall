import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
      userID: '',
      firstName: '',
      lastName: '',
      username: '',
      password: '',
      role: 0,
      status: 0,
      lastLoginDate: 0,
      createdDate: 0,
      createdBy: '',
      modifiedDate: 0,
      modifiedBy: '');

  UserModel get user => _user;

  void setData(UserModel data) {
    _user = data;
    notifyListeners();
  }
}
