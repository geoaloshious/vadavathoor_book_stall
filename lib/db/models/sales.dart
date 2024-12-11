import 'dart:convert';

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

  factory SaleItemPurchaseVariantModel.fromJson(
      Map<String, dynamic> jsonValue) {
    return SaleItemPurchaseVariantModel(
        purchaseID: jsonValue['purchaseID'],
        soldPrice: jsonValue['soldPrice'],
        quantity: jsonValue['quantity']);
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
      'purchaseVariants':
          jsonEncode(purchaseVariants.map((b) => b.toJson()).toList())
    };
  }

  factory SaleItemModel.fromJson(Map<String, dynamic> jsonValue) {
    return SaleItemModel(
        itemID: jsonValue['itemID'],
        purchaseVariants: List<SaleItemPurchaseVariantModel>.from(
            jsonDecode(jsonValue['purchaseVariants'])
                .map((item) => SaleItemPurchaseVariantModel.fromJson(item))));
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
  String billNo;

  @HiveField(2)
  List<SaleItemModel> books;

  @HiveField(3)
  List<SaleItemModel> stationaryItems;

  @HiveField(4)
  double grandTotal;

  @HiveField(5)
  String customerID;

  @HiveField(6)
  String paymentMode;

  @HiveField(7)
  int createdDate;

  @HiveField(8)
  String createdBy;

  @HiveField(9)
  int modifiedDate;

  @HiveField(10)
  String modifiedBy;

  @HiveField(11)
  int status;

  @HiveField(12)
  bool synced;

  Map<String, dynamic> toJson() {
    return {
      'saleID': saleID,
      'billNo': billNo,
      'grandTotal': grandTotal,
      'customerID': customerID,
      'paymentMode': paymentMode,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status,
      'books': jsonEncode(books.map((b) => b.toJson()).toList()),
      'stationaryItems':
          jsonEncode(stationaryItems.map((b) => b.toJson()).toList())
    };
  }

  SaleModel clone() {
    return SaleModel(
        books: books.map((b) => b.clone()).toList(),
        stationaryItems: stationaryItems.map((b) => b.clone()).toList(),
        grandTotal: grandTotal,
        customerID: customerID,
        paymentMode: paymentMode,
        createdDate: createdDate,
        createdBy: createdBy,
        modifiedDate: modifiedDate,
        modifiedBy: modifiedBy,
        status: status,
        billNo: billNo,
        saleID: saleID,
        synced: synced);
  }

  SaleModel(
      {required this.books,
      required this.stationaryItems,
      required this.grandTotal,
      required this.customerID,
      required this.paymentMode,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status,
      required this.billNo,
      required this.saleID,
      required this.synced});
}
