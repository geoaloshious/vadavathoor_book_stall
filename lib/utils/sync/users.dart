import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';

downSyncUsers(
    Map<String, dynamic> jsonResult, String key, Box<UserModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists = box.values.where((i) => i.userID == itm['userID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.userID == itm['userID']) {
          existingData.name = itm['name'];
          existingData.username = itm['username'];
          existingData.password = itm['password'];
          existingData.role = itm['role'];
          existingData.batchID = itm['batchID'];
          existingData.notes = itm['notes'];
          existingData.createdDate = int.tryParse(itm['createdDate']) ?? 0;
          existingData.createdBy = itm['createdBy'];
          existingData.modifiedDate = int.tryParse(itm['modifiedDate']) ?? 0;
          existingData.modifiedBy = itm['modifiedBy'];
          existingData.status = itm['status'];

          await box.put(key, existingData);
          break;
        }
      }
    } else {
      await box.add(UserModel(
          userID: itm['userID'],
          name: itm['name'],
          username: itm['username'],
          password: itm['password'],
          role: itm['role'],
          batchID: itm['batchID'],
          notes: itm['notes'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status']));
    }
  }
}
