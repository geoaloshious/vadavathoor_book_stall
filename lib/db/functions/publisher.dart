import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/book_publisher.dart';
import 'package:vadavathoor_book_stall/utils/utils.dart';

import '../constants.dart';

Future<Box<PublisherModel>> getPublishersBox() async {
  Box<PublisherModel> box;

  if (Hive.isBoxOpen(DBNames.publisher)) {
    box = Hive.box<PublisherModel>(DBNames.publisher);
  } else {
    box = await Hive.openBox<PublisherModel>(DBNames.publisher);
  }

  return box;
}

Future<String> addPublisher(String name) async {
  String publisherID = generateID();
  final db = await getPublishersBox();
  final loggedInUser = await getLoggedInUserID();
  final currentTS = getCurrentTimestamp();

  await db.add(PublisherModel(
      publisherID: publisherID,
      publisherName: name,
      createdDate: currentTS,
      createdBy: loggedInUser,
      modifiedDate: currentTS,
      modifiedBy: loggedInUser,
      status: DBRowStatus.active));

  return publisherID;
}

Future<void> editPublisher(
    {required String publisherID, String? publisherName, int? status}) async {
  final box = await getPublishersBox();
  final loggedInUser = await getLoggedInUserID();

  for (int key in box.keys) {
    PublisherModel? existingData = box.get(key);
    if (existingData != null && existingData.publisherID == publisherID) {
      if (publisherName != null) {
        existingData.publisherName = publisherName;
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

Future<List<PublisherModel>> getPublishers() async {
  final db = await getPublishersBox();
  return db.values.where((i) => i.status == DBRowStatus.active).toList();
}
