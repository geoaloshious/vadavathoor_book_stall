import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/user_batch.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

import '../constants.dart';

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
  String batchID = generateID();
  final loggedInUser = await getLoggedInUserID();
  final currentTS = getCurrentTimestamp();

  await db.add(UserBatchModel(
      batchID: batchID,
      batchName: batchName,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
      status: DBRowStatus.active,
      synced: false));

  return batchID;
}

Future<void> editUserBatch(
    {required String batchID, String? batchName, int? status}) async {
  final box = await getUserBatchBox();
  final loggedInUser = await getLoggedInUserID();

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
      existingData.synced = false;

      await box.put(key, existingData);
      break;
    }
  }
}

Future<List<UserBatchModel>> getUserBatchList() async {
  final db = await getUserBatchBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}
