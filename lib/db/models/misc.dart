import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'misc.g.dart';

@HiveType(typeId: DBItemHiveType.misc)
class MiscModel {
  @HiveField(0)
  final String itemKey;

  @HiveField(1)
  String itemValue;

  @HiveField(2)
  final int createdDate;

  @HiveField(3)
  final String createdBy;

  @HiveField(4)
  int modifiedDate;

  @HiveField(5)
  String modifiedBy;

  Map<String, dynamic> toJson() {
    return {
      'itemKey': itemKey,
      'itemValue': itemValue,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
    };
  }

  MiscModel(
      {required this.itemKey,
      required this.itemValue,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy});
}
