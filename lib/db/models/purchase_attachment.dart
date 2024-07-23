import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'purchase_attachment.g.dart';

@HiveType(typeId: ItemType.attachment)
class PurchaseAttachmentModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String purchaseID;

  @HiveField(2)
  final String fileName;

  Map<String, dynamic> toJson() {
    return {'id': id, 'purchaseID': purchaseID, 'fileName': fileName};
  }

  PurchaseAttachmentModel(
      {this.id, required this.purchaseID, required this.fileName});
}
