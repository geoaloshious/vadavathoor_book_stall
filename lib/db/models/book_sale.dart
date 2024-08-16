import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book_sale.g.dart';

SaleItemBookModel emptyBookSaleItem() =>
    SaleItemBookModel(bookID: '', purchaseVariants: []);

SaleItemBookPurchaseVariantModel emptySaleItemBookPurchaseVariant() =>
    SaleItemBookPurchaseVariantModel(
        purchaseID: '', originalPrice: 0, soldPrice: 0, quantity: 0);

@HiveType(typeId: DBItemHiveType.saleItemBookPurchaseVariant)
class SaleItemBookPurchaseVariantModel {
  @HiveField(0)
  String purchaseID;

  @HiveField(1)
  double originalPrice;

  @HiveField(2)
  double soldPrice;

  @HiveField(3)
  int quantity;

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'originalPrice': originalPrice,
      'soldPrice': soldPrice,
      'quantity': quantity
    };
  }

  SaleItemBookPurchaseVariantModel(
      {required this.purchaseID,
      required this.originalPrice,
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

  SaleItemBookModel({required this.bookID, required this.purchaseVariants});
}

@HiveType(typeId: DBItemHiveType.sale)
class SaleModel {
  @HiveField(0)
  final String saleID;

  @HiveField(1)
  final List<SaleItemBookModel> books;

  @HiveField(2)
  final double grandTotal;

  @HiveField(3)
  final String customerName;

  @HiveField(4)
  final String customerBatch;

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
  final bool deleted;

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
      'deleted': deleted,
      'books': books.map((b) => b.toJson()).toString()
    };
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
      required this.deleted,
      required this.saleID});
}
