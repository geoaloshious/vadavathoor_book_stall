import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/book_publisher.dart';

downSyncBookPublishers(Map<String, dynamic> jsonResult, String key,
    Box<PublisherModel> bookPublishers) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists = bookPublishers.values
        .where((i) => i.publisherID == itm['publisherID'])
        .isNotEmpty;
    if (exists) {
      for (int key in bookPublishers.keys) {
        var existingData = bookPublishers.get(key);
        if (existingData != null &&
            existingData.publisherID == itm['publisherID']) {
          existingData.publisherName = itm['publisherName'];
          existingData.status = itm['status'];
          existingData.createdDate = int.tryParse(itm['createdDate']) ?? 0;
          existingData.createdBy = itm['createdBy'];
          existingData.modifiedDate = int.tryParse(itm['modifiedDate']) ?? 0;
          existingData.modifiedBy = itm['modifiedBy'];

          await bookPublishers.put(key, existingData);
          break;
        }
      }
    } else {
      await bookPublishers.add(PublisherModel(
          publisherID: itm['publisherID'],
          publisherName: itm['publisherName'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status']));
    }
  }
}
