import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'misc.g.dart';

@HiveType(typeId: DBItemHiveType.misc)
class MiscModel {
  @HiveField(0)
  final String itemKey;

  @HiveField(1)
  String itemValue;

  Map<String, dynamic> toJson() {
    return {'itemKey': itemKey, 'itemValue': itemValue};
  }

  MiscModel({required this.itemKey, required this.itemValue});
}
