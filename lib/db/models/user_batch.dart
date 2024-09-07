import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'user_batch.g.dart';

@HiveType(typeId: DBItemHiveType.userBatch)
class UserBatchModel {
  @HiveField(0)
  final String batchID;

  @HiveField(1)
  String batchName;

  @HiveField(2)
  int status;

  @HiveField(3)
  final int createdDate;

  @HiveField(4)
  final String createdBy;

  @HiveField(5)
  int modifiedDate;

  @HiveField(6)
  String modifiedBy;

  Map<String, dynamic> toJson() {
    return {
      'batchID': batchID,
      'batchName': batchName,
      'status': status,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': batchID, 'name': batchName};
  }

  UserBatchModel(
      {required this.batchID,
      required this.batchName,
      required this.status,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy});
}
