import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book_publisher.g.dart';

@HiveType(typeId: DBItemHiveType.bookPublisher)
class PublisherModel {
  @HiveField(0)
  final String publisherID;

  @HiveField(1)
  String publisherName;

  @HiveField(2)
  int createdDate;

  @HiveField(3)
  String createdBy;

  @HiveField(4)
  int modifiedDate;

  @HiveField(5)
  String modifiedBy;

  @HiveField(6)
  int status;

  @HiveField(7)
  bool synced;

  Map<String, dynamic> toJson() {
    return {
      'publisherID': publisherID,
      'publisherName': publisherName,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': publisherID, 'name': publisherName};
  }

  PublisherModel(
      {required this.publisherID,
      required this.publisherName,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status,
      required this.synced});
}
