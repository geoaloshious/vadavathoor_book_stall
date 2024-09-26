import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'sales.g.dart';

SaleItemModel emptyBookSaleItem() =>
    SaleItemModel(itemID: '', purchaseVariants: []);

SaleItemPurchaseVariantModel emptySaleItemBookPurchaseVariant() =>
    SaleItemPurchaseVariantModel(purchaseID: '', soldPrice: 0, quantity: 0);

@HiveType(typeId: DBItemHiveType.saleItemBookPurchaseVariant)
class SaleItemPurchaseVariantModel {
  @HiveField(0)
  String purchaseID;

  @HiveField(2)
  double soldPrice;

  @HiveField(3)
  int quantity;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'soldPrice': soldPrice,
      'quantity': quantity
    };
  }

  SaleItemPurchaseVariantModel clone() {
    return SaleItemPurchaseVariantModel(
        purchaseID: purchaseID, soldPrice: soldPrice, quantity: quantity);
  }

  SaleItemPurchaseVariantModel(
      {required this.purchaseID,
      required this.soldPrice,
      required this.quantity});
}

@HiveType(typeId: DBItemHiveType.saleItemBook)
class SaleItemModel {
  @HiveField(0)
  String itemID;

  @HiveField(1)
  List<SaleItemPurchaseVariantModel> purchaseVariants;

  Map<String, dynamic> toJson() {
    return {
      'itemID': itemID,
      'purchaseVariants': purchaseVariants.map((b) => b.toJson()).toString()
    };
  }

  SaleItemModel clone() {
    return SaleItemModel(
        itemID: itemID,
        purchaseVariants: purchaseVariants.map((i) => i.clone()).toList());
  }

  SaleItemModel({required this.itemID, required this.purchaseVariants});
}

@HiveType(typeId: DBItemHiveType.sale)
class SaleModel {
  @HiveField(0)
  final String saleID;

  @HiveField(1)
  List<SaleItemModel> books;

  @HiveField(2)
  List<SaleItemModel> stationaryItems;

  @HiveField(3)
  double grandTotal;

  @HiveField(4)
  String customerID;

  @HiveField(5)
  String customerBatchID;

  @HiveField(6)
  String paymentMode;

  @HiveField(7)
  final int createdDate;

  @HiveField(8)
  final String createdBy;

  @HiveField(9)
  int modifiedDate;

  @HiveField(10)
  String modifiedBy;

  @HiveField(11)
  int status;

  Map<String, dynamic> toJson() {
    return {
      'saleID': saleID,
      'grandTotal': grandTotal,
      'customerID': customerID,
      'customerBatchID': customerBatchID,
      'paymentMode': paymentMode,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status,
      'books': books.map((b) => b.toJson()).toString(),
      'stationaryItems': stationaryItems.map((b) => b.toJson()).toString()
    };
  }

  SaleModel clone() {
    return SaleModel(
        books: books.map((b) => b.clone()).toList(),
        stationaryItems: stationaryItems.map((b) => b.clone()).toList(),
        grandTotal: grandTotal,
        customerID: customerID,
        customerBatchID: customerBatchID,
        paymentMode: paymentMode,
        createdDate: createdDate,
        createdBy: createdBy,
        modifiedDate: modifiedDate,
        modifiedBy: modifiedBy,
        status: status,
        saleID: saleID);
  }

  SaleModel(
      {required this.books,
      required this.stationaryItems,
      required this.grandTotal,
      required this.customerID,
      required this.customerBatchID,
      required this.paymentMode,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status,
      required this.saleID});
}
