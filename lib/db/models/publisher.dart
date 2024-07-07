import 'package:hive_flutter/hive_flutter.dart';
part 'publisher.g.dart';

@HiveType(typeId: 4)
class PublisherModel {
  @HiveField(0)
  final String publisherID;

  @HiveField(1)
  final String publisherName;

  @HiveField(2)
  final String publisherAddress;

  Map<String, dynamic> toJson() {
    return {
      'publisherID': publisherID,
      'publisherName': publisherName,
      'publisherAddress': publisherAddress
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': publisherID, 'name': publisherName};
  }

  PublisherModel(
      {required this.publisherID,
      required this.publisherName,
      required this.publisherAddress});
}
