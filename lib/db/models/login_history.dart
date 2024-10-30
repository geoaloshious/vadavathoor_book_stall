import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'login_history.g.dart';

@HiveType(typeId: DBItemHiveType.loginHistory)
class LoginHistoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String userID;

  @HiveField(2)
  int logInTime;

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
