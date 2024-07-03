import 'package:hive_flutter/hive_flutter.dart';
part 'purchase.g.dart';

@HiveType(typeId: 1)
class PurchaseModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String bookName;

  @HiveField(2)
  final String bookPrice;

  @HiveField(3)
  final String personName;

  @HiveField(4)
  final String personBatch;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookName': bookName,
      'bookPrice': bookPrice,
      'personName': personName,
      'personBatch': personBatch
    };
  }

  PurchaseModel(
      {required this.bookName,
      required this.bookPrice,
      required this.personName,
      required this.personBatch,
      this.id});
}
