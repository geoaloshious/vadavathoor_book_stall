import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'misc.g.dart';

@HiveType(typeId: ItemType.misc)
class MiscModel {
  @HiveField(0)
  final String itemKey;

  @HiveField(1)
  final String itemValue;

  MiscModel({required this.itemKey, required this.itemValue});
}
