import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'stationary_item.g.dart';

@HiveType(typeId: DBItemHiveType.stationaryItem)
class StationaryItemModel {
  @HiveField(0)
  final String itemID;

  @HiveField(1)
  String itemName;

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
      'itemID': itemID,
      'itemName': itemName,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': itemID, 'name': itemName};
  }

  StationaryItemModel(
      {required this.itemID,
      required this.itemName,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status,
      required this.synced});
}
