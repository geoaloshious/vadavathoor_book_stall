import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book.g.dart';

@HiveType(typeId: DBItemHiveType.book)
class BookModel {
  @HiveField(0)
  final String bookID;

  @HiveField(1)
  final String bookName;

  @HiveField(2)
  String publisherID;

  @HiveField(3)
  String bookCategoryID;

  @HiveField(4)
  int status;

  Map<String, dynamic> toJson() {
    return {
      'bookID': bookID,
      'bookName': bookName,
      'publisherID': publisherID,
      'bookCategoryID': bookCategoryID,
      'status': status
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': bookID, 'name': bookName};
  }

  BookModel(
      {required this.bookID,
      required this.bookName,
      required this.publisherID,
      required this.bookCategoryID,
      required this.status});
}
