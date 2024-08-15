import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'publisher.g.dart';

@HiveType(typeId: ItemType.publisher)
class PublisherModel {
  @HiveField(0)
  final String publisherID;

  @HiveField(1)
  final String publisherName;

  Map<String, dynamic> toJson() {
    return {'publisherID': publisherID, 'publisherName': publisherName};
  }

  Map<String, String> toDropdownData() {
    return {'id': publisherID, 'name': publisherName};
  }

  PublisherModel({required this.publisherID, required this.publisherName});
}
