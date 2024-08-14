import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'misc.g.dart';

@HiveType(typeId: ItemType.misc)
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
