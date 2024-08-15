import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'book_sale.g.dart';

SaleItemBookModel emptyBookSaleItem() =>
    SaleItemBookModel(bookID: '', purchaseVariants: []);

SaleItemBookPurchaseVariantModel emptySaleItemBookPurchaseVariant() =>
    SaleItemBookPurchaseVariantModel(
        purchaseID: '', originalPrice: 0, soldPrice: 0, quantity: 0);

@HiveType(typeId: ItemType.saleItemBookPurchaseVariant)
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

@HiveType(typeId: ItemType.saleItemBook)
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

@HiveType(typeId: ItemType.sale)
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
  final int createdDate;

  @HiveField(6)
  final String createdBy;

  @HiveField(7)
  int modifiedDate;

  @HiveField(8)
  String modifiedBy;

  @HiveField(9)
  final bool deleted;

  Map<String, dynamic> toJson() {
    return {
      'saleID': saleID,
      'grandTotal': grandTotal,
      'customerName': customerName,
      'customerBatch': customerBatch,
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
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.deleted,
      required this.saleID});
}
