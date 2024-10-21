import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'book_category.g.dart';

@HiveType(typeId: DBItemHiveType.bookCategory)
class BookCategoryModel {
  @HiveField(0)
  final String categoryID;

  @HiveField(1)
  String categoryName;

  @HiveField(2)
  final int createdDate;

  @HiveField(3)
  final String createdBy;

  @HiveField(4)
  int modifiedDate;

  @HiveField(5)
  String modifiedBy;

  @HiveField(6)
  int status;

  Map<String, dynamic> toJson() {
    return {
      'categoryID': categoryID,
      'categoryName': categoryName,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
      'status': status
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': categoryID, 'name': categoryName};
  }

  BookCategoryModel(
      {required this.categoryID,
      required this.categoryName,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status});
}
