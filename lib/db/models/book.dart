import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'book.g.dart';

BookModel emptyBookModel() => BookModel(
    bookID: '', bookName: '', price: '', discountPrice: '', inStockCount: 0);

@HiveType(typeId: ItemType.book)
class BookModel {
  @HiveField(0)
  final String bookID;

  @HiveField(1)
  final String bookName;

  @HiveField(2)
  final String price;

  @HiveField(3)
  String discountPrice;

  @HiveField(4)
  int inStockCount;

  Map<String, dynamic> toJson() {
    return {
      'bookID': bookID,
      'bookName': bookName,
      'price': price,
      'discountPrice': discountPrice,
      'inStockCount': inStockCount
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': bookID, 'name': bookName};
  }

  BookModel(
      {required this.bookID,
      required this.bookName,
      required this.price,
      required this.discountPrice,
      required this.inStockCount});
}
