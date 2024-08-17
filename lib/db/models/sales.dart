import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'sales.g.dart';

SaleItemBookModel emptyBookSaleItem() =>
    SaleItemBookModel(bookID: '', purchaseVariants: []);

SaleItemBookPurchaseVariantModel emptySaleItemBookPurchaseVariant() =>
    SaleItemBookPurchaseVariantModel(purchaseID: '', soldPrice: 0, quantity: 0);

@HiveType(typeId: DBItemHiveType.saleItemBookPurchaseVariant)
class SaleItemBookPurchaseVariantModel {
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

  SaleItemBookPurchaseVariantModel clone() {
    return SaleItemBookPurchaseVariantModel(
        purchaseID: purchaseID, soldPrice: soldPrice, quantity: quantity);
  }

  SaleItemBookPurchaseVariantModel(
      {required this.purchaseID,
      required this.soldPrice,
      required this.quantity});
}

@HiveType(typeId: DBItemHiveType.saleItemBook)
class SaleItemBookModel {
  @HiveField(0)
  String bookID;

  @HiveField(1)
  List<SaleItemBookPurchaseVariantModel> purchaseVariants;

  Map<String, dynamic> toJson() {
    return {
      'bookID': bookID,
      'purchaseVariants': purchaseVariants.map((b) => b.toJson()).toString()
    };
  }

  SaleItemBookModel clone() {
    return SaleItemBookModel(
        bookID: bookID,
        purchaseVariants: purchaseVariants.map((i) => i.clone()).toList());
  }

  SaleItemBookModel({required this.bookID, required this.purchaseVariants});
}

@HiveType(typeId: DBItemHiveType.sale)
class SaleModel {
  @HiveField(0)
  final String saleID;

  @HiveField(1)
  final List<SaleItemBookModel> books;

  @HiveField(2)
  double grandTotal;

  @HiveField(3)
  String customerName;

  @HiveField(4)
  String customerBatch;

  @HiveField(5)
  String paymentMode;

  @HiveField(6)
  final int createdDate;

  @HiveField(7)
  final String createdBy;

  @HiveField(8)
  int modifiedDate;

  @HiveField(9)
  String modifiedBy;

  @HiveField(10)
  int status;

  Map<String, dynamic> toJson() {
    return {
      'saleID': saleID,
      'grandTotal': grandTotal,
      'customerName': customerName,
      'customerBatch': customerBatch,
      'paymentMode': paymentMode,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status,
      'books': books.map((b) => b.toJson()).toString()
    };
  }

  SaleModel clone() {
    return SaleModel(
        books: books.map((b) => b.clone()).toList(),
        grandTotal: grandTotal,
        customerName: customerName,
        customerBatch: customerBatch,
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
      required this.grandTotal,
      required this.customerName,
      required this.customerBatch,
      required this.paymentMode,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status,
      required this.saleID});
}
