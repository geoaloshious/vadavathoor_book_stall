import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/publisher.dart';
import 'package:vadavathoor_book_stall/utils.dart';

final publishersNotifier = ValueNotifier<List<PublisherModel>>([]);

Future<String> addPublisher(String name, String address) async {
  String publisherID = generateID(ItemType.publisher);
  final db = await Hive.openBox<PublisherModel>(DBNames.publisher);

  await db.add(PublisherModel(
      publisherID: publisherID,
      publisherName: name,
      publisherAddress: address));
  await updatePublishersList();

  return publisherID;
}

Future<void> updatePublishersList() async {
  final db = await Hive.openBox<PublisherModel>(DBNames.publisher);
  publishersNotifier.value = db.values.toList();
  publishersNotifier.notifyListeners();
}
