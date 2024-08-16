import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book.g.dart';

BookModel emptyBookModel() => BookModel(bookID: '', bookName: '');

@HiveType(typeId: DBItemHiveType.book)
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
