import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/user_batch.dart';
import 'package:vadavathoor_book_stall/utils.dart';

import '../constants.dart';
import 'utils.dart';

Future<Box<UserBatchModel>> getUserBatchBox() async {
  Box<UserBatchModel> box;

  if (Hive.isBoxOpen(DBNames.userBatch)) {
    box = Hive.box<UserBatchModel>(DBNames.userBatch);
  } else {
    box = await Hive.openBox<UserBatchModel>(DBNames.userBatch);
  }

  return box;
}

Future<String> addUserBatch(String batchName) async {
  final db = await getUserBatchBox();
  String batchID = '${db.values.length + 1}';
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);
  final currentTS = getCurrentTimestamp();

  await db.add(UserBatchModel(
      batchID: batchID,
      batchName: batchName,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: 0,
      modifiedBy: '',
      status: DBRowStatus.active));

  return batchID;
}

Future<void> editUserBatch(
    {required String batchID, String? batchName, int? status}) async {
  final box = await getUserBatchBox();
  final loggedInUser = await readMiscValue(MiscDBKeys.currentlyLoggedInUserID);

  for (int key in box.keys) {
    UserBatchModel? existingData = box.get(key);
    if (existingData != null && existingData.batchID == batchID) {
      if (batchName != null) {
        existingData.batchName = batchName;
      } else if (status != null) {
        existingData.status = status;
      }

      existingData.modifiedDate = getCurrentTimestamp();
      existingData.modifiedBy = loggedInUser;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<List<UserBatchModel>> getUserBatchList() async {
  final db = await getUserBatchBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}
