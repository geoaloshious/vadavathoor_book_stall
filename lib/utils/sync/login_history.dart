import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/login_history.dart';

downSyncLoginHistory(Map<String, dynamic> jsonResult, String key,
    Box<LoginHistoryModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists = box.values.where((i) => i.id == itm['id']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.id == itm['id']) {
          existingData.userID = itm['userID'];
          existingData.logInTime = int.tryParse(itm['logInTime']) ?? 0;
          existingData.logOutTime = int.tryParse(itm['logOutTime']) ?? 0;

          await box.put(key, existingData);
          break;
        }
      }
    } else {
      await box.add(LoginHistoryModel(
          id: itm['id'],
          userID: itm['userID'],
          logInTime: int.tryParse(itm['logInTime']) ?? 0,
          logOutTime: int.tryParse(itm['logOutTime']) ?? 0));
    }
  }
}
