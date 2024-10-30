import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book_author.g.dart';

@HiveType(typeId: DBItemHiveType.bookAuthor)
class BookAuthorModel {
  @HiveField(0)
  final String authorID;

  @HiveField(1)
  String authorName;

  @HiveField(2)
  int createdDate;

  @HiveField(3)
  String createdBy;

  @HiveField(4)
  int modifiedDate;

  @HiveField(5)
  String modifiedBy;

  @HiveField(6)
  int status;

  Map<String, dynamic> toJson() {
    return {
      'authorID': authorID,
      'authorName': authorName,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': authorID, 'name': authorName};
  }

  BookAuthorModel(
      {required this.authorID,
      required this.authorName,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status});
}
