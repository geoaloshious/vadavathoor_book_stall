import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'login_history.g.dart';

@HiveType(typeId: ItemType.loginHistory)
class LoginHistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userID;

  @HiveField(2)
  final int logInTime;

  @HiveField(3)
  int logOutTime;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'logInTime': logInTime,
      'logOutTime': logOutTime
    };
  }

  LoginHistoryModel(
      {required this.id,
      required this.userID,
      required this.logInTime,
      required this.logOutTime});
}
