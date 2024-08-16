import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';

import '../../utils.dart';
import '../models/users.dart';
import 'utils.dart';

Future<Box<UserModel>> getUsersBox() async {
  Box<UserModel> box;

  if (Hive.isBoxOpen(DBNames.users)) {
    box = Hive.box<UserModel>(DBNames.users);
  } else {
    box = await Hive.openBox<UserModel>(DBNames.users);
  }

  return box;
}

Future<List<UserModel>> getUsers() async {
  final usersDB = await getUsersBox();
  return usersDB.values.where((i) => i.status != UserStatus.deleted).toList();
}

Future<Map<String, String>> addUser(UserModel userData) async {
  final box = await getUsersBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  bool usernameNotTaken =
      box.values.where((i) => i.username == userData.username).isEmpty;

  if (usernameNotTaken) {
    box.add(UserModel(
        userID: generateID(),
        firstName: userData.firstName,
        lastName: userData.lastName,
        username: userData.username,
        password: userData.password,
        role: userData.role,
        status: userData.status,
        createdDate: currentTS,
        createdBy: loggedInUser,
        modifiedDate: 0,
        modifiedBy: ''));
  } else {
    return {'error': ErrorMessages.usernameTaken};
  }

  return {};
}

Future<Map<String, String>> editUser(UserModel userData) async {
  final box = await getUsersBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  bool usernameNotTaken = box.values
      .where(
          (i) => i.username == userData.username && i.userID != userData.userID)
      .isEmpty;

  if (usernameNotTaken) {
    for (int key in box.keys) {
      UserModel? existingData = box.get(key);
      if (existingData != null && existingData.userID == userData.userID) {
        existingData.firstName = userData.firstName;
        existingData.lastName = userData.lastName;
        existingData.username = userData.username;
        existingData.password = userData.password;
        existingData.role = userData.role;
        existingData.status = userData.status;
        existingData.modifiedDate = getCurrentTimestamp();
        existingData.modifiedBy = loggedInUser;

        await box.put(key, existingData);
        break;
      }
    }
  } else {
    return {'error': ErrorMessages.usernameTaken};
  }

  return {};
}

Future<void> deleteUser(String userID) async {
  final box = await getUsersBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  for (int key in box.keys) {
    UserModel? existingData = box.get(key);
    if (existingData != null && existingData.userID == userID) {
      existingData.status = UserStatus.deleted;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<void> addDeveloperUserIfEmpty() async {
  final box = await getUsersBox();
  if (box.values.isEmpty) {
    final currentTS = getCurrentTimestamp();
    box.add(UserModel(
        userID: generateID(),
        firstName: 'Developer',
        lastName: '0',
        username: 'dev',
        password: 'dev',
        role: UserRole.developer,
        status: UserStatus.enabled,
        createdDate: currentTS,
        createdBy: '',
        modifiedDate: 0,
        modifiedBy: ''));
  }
}

Future<Map<String, String>> login(
    BuildContext context, String username, String password) async {
  final box = await getUsersBox();

  final users =
      box.values.where((u) => u.username == username && u.password == password);

  if (users.isNotEmpty) {
    if (users.first.status == UserStatus.enabled) {
      String userID = users.first.userID;

      await updateMiscValue(MiscDBKeys.currentlyLoggedInUserID, userID);
      await updateMiscValue(MiscDBKeys.lastLogInTime,
          DateTime.now().millisecondsSinceEpoch.toString());
      await addLoginHistory(userID);

      context.read<UserProvider>().setData(users.first);
    } else {
      return {'error': ErrorMessages.userNotEnabled};
    }
  } else {
    return {'error': ErrorMessages.incorrectCredentials};
  }

  return {};
}

Future<void> logout(BuildContext context) async {
  await updateMiscValue(MiscDBKeys.currentlyLoggedInUserID, '');
  await updateLogoutHistory();
  context.read<UserProvider>().setData(emptyUserModel());
}

void loadUserProviderValue(BuildContext context) async {
  String loggedInUserID =
      await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  if (loggedInUserID != '') {
    final box = await getUsersBox();

    final users = box.values.where((u) => u.userID == loggedInUserID);

    if (users.isNotEmpty) {
      context.read<UserProvider>().setData(users.first);
    }
  }
}
