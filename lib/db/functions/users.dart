import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/classes/sales.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';

import '../../utils/utils.dart';
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

Future<List<UserModelForSales>> getUsersForSales() async {
  final usersDB = await getUsersBox();
  final batchDB = await getUserBatchBox();

  List<UserModelForSales> arr = [];

  for (UserModel usr in usersDB.values) {
    if (usr.role != UserRole.developer && usr.status != UserStatus.deleted) {
      arr.add(UserModelForSales(
          userID: usr.userID,
          name: usr.name,
          batchID: usr.batchID,
          batchName: batchDB.values
              .firstWhere((b) => b.batchID == usr.batchID)
              .batchName));
    }
  }

  return arr;
}

Future<Map<String, String>> addUser(UserModel userData) async {
  final box = await getUsersBox();
  final currentTS = getCurrentTimestamp();
  final loggedInUser = await getLoggedInUserID();
  final userID = generateID();

  bool usernameNotTaken = userData.username.isEmpty
      ? true
      : box.values.where((i) => i.username == userData.username).isEmpty;

  if (usernameNotTaken) {
    box.add(UserModel(
        userID: userID,
        name: userData.name,
        username: userData.username,
        password: userData.password,
        role: userData.role,
        batchID: userData.batchID,
        emailID: '',
        notes: '',
        createdDate: currentTS,
        createdBy: loggedInUser,
        modifiedDate: currentTS,
        modifiedBy: loggedInUser,
        status: userData.status,
        synced: false));
  } else {
    return {'error': ''};
  }

  return {'userID': userID};
}

Future<Map<String, String>> editUser(UserModel userData) async {
  final box = await getUsersBox();
  final loggedInUser = await getLoggedInUserID();
  bool usernameNotTaken = userData.username.isEmpty
      ? true
      : box.values
          .where((i) =>
              i.username == userData.username && i.userID != userData.userID)
          .isEmpty;

  if (usernameNotTaken) {
    for (int key in box.keys) {
      UserModel? existingData = box.get(key);
      if (existingData != null && existingData.userID == userData.userID) {
        existingData.name = userData.name;
        existingData.username = userData.username;
        existingData.password = userData.password;
        existingData.role = userData.role;
        existingData.batchID = userData.batchID;
        existingData.emailID = userData.emailID;
        existingData.notes = userData.notes;
        existingData.modifiedDate = getCurrentTimestamp();
        existingData.modifiedBy = loggedInUser;
        existingData.status = userData.status;
        existingData.synced = false;

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
  final loggedInUser = await getLoggedInUserID();

  for (int key in box.keys) {
    UserModel? existingData = box.get(key);
    if (existingData != null && existingData.userID == userID) {
      existingData.status = UserStatus.deleted;
      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;
      existingData.synced = false;

      await box.put(key, existingData);
      break;
    }
  }
}

/*
Future<void> addDeveloperUserIfEmpty() async {
  final box = await getUsersBox();
  if (box.values.isEmpty) {
    final currentTS = getCurrentTimestamp();
    box.add(UserModel(
        userID: '1',
        name: 'Developer',
        username: 'dev',
        password: 'dev',
        role: UserRole.developer,
        batchID: '',
        status: UserStatus.enabled,
        createdDate: currentTS,
        createdBy: '',
        modifiedDate: currentTS,
        modifiedBy: '',
        notes: ''));
  }
}
*/

Future<Map<String, String>> login(
    BuildContext context, String username, String password) async {
  UserProvider provider = context.read<UserProvider>();
  final box = await getUsersBox();

  final users =
      box.values.where((u) => u.username == username && u.password == password);

  if (users.isNotEmpty) {
    if (users.first.status == UserStatus.enabled) {
      String userID = users.first.userID;

      await updateMiscValue(
          MiscDBKeys.currentlyLoggedInUserID, userID.toString());
      await updateMiscValue(MiscDBKeys.lastLogInTime,
          DateTime.now().millisecondsSinceEpoch.toString());
      await addLoginHistory(userID);

      provider.setData(users.first);
    } else {
      return {'error': ErrorMessages.userNotEnabled};
    }
  } else {
    return {'error': ErrorMessages.incorrectCredentials};
  }

  return {};
}

Future<void> logout(BuildContext context) async {
  UserProvider provider = context.read<UserProvider>();
  await updateMiscValue(MiscDBKeys.currentlyLoggedInUserID, '');
  await updateLogoutHistory();
  provider.setData(emptyUserModel());
}

void loadUserProviderValue(BuildContext context) async {
  UserProvider provider = context.read<UserProvider>();
  String loggedInUserID = await getLoggedInUserID();

  if (loggedInUserID != '') {
    final box = await getUsersBox();
    final users = box.values.where((u) => u.userID == loggedInUserID);

    if (users.isNotEmpty) {
      provider.setData(users.first);
    }
  }
}

Future<String> getLoggedInUserID() async {
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  return loggedInUser;
}
