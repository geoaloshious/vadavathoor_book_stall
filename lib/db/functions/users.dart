import 'package:hive_flutter/hive_flutter.dart';

import '../../utils.dart';
import '../models/users.dart';

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
