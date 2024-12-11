import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book.g.dart';

@HiveType(typeId: DBItemHiveType.book)
class BookModel {
  @HiveField(0)
  final String bookID;

  @HiveField(1)
  String bookName;

  @HiveField(2)
  String authorID;

  @HiveField(3)
  String publisherID;

  @HiveField(4)
  String bookCategoryID;

  @HiveField(5)
  int createdDate;

  @HiveField(6)
  String createdBy;

  @HiveField(7)
  int modifiedDate;

  @HiveField(8)
  String modifiedBy;

  @HiveField(9)
  int status;

  @HiveField(10)
  bool synced;

  Map<String, dynamic> toJson() {
    return {
      'bookID': bookID,
      'bookName': bookName,
      'authorID': authorID,
      'publisherID': publisherID,
      'bookCategoryID': bookCategoryID,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': bookID, 'name': bookName};
  }

  BookModel(
      {required this.bookID,
      required this.bookName,
      required this.authorID,
      required this.publisherID,
      required this.bookCategoryID,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status,
      required this.synced});
}
