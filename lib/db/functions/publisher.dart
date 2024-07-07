import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/publisher.dart';

final publishersNotifier = ValueNotifier<List<PublisherModel>>([]);

Future<void> addPublisher(String name, String address) async {
  String publisherID = DateTime.now().millisecondsSinceEpoch.toString();
  final db = await Hive.openBox<PublisherModel>('publishers_db');

  await db.add(PublisherModel(
      publisherID: publisherID,
      publisherName: name,
      publisherAddress: address));
  await updatePublishersList();
}

Future<void> updatePublishersList() async {
  final db = await Hive.openBox<PublisherModel>('publishers_db');
  publishersNotifier.value = db.values.toList();
  publishersNotifier.notifyListeners();
}
