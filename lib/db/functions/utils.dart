import 'package:hive_flutter/hive_flutter.dart';

import '../../utils.dart';
import '../models/login_history.dart';
import '../models/misc.dart';

Future<Box<MiscModel>> getMiscBox() async {
  Box<MiscModel> box;

  if (Hive.isBoxOpen(DBNames.misc)) {
    box = Hive.box<MiscModel>(DBNames.misc);
  } else {
    box = await Hive.openBox<MiscModel>(DBNames.misc);
  }

  return box;
}

Future<Box<LoginHistoryModel>> getLoginHistoryBox() async {
  Box<LoginHistoryModel> box;

  if (Hive.isBoxOpen(DBNames.loginHistory)) {
    box = Hive.box<LoginHistoryModel>(DBNames.loginHistory);
  } else {
    box = await Hive.openBox<LoginHistoryModel>(DBNames.loginHistory);
  }

  return box;
}

Future<String> readMiscValue(String itemKey) async {
  final miscBox = await getMiscBox();
  final items = miscBox.values.where((i) => i.itemKey == itemKey);
  if (items.isNotEmpty) {
    return items.first.itemValue;
  } else {
    return '';
  }
}

Future<void> updateMiscValue(String itemKey, String itemValue) async {
  final miscBox = await getMiscBox();

  final items = miscBox.values.where((i) => i.itemKey == itemKey);

  if (items.isEmpty) {
    miscBox.add(MiscModel(itemKey: itemKey, itemValue: itemValue));
  } else {
    for (int key in miscBox.keys) {
      MiscModel? existingData = miscBox.get(key);
      if (existingData != null && existingData.itemKey == itemKey) {
        existingData.itemValue = itemValue;
        await miscBox.put(key, existingData);
        break;
      }
    }
  }
}

Future<void> addLoginHistory(String userID) async {
  final box = await getLoginHistoryBox();
  int currentTS = DateTime.now().millisecondsSinceEpoch;

  box.add(LoginHistoryModel(
      id: generateID(), userID: userID, logInTime: currentTS, logOutTime: 0));
}

Future<void> updateLogoutHistory() async {
  final box = await getLoginHistoryBox();

  for (int key in box.keys) {
    LoginHistoryModel? existingData = box.get(key);
    if (existingData != null && existingData.logOutTime == 0) {
      existingData.logOutTime = DateTime.now().millisecondsSinceEpoch;
    }
  }
}
