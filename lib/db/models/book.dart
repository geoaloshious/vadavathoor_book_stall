import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'book.g.dart';

@HiveType(typeId: ItemType.book)
class BookModel {
  @HiveField(0)
  final String bookID;

  @HiveField(1)
  final String bookName;

  Map<String, dynamic> toJson() {
    return {'bookID': bookID, 'bookName': bookName};
  }

  Map<String, String> toDropdownData() {
    return {'id': bookID, 'name': bookName};
  }

  BookModel({required this.bookID, required this.bookName});
}
