import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';

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

Future<void> addAdminUserIfEmpty() async {
  final box = await getUsersBox();
  if (box.values.isEmpty) {
    final currentTS = getCurrentTimestamp();
    box.add(UserModel(
        userID: generateID(),
        firstName: 'Admin',
        lastName: '',
        username: 'admin',
        password: 'admin',
        role: UserRole.admin,
        status: UserStatus.enabled,
        lastLoginDate: 0,
        createdDate: currentTS,
        createdBy: 0,
        modifiedDate: currentTS,
        modifiedBy: 0));
  }
}

Future<Map<String, String>> login(String username, String password) async {
  final box = await getUsersBox();

  final users =
      box.values.where((u) => u.username == username && u.password == password);

  if (users.isNotEmpty) {
    String userID = users.first.userID;

    await updateMiscValue(MiscDBKeys.currentlyLoggedInUserID, userID);
    await updateMiscValue(MiscDBKeys.lastLogInTime,
        DateTime.now().millisecondsSinceEpoch.toString());
    await addLoginHistory(userID);

    return {};
  } else {
    return {'error': 'Incorrect Username / Password'};
  }
}

Future<void> logout() async {
  await updateMiscValue(MiscDBKeys.currentlyLoggedInUserID, '');
  await updateLogoutHistory();
}
