import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'book_sale.g.dart';

BookSaleItemModel emptyBookSaleItem() => BookSaleItemModel(
    id: DateTime.now().millisecondsSinceEpoch,
    bookID: '',
    originalPrice: '',
    soldPrice: '',
    quantity: 0,
    itemType: SaleItemType.book);

@HiveType(typeId: ItemType.bookSaleItem)
class BookSaleItemModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String bookID;

  @HiveField(2)
  String originalPrice;

  @HiveField(3)
  String soldPrice;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  int itemType;

  BookSaleItemModel(
      {required this.id,
      required this.bookID,
      required this.originalPrice,
      required this.soldPrice,
      required this.quantity,
      required this.itemType});
}

@HiveType(typeId: ItemType.bookSale)
class BookSaleModel {
  @HiveField(0)
  final String saleID;

  @HiveField(1)
  final List<BookSaleItemModel> items;

  @HiveField(2)
  final double grandTotal;

  @HiveField(3)
  final String customerName;

  @HiveField(4)
  final String customerBatch;

  @HiveField(5)
  final int createdDate;

  @HiveField(6)
  int modifiedDate;

  @HiveField(7)
  final bool deleted;

  BookSaleModel(
      {required this.items,
      required this.grandTotal,
      required this.customerName,
      required this.customerBatch,
      required this.createdDate,
      required this.modifiedDate,
      required this.deleted,
      required this.saleID});
}
