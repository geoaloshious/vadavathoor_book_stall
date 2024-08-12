import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/publisher.dart';
import 'package:vadavathoor_book_stall/utils.dart';

final publishersNotifier = ValueNotifier<List<PublisherModel>>([]);

Future<Box<PublisherModel>> getPublishersBox() async {
  Box<PublisherModel> box;

  if (Hive.isBoxOpen(DBNames.publisher)) {
    box = Hive.box<PublisherModel>(DBNames.publisher);
  } else {
    box = await Hive.openBox<PublisherModel>(DBNames.publisher);
  }

  return box;
}

Future<String> addPublisher(String name, String address) async {
  String publisherID = generateID();
  final db = await getPublishersBox();

  await db.add(PublisherModel(
      publisherID: publisherID,
      publisherName: name,
      publisherAddress: address));
  await updatePublishersList();

  return publisherID;
}

Future<void> updatePublishersList() async {
  final db = await getPublishersBox();
  publishersNotifier.value = db.values.toList();
  publishersNotifier.notifyListeners();
}
