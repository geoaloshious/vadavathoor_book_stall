import 'package:hive_flutter/hive_flutter.dart';
part 'purchase_attachment.g.dart';

@HiveType(typeId: 2)
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
