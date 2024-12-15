import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'stationary_purchase.g.dart';

@HiveType(typeId: DBItemHiveType.stationaryPurchase)
class StationaryPurchaseModel {
  @HiveField(0)
  final String purchaseID;

  @HiveField(1)
  int purchaseDate;

  @HiveField(2)
  String itemID;

  @HiveField(3)
  double price;

  @HiveField(4)
  int quantityPurchased;

  @HiveField(5)
  int quantityLeft;

  @HiveField(6)
  int createdDate;

  @HiveField(7)
  String createdBy;

  @HiveField(8)
  int modifiedDate;

  @HiveField(9)
  String modifiedBy;

  @HiveField(10)
  int status;

  @HiveField(11)
  bool synced;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'purchaseDate': purchaseDate,
      'itemID': itemID,
      'quantityPurchased': quantityPurchased,
      'quantityLeft': quantityLeft,
      'price': price,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status
    };
  }

  StationaryPurchaseModel(
      {required this.purchaseID,
      required this.purchaseDate,
      required this.itemID,
      required this.quantityPurchased,
      required this.quantityLeft,
      required this.price,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status,
      required this.synced});
}
